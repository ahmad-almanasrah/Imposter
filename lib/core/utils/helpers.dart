import 'dart:developer' as developer;

/// General utility functions
abstract final class Helpers {
  /// Format DateTime into YYYY-MM-DD
  static String formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Basic email format validator
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }

  /// Structured console logger
  static void log(String message, {String tag = 'APP', Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
