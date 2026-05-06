// Patch: replace toARGB32() which isn't available in this Flutter SDK.
// In admin_dashboard_screen.dart line ~844, change:
//   'colorHex': data['colorHex'] ?? AppTheme.primary.toARGB32(),
// to:
//   'colorHex': data['colorHex'] ?? 0xFF2E3192,
