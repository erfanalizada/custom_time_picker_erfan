import 'package:custom_time_picker_erfan/custom_time_picker_erfan.dart';
import 'package:custom_time_picker_erfan/models/time_picker_model.dart';
import 'package:flutter/material.dart';

Future<TimeOfDay?> showTimePickerErfan({
  required BuildContext context,
  required TimeOfDay initialTime,
  DateTime? selectedDate,
  ValueChanged<DateTime>? onDateChanged,
  Color primaryColor = TimePickerModel.defaultPrimaryColor,
  Color backgroundColor = TimePickerModel.defaultBackgroundColor,
  Color textColor = TimePickerModel.defaultTextColor,
  Color? errorColor,
  Color? disabledColor,
  String? confirmText,
  String? cancelText,
  String? chooseTimeText,
}) {
  return showDialog<TimeOfDay>(
    context: context,
    builder: (context) => CustomTimePickerErfan(
      initialTime: initialTime,
      selectedDate: selectedDate ?? DateTime.now(),
      onDateChanged: onDateChanged,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      textColor: textColor,
      errorColor: errorColor,
      disabledColor: disabledColor,
      confirmText: confirmText,
      cancelText: cancelText,
      chooseTimeText: chooseTimeText,
    ),
  );
}
