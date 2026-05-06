class SecurityUtils {
  /// Masks an email address for privacy.
  /// example@email.com -> ex****@email.com
  static String maskEmail(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final name = parts[0];
    final domain = parts[1];
    
    if (name.length <= 2) return '***@$domain';
    
    return '${name.substring(0, 2)}****@$domain';
  }

  /// Masks a sensitive value (like a credit card or bank account).
  /// 1234567890 -> ******7890
  static String maskSensitiveValue(String value, {int visibleChars = 4}) {
    if (value.length <= visibleChars) return value;
    final maskedLength = value.length - visibleChars;
    return '*' * maskedLength + value.substring(maskedLength);
  }

  /// Sanitizes a string by removing potential harmful characters.
  /// (Basic version for UI display/input)
  static String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'[<>{}\[\]\\\/]'), '') // Remove basic injection-like chars
        .trim();
  }

  /// Validates a password's strength.
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }
}
