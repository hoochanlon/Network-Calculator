import 'dart:html' as html;

/// 在 Web 平台触发浏览器下载历史记录 JSON 文件
void downloadHistoryJson(String content, {String fileName = 'network_calculator_history.json'}) {
  final blob = html.Blob([content], 'application/json;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..download = fileName
    ..style.display = 'none';

  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();

  html.Url.revokeObjectUrl(url);
}


