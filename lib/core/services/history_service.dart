import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/calculator_settings_provider.dart';
import '../config/app_config.dart';
import 'dart:io' as io;

class HistoryRecord {
  final String calculator;
  final Map<String, dynamic> inputs;
  final String result;
  final DateTime timestamp;

  HistoryRecord({
    required this.calculator,
    required this.inputs,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'calculator': calculator,
      'inputs': inputs,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      calculator: json['calculator'] as String,
      inputs: json['inputs'] as Map<String, dynamic>,
      result: json['result'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class HistoryService {
  static const String _historyKey = 'calculation_history';

  // 使用 AppConfig 中的配置
  static String get _historyFileName => AppConfig.historyFileName;

  // 获取默认历史记录存储目录
  static Future<String> getDefaultStoragePath() async {
    if (kIsWeb) {
      return AppConfig.webStorageText;
    }
    final directory = await getApplicationDocumentsDirectory();
    final historyDir = io.Directory('${directory.path}${io.Platform.pathSeparator}${AppConfig.historyStorageDirectoryName}');
    return historyDir.path;
  }

  // 获取默认历史记录文件完整路径
  static Future<String> getDefaultStorageFilePath() async {
    if (kIsWeb) {
      return AppConfig.webStorageText;
    }
    final directory = await getApplicationDocumentsDirectory();
    final historyDir = io.Directory('${directory.path}${io.Platform.pathSeparator}${AppConfig.historyStorageDirectoryName}');
    final filePath = '${historyDir.path}${io.Platform.pathSeparator}$_historyFileName';
    // 规范化路径，统一使用系统路径分隔符
    if (io.Platform.isWindows) {
      return filePath.replaceAll('/', '\\');
    } else {
      return filePath.replaceAll('\\', '/');
    }
  }

  // 获取历史记录文件路径（仅用于非 Web 平台）
  static Future<io.File> _getHistoryFile() async {
    if (kIsWeb) {
      throw UnsupportedError('File operations are not supported on Web platform');
    }
    io.Directory directory;

    // 优先使用自定义存储路径
    final customPath = await CalculatorSettingsProvider.getHistoryStoragePath();
    if (customPath != null && customPath.isNotEmpty) {
      directory = io.Directory(customPath);
      if (!await directory.exists()) {
        // 如果自定义路径不存在，创建它
        await directory.create(recursive: true);
      }
    } else {
      // 使用默认应用文档目录
      directory = await getApplicationDocumentsDirectory();
      final historyDir = io.Directory('${directory.path}${io.Platform.pathSeparator}${AppConfig.historyStorageDirectoryName}');
      if (!await historyDir.exists()) {
        await historyDir.create(recursive: true);
      }
      directory = historyDir;
    }

    return io.File('${directory.path}${io.Platform.pathSeparator}$_historyFileName');
  }

  // 从 SharedPreferences 迁移数据到文件（仅用于非 Web 平台）
  static Future<void> _migrateFromSharedPreferences() async {
    if (kIsWeb) {
      return; // Web 平台不需要迁移
    }
    try {
      final migrated = await CalculatorSettingsProvider.isHistoryMigrated();
      if (migrated) return; // 已经迁移过

      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyKey);

      if (historyJson != null && historyJson.isNotEmpty) {
        // 读取旧数据
        final List<dynamic> historyList = json.decode(historyJson);
        final history = historyList.map((item) => HistoryRecord.fromJson(item as Map<String, dynamic>)).toList();

        // 保存到文件
        await saveHistory(history);

        // 标记已迁移
        await CalculatorSettingsProvider.markHistoryMigrated();

        // 可选：清除 SharedPreferences 中的数据（保留作为备份）
        // await prefs.remove(_historyKey);
      } else {
        // 没有旧数据，直接标记为已迁移
        await CalculatorSettingsProvider.markHistoryMigrated();
      }
    } catch (e) {
      // 迁移失败，标记为已迁移以避免重复尝试
      await CalculatorSettingsProvider.markHistoryMigrated();
    }
  }

  static Future<List<HistoryRecord>> loadHistory() async {
    try {
      if (kIsWeb) {
        // Web 平台：使用 SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final historyJson = prefs.getString(_historyKey);
        if (historyJson == null || historyJson.isEmpty) {
          return [];
        }
        final List<dynamic> historyList = json.decode(historyJson);
        return historyList.map((item) => HistoryRecord.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        // 桌面平台：使用文件系统
        // 先尝试迁移旧数据
        await _migrateFromSharedPreferences();

        final file = await _getHistoryFile();
        if (!await file.exists()) {
          return [];
        }

        final content = await file.readAsString(encoding: utf8);
        if (content.isEmpty) return [];

        final List<dynamic> historyList = json.decode(content);
        return historyList.map((item) => HistoryRecord.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveHistory(List<HistoryRecord> history) async {
    try {
      final historyJson = json.encode(history.map((record) => record.toJson()).toList());

      if (kIsWeb) {
        // Web 平台：使用 SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_historyKey, historyJson);
      } else {
        // 桌面平台：使用文件系统
        final file = await _getHistoryFile();
        await file.writeAsString(historyJson, encoding: utf8);
      }
    } catch (e) {
      // Handle error
    }
  }

  static Future<void> addRecord(HistoryRecord record) async {
    final history = await loadHistory();
    history.insert(0, record);
    // 限制历史记录数量
    final limit = await CalculatorSettingsProvider.getHistoryLimit();
    if (history.length > limit) {
      history.removeRange(limit, history.length);
    }
    await saveHistory(history);
  }

  static Future<void> deleteRecord(int index) async {
    final history = await loadHistory();
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await saveHistory(history);
    }
  }

  static Future<void> clearHistory() async {
    try {
      if (kIsWeb) {
        // Web 平台：清除 SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_historyKey);
      } else {
        // 桌面平台：删除文件
        final file = await _getHistoryFile();
        if (await file.exists()) {
          await file.delete();
        }
        // 同时清除 SharedPreferences 中的旧数据（如果存在）
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_historyKey);
      }
    } catch (e) {
      // Handle error
    }
  }

  // 导出历史记录到文件
  static Future<String?> exportHistory() async {
    try {
      final history = await loadHistory();
      if (history.isEmpty) {
        return null;
      }

      final historyJson = json.encode(
        history.map((record) => record.toJson()).toList(),
      );

      if (kIsWeb) {
        // Web 平台：返回 JSON，由 UI 负责触发下载
        return historyJson;
      } else {
        // 桌面平台：保存到文件
        io.Directory? directory;

        // 1. 优先尝试“下载”目录（macOS / Windows / Linux 都支持）
        try {
          final downloadsDir = await getDownloadsDirectory();
          if (downloadsDir != null && await downloadsDir.exists()) {
            directory = downloadsDir;
          }
        } catch (_) {
          // 忽略，后面会自动降级到应用文档目录
        }

        // 2. 兼容部分环境（如 macOS 调试容器）拿不到 Downloads，尝试手动拼 HOME/Downloads
        if (directory == null) {
          final home = io.Platform.environment['HOME'];
          if (home != null && home.isNotEmpty) {
            final homeDownloads = io.Directory('$home${io.Platform.pathSeparator}Downloads');
            if (await homeDownloads.exists()) {
              directory = homeDownloads;
            }
          }
        }

        // 3. 确保目录存在，否则创建；若创建失败则降级为应用文档目录
        if (directory != null && !await directory.exists()) {
          try {
            await directory.create(recursive: true);
          } catch (_) {
            directory = null;
          }
        }

        // 4. 如果仍为空，降级到应用文档目录（始终可写）
        final appDocsDir = await getApplicationDocumentsDirectory();
        directory ??= appDocsDir;

        final timestamp = DateTime.now()
            .toIso8601String()
            .replaceAll(':', '-')
            .split('.')[0];
        const filePrefix = 'network_calculator_history_';
        const fileExt = '.json';
        final fileName = '$filePrefix$timestamp$fileExt';

        // 写入文件；如果当前目录不可写，自动降级到应用文档目录再写
        Future<String> _writeTo(io.Directory dir) async {
          final filePath = '${dir.path}${io.Platform.pathSeparator}$fileName';
          final file = io.File(filePath);
          await file.writeAsString(historyJson, encoding: utf8);
          return file.path;
        }

        String writtenPath;
        try {
          writtenPath = await _writeTo(directory);
        } catch (e) {
          // 如果不是应用文档目录，则降级再试一次
          if (directory.path != appDocsDir.path) {
            try {
              writtenPath = await _writeTo(appDocsDir);
            } catch (e2) {
              debugPrint('Export history failed after fallback: $e2');
              return null;
            }
          } else {
            debugPrint('Export history failed: $e');
            return null;
          }
        }

        // 导出成功后，在 macOS 上自动打开所在目录，方便用户查找
        try {
          if (io.Platform.isMacOS) {
            final dirPath = io.Directory(writtenPath).parent.path;
            await io.Process.run('open', [dirPath]);
          }
        } catch (e) {
          // 打开目录失败不影响导出结果
          debugPrint('Open export directory failed: $e');
        }

        // 规范化路径，仅用于展示（Windows 使用 \，Unix 使用 /）
        return writtenPath.replaceAll(RegExp(r'[/\\]'), io.Platform.pathSeparator);
      }
    } catch (e) {
      debugPrint('Export history failed: $e');
      return null;
    }
  }

  // 从文件导入历史记录（仅用于非 Web 平台）
  static Future<bool> importHistory(String filePath) async {
    if (kIsWeb) {
      return false; // Web 平台应使用 importHistoryFromContent
    }
    try {
      final file = io.File(filePath);
      if (!await file.exists()) {
        return false;
      }

      final content = await file.readAsString(encoding: utf8);
      return await importHistoryFromContent(content);
    } catch (e) {
      debugPrint('Import history failed: $e');
      return false;
    }
  }

  // 从内容字符串导入历史记录（用于 Web 平台）
  static Future<bool> importHistoryFromContent(String content) async {
    try {
      if (content.isEmpty) {
        return false;
      }

      final List<dynamic> historyList = json.decode(content);

      if (historyList.isEmpty) {
        return false;
      }

      // 验证数据格式
      for (var item in historyList) {
        if (item is! Map<String, dynamic>) {
          return false;
        }
        if (!item.containsKey('calculator') ||
            !item.containsKey('inputs') ||
            !item.containsKey('result') ||
            !item.containsKey('timestamp')) {
          return false;
        }
      }

      // 解析并合并历史记录
      final importedHistory = historyList
          .map((item) => HistoryRecord.fromJson(item as Map<String, dynamic>))
          .toList();

      final existingHistory = await loadHistory();

      // 合并历史记录，去重（基于时间戳和结果）
      final Map<String, HistoryRecord> uniqueRecords = {};

      // 先添加现有记录
      for (var record in existingHistory) {
        final key = '${record.timestamp.toIso8601String()}_${record.result}';
        uniqueRecords[key] = record;
      }

      // 添加导入的记录
      for (var record in importedHistory) {
        final key = '${record.timestamp.toIso8601String()}_${record.result}';
        uniqueRecords[key] = record;
      }

      // 转换为列表并按时间排序
      final mergedHistory = uniqueRecords.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // 限制数量
      final limit = await CalculatorSettingsProvider.getHistoryLimit();
      if (mergedHistory.length > limit) {
        mergedHistory.removeRange(limit, mergedHistory.length);
      }

      await saveHistory(mergedHistory);
      return true;
    } catch (e) {
      debugPrint('Import history from content failed: $e');
      return false;
    }
  }
}
