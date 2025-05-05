import 'dart:math';
import 'package:flutter/material.dart';

/// Model class that manages the state and styling for the CustomTimePickerErfan widget.
///
/// This class encapsulates all the data and logic needed for the time picker,
/// including selected time values, date context, colors, text styles, and validation.
class TimePickerModel {
  /// The initial time value that the time picker will display when first shown.
  /// This is used to set the starting position of the hour and minute wheels.
  final TimeOfDay initialTime;

  /// The date context for the time picker, used to determine if future times should be restricted.
  /// If this date is today, times later than the current time will be disabled.
  DateTime selectedDate;

  /// The primary color used for highlights, headers, selected values, and the confirm button.
  final Color primaryColor;

  /// The background color of the time picker dialog.
  final Color backgroundColor;

  /// The general text color used throughout the time picker.
  final Color textColor;

  /// The color used to indicate errors in input validation.
  final Color errorColor;

  /// The color used for disabled elements like buttons.
  final Color disabledColor;

  /// The text to display on the confirm button.
  final String confirmText;

  /// The text to display on the cancel button.
  final String cancelText;

  /// The text to display as the header/title of the time picker.
  final String chooseTimeText;

  /// The label text displayed above the hour selection wheel.
  final String hourLabel;

  /// The label text displayed above the minute selection wheel.
  final String minuteLabel;

  late int _selectedHour;
  late int _selectedMinute;
  bool _isEditing = false;
  String? _errorMessage;

  /// The default primary color used for highlights, headers, selected values, and the confirm button.
  /// Material Blue 700 (#1976D2).
  static const defaultPrimaryColor = Color(0xFF1976D2);

  /// The default background color of the time picker dialog.
  /// Light gray (#F0F0F0).
  static const defaultBackgroundColor = Color.fromARGB(255, 240, 240, 240);

  /// The default general text color used throughout the time picker.
  /// Dark blue-gray (#2C3E50).
  static const defaultTextColor = Color(0xFF2C3E50);

  /// The default color used to indicate errors in input validation.
  /// Material Red 700 (#D32F2F).
  static const defaultErrorColor = Color(0xFFD32F2F);

  /// The default color used for disabled elements like buttons.
  /// Light gray (#C8C6C6).
  static const defaultDisabledColor = Color.fromARGB(255, 200, 198, 198);

  /// The background color for the time display component.
  /// Light blue 50 (#E3F2FD).
  static const timeDisplayBackgroundColor = Color(0xFFE3F2FD);

  /// The color used for the selected time text.
  /// Same as primary color (#1976D2).
  static const selectedTimeColor = Color(0xFF1976D2);

  /// The text color for the selected item in time wheels.
  /// Same as primary color (#1976D2).
  static const wheelSelectedTextColor = Color(0xFF1976D2);

  /// The text color for unselected items in time wheels.
  /// Medium gray (#BDBDBD).
  static const wheelUnselectedTextColor = Color(0xFFBDBDBD);

  /// Creates a new TimePickerModel with the specified parameters.
  ///
  /// @param initialTime The initial time value that the time picker will display when first shown.
  /// @param selectedDate The date context for the time picker, used to determine if future times should be restricted.
  /// @param primaryColor The primary color used for highlights, headers, selected values, and the confirm button.
  /// @param backgroundColor The background color of the time picker dialog.
  /// @param textColor The general text color used throughout the time picker.
  /// @param errorColor The color used to indicate errors in input validation.
  /// @param disabledColor The color used for disabled elements like buttons.
  /// @param confirmText The text to display on the confirm button.
  /// @param cancelText The text to display on the cancel button.
  /// @param chooseTimeText The text to display as the header/title of the time picker.
  /// @param hourLabel The label text displayed above the hour selection wheel.
  /// @param minuteLabel The label text displayed above the minute selection wheel.
  TimePickerModel({
    required this.initialTime,
    required this.selectedDate,
    this.primaryColor = defaultPrimaryColor,
    this.backgroundColor = defaultBackgroundColor,
    this.textColor = const Color.fromARGB(255, 30, 85, 139),
    this.errorColor = defaultErrorColor,
    this.disabledColor = defaultDisabledColor,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.chooseTimeText = 'Choose Time',
    this.hourLabel = 'hour',
    this.minuteLabel = 'min',
  }) {
    _selectedHour = initialTime.hour;
    _selectedMinute = initialTime.minute;
  }

