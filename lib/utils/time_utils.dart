import 'package:flutter/material.dart';

/// Utility functions for time-related operations in the time picker.
///
/// This class provides helper methods for time validation, formatting,
/// and conversion between different time representations.
class TimeUtils {
  /// Validates if a given time string is in the correct format (HH:MM).
  ///
  /// @param timeString The time string to validate
  /// @return true if the format is valid, false otherwise
  static bool isValidTimeFormat(String timeString) {
    // Regular expression to validate HH:MM format
    final regex = RegExp(r'^([01]?[0-9]|2[0-3]):([0-5][0-9])$');
    return regex.hasMatch(timeString);
  }

  /// Converts a time string to a TimeOfDay object.
  ///
  /// @param timeString The time string in format HH:MM
  /// @return A TimeOfDay object representing the time
  /// @throws FormatException if the time string is invalid
  static TimeOfDay stringToTimeOfDay(String timeString) {
    if (!isValidTimeFormat(timeString)) {
      throw FormatException('Invalid time format: $timeString');
    }

    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Checks if a given time is in the future compared to the current time.
  ///
  /// @param time The time to check
  /// @return true if the time is in the future, false otherwise
  static bool isTimeInFuture(TimeOfDay time) {
    final now = TimeOfDay.now();
    return time.hour > now.hour ||
        (time.hour == now.hour && time.minute > now.minute);
  }
}
