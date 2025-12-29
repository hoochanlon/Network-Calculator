import '../../l10n/app_localizations.dart';

class ErrorMessageTranslator {
  static String translate(String errorMessage, AppLocalizations l10n) {
    // 移除可能的异常信息后缀
    String cleanMessage = errorMessage;
    if (errorMessage.contains(':')) {
      final parts = errorMessage.split(':');
      if (parts.length > 1) {
        cleanMessage = parts[0].trim();
      }
    }

    // 错误消息映射
    if (errorMessage.contains('Invalid IP address format') ||
        cleanMessage == 'Invalid IP address format') {
      return l10n.errorInvalidIpAddressFormat;
    }
    if (errorMessage.contains('Invalid IP or subnet mask format') ||
        cleanMessage == 'Invalid IP or subnet mask format') {
      return l10n.errorInvalidIpOrSubnetMaskFormat;
    }
    if (errorMessage.contains('Invalid subnet mask format') ||
        cleanMessage == 'Invalid subnet mask format') {
      return l10n.errorInvalidSubnetMaskFormat;
    }
    if (errorMessage.contains('Invalid CIDR format') ||
        cleanMessage == 'Invalid CIDR format') {
      return l10n.errorInvalidCidrFormat;
    }
    if (errorMessage.contains('Invalid CIDR, must be between /0 and /32') ||
        errorMessage.contains('must be between /0 and /32')) {
      return l10n.errorInvalidCidrRange;
    }
    if (errorMessage.contains('Invalid network format') ||
        cleanMessage == 'Invalid network format') {
      return l10n.errorInvalidNetworkFormat;
    }
    if (errorMessage.contains('Invalid input') ||
        cleanMessage == 'Invalid input') {
      return l10n.errorInvalidInput;
    }
    if (errorMessage.contains('Conversion failed') ||
        cleanMessage == 'Conversion failed') {
      return l10n.errorConversionFailed;
    }
    if (errorMessage.contains('Check failed') ||
        cleanMessage == 'Check failed') {
      return l10n.errorCheckFailed;
    }
    if (errorMessage.startsWith('Error:') ||
        cleanMessage == 'Error') {
      return l10n.errorGeneral;
    }
    if (errorMessage.contains('Decimal value out of range') ||
        cleanMessage == 'Decimal value out of range') {
      return l10n.errorDecimalOutOfRange;
    }
    if (errorMessage.contains('Host count must be at least 2') ||
        cleanMessage == 'Host count must be at least 2') {
      return l10n.errorHostCountMustBeAtLeast2;
    }
    if (errorMessage.contains('No networks provided') ||
        cleanMessage == 'No networks provided') {
      return l10n.errorNoNetworksProvided;
    }

    // 如果没有匹配，返回原消息（可能包含动态内容）
    return errorMessage;
  }
}