  /// Gets the currently selected hour (0-23).
  int get selectedHour => _selectedHour;

  /// Gets the currently selected minute (0-59).
  int get selectedMinute => _selectedMinute;

  /// Indicates whether the time picker is in editing mode (manual text input).
  bool get isEditing => _isEditing;

  /// Returns any error message related to time validation, or null if the time is valid.
  String? get errorMessage => _errorMessage;

  /// Sets the editing mode of the time picker.
  ///
  /// When editing is set to false, any error messages are cleared.
  /// @param editing Whether the time picker should be in editing mode.
  void setEditing(bool editing) {
    _isEditing = editing;
    if (!editing) _errorMessage = null;
  }

  /// Returns the selected time formatted as a string in 24-hour format (HH:MM).
  ///
  /// The hours and minutes are zero-padded to ensure they are always two digits.
  /// @return A string representation of the selected time.
  String getFormattedTime() {
    return '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}';
  }

  bool _isToday() {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  bool _isValidTime(int hour, int minute) {
    if (_isToday()) {
      final now = TimeOfDay.now();
      if (hour > now.hour || (hour == now.hour && minute > now.minute)) {
        return false;
      }
    }
    return hour >= 0 && hour < 24 && minute >= 0 && minute < 60;
  }

  /// Updates the selected time with the provided hour and minute values.
  ///
  /// Validates the time before updating. If the time is invalid (e.g., future time on today's date),
  /// sets an error message instead of updating the time.
  /// @param hour The hour value to set (0-23)
  /// @param minute The minute value to set (0-59)
  void updateTime(int hour, int minute) {
    if (_isValidTime(hour, minute)) {
      _selectedHour = hour;
      _selectedMinute = minute;
      _errorMessage = null;
    } else {
      _errorMessage = 'Invalid time';
    }
  }

  /// Handles manual time input from a text field.
  ///
  /// Formats the input as a time string (HH:MM) and updates the time if valid.
  /// @param input The raw input string from the text field
  /// @param controller The text editing controller to update with formatted text
  void handleTimeInput(String input, TextEditingController controller) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 2) {
      final hours = digits.substring(0, 2);
      final minutes =
          digits.length > 2 ? digits.substring(2, min(4, digits.length)) : '';
      final formatted = '$hours:$minutes';
      controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      if (digits.length >= 4) {
        final h = int.tryParse(digits.substring(0, 2));
        final m = int.tryParse(digits.substring(2, 4));
        if (h != null && m != null) updateTime(h, m);
      }
    } else {
      controller.value = TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }
  }

  /// Clears any error message that may be displayed.
  void clearError() {
    _errorMessage = null;
  }

  /// Updates the selected date context and validates the current time against it.
  ///
  /// If the new date is today, future times will be restricted.
  /// @param newDate The new date to set as context for time validation
  void updateSelectedDate(DateTime newDate) {
    selectedDate = newDate;
    updateTime(_selectedHour, _selectedMinute);
  }

  // Styles
  /// Returns the text style for the header/title of the time picker.
  TextStyle get headerStyle => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: primaryColor, // Changed from textColor to primaryColor
    letterSpacing: 0.15,
  );

  /// Returns the text style for the time display component.
  TextStyle get timeDisplayStyle => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: errorMessage != null ? errorColor : selectedTimeColor,
    letterSpacing: 0.5,
  );

  /// Returns the text style for the wheel labels (hour/min).
  TextStyle get wheelLabelStyle => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textColor.withValues(alpha: 0.6),
    letterSpacing: 0.4,
  );

  /// Returns the text style for numbers in the time selection wheels.
  ///
  /// @param isSelected Whether the number is currently selected
  TextStyle getWheelNumberStyle(bool isSelected) => TextStyle(
    fontSize: isSelected ? 20 : 16,
    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
    color: isSelected ? wheelSelectedTextColor : wheelUnselectedTextColor,
    letterSpacing: 0.5,
  );

  /// Returns the text style for the cancel button.
  TextStyle get cancelButtonStyle => TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  /// Returns the text style for the confirm button.
  TextStyle get confirmButtonStyle => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  /// Returns the button style for the confirm button.
  ButtonStyle get confirmButtonTheme => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
