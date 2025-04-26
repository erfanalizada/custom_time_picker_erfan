import 'dart:math';
import 'package:flutter/material.dart';

class TimePickerModel {
  final TimeOfDay initialTime;
  final DateTime selectedDate;
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
  final IconData editIcon;

  late int _selectedHour;
  late int _selectedMinute;
  bool _isEditing = false;
  String? _errorMessage;

  static const defaultPrimaryColor = Colors.brown;
  static const defaultBackgroundColor = Colors.white;
  static const defaultTextColor = Colors.black87;
  static const defaultErrorColor = Colors.red;
  static const defaultDisabledColor = Colors.grey;

  TimePickerModel({
    required this.initialTime,
    required this.selectedDate,
    this.primaryColor = defaultPrimaryColor,
    this.backgroundColor = defaultBackgroundColor,
    this.textColor = defaultTextColor,
    this.errorColor = defaultErrorColor,
    this.disabledColor = defaultDisabledColor,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.chooseTimeText = 'Choose Time',
    this.hourLabel = 'hour',
    this.minuteLabel = 'min',
    this.editIcon = Icons.edit,
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

  // Styles
  TextStyle get headerStyle => TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor);
  TextStyle get timeDisplayStyle => TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: errorMessage != null ? errorColor : primaryColor);
  TextStyle get wheelLabelStyle => TextStyle(fontSize: 12, color: primaryColor.withOpacity(0.6));
  TextStyle getWheelNumberStyle(bool isSelected) => TextStyle(
    fontSize: isSelected ? 20 : 16,
    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    color: isSelected ? primaryColor : primaryColor.withOpacity(0.5),
  );
  TextStyle get cancelButtonStyle => TextStyle(color: primaryColor);
  TextStyle get confirmButtonStyle => const TextStyle(color: Colors.white);
  ButtonStyle get confirmButtonTheme => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

