import 'package:custom_time_picker_erfan/custom_time_picker_erfan.dart';
import 'package:custom_time_picker_erfan/models/time_picker_model.dart';
import 'package:flutter/material.dart';

/// Shows a customizable time picker dialog and returns the selected time.
///
/// This function displays a dialog with a customizable time picker and returns
/// the selected [TimeOfDay] when the user confirms, or null if the user cancels.
///
/// Parameters:
/// - [context]: The build context in which to show the dialog.
/// - [initialTime]: The time to display when the picker is first shown.
/// - [selectedDate]: Optional date context for the time picker (defaults to today).
/// - [onDateChanged]: Optional callback for when the date changes.
/// - [primaryColor], [backgroundColor], [textColor], [errorColor], [disabledColor]:
///   Colors for customizing the appearance of the time picker.
/// - [confirmText], [cancelText], [chooseTimeText]: Custom text labels.
///
/// Returns a [Future] that completes with the selected [TimeOfDay] or null.
///
/// Example:
/// ```dart
/// final TimeOfDay? result = await showTimePickerErfan(
///   context: context,
///   initialTime: TimeOfDay.now(),
/// );
/// if (result != null) {
///   print('Selected time: ${result.format(context)}');
/// }
/// ```
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
