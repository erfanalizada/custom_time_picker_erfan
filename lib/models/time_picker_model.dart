import 'dart:math';
import 'package:flutter/material.dart';

class TimePickerModel {
  final TimeOfDay initialTime;
  DateTime selectedDate;
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final Color errorColor;
  final Color disabledColor;
  final String confirmText;
  final String cancelText;
  final String chooseTimeText;
  final String hourLabel;
  final String minuteLabel;

  late int _selectedHour;
  late int _selectedMinute;
  bool _isEditing = false;
  String? _errorMessage;

  // Modern color scheme with blue accent
  static const defaultPrimaryColor = Color(0xFF1976D2);    // Material Blue 700
  static const defaultBackgroundColor = Color.fromARGB(255, 240, 240, 240);      // Pure white
  static const defaultTextColor = Color(0xFF2C3E50);       // Dark blue-gray
  static const defaultErrorColor = Color(0xFFD32F2F);      // Material Red 700
  static const defaultDisabledColor = Color.fromARGB(255, 200, 198, 198);   // Light gray
  
  // Component-specific colors
  static const timeDisplayBackgroundColor = Color(0xFFE3F2FD); // Light blue 50
  static const selectedTimeColor = Color(0xFF1976D2);          // Same as primary
  static const wheelSelectedTextColor = Color(0xFF1976D2);     // Same as primary
  static const wheelUnselectedTextColor = Color(0xFFBDBDBD);   // Medium gray

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

  int get selectedHour => _selectedHour;
  int get selectedMinute => _selectedMinute;
  bool get isEditing => _isEditing;
  String? get errorMessage => _errorMessage;

  void setEditing(bool editing) {
    _isEditing = editing;
    if (!editing) _errorMessage = null;
  }

  String getFormattedTime() {
    return '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}';
  }

  bool _isToday() {
    final now = DateTime.now();
    return selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;
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

  void updateTime(int hour, int minute) {
    if (_isValidTime(hour, minute)) {
      _selectedHour = hour;
      _selectedMinute = minute;
      _errorMessage = null;
    } else {
      _errorMessage = 'Invalid time';
    }
  }

  void handleTimeInput(String input, TextEditingController controller) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 2) {
      final hours = digits.substring(0, 2);
      final minutes = digits.length > 2 ? digits.substring(2, min(4, digits.length)) : '';
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

  void clearError() {
    _errorMessage = null;
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate = newDate;
    updateTime(_selectedHour, _selectedMinute);
  }

  // Styles
  TextStyle get headerStyle => TextStyle(
    fontSize: 20, 
    fontWeight: FontWeight.w600,
    color: primaryColor,  // Changed from textColor to primaryColor
    letterSpacing: 0.15,
  );

  TextStyle get timeDisplayStyle => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: errorMessage != null ? errorColor : selectedTimeColor,
    letterSpacing: 0.5,
  );

  TextStyle get wheelLabelStyle => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textColor.withOpacity(0.6),
    letterSpacing: 0.4,
  );

  TextStyle getWheelNumberStyle(bool isSelected) => TextStyle(
    fontSize: isSelected ? 20 : 16,
    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
    color: isSelected ? wheelSelectedTextColor : wheelUnselectedTextColor,
    letterSpacing: 0.5,
  );

  TextStyle get cancelButtonStyle => TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  TextStyle get confirmButtonStyle => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  ButtonStyle get confirmButtonTheme => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}







