/// A customizable time picker library for Flutter applications.
///
/// This library provides a highly customizable time picker that supports both
/// scroll wheels and manual text input to select a valid time. It also restricts
/// future times if the selected date is today.
///
/// The main components are:
/// * [CustomTimePickerErfan] - The widget that displays the time picker
/// * [showTimePickerErfan] - A function to show the time picker as a dialog
library;
import 'dart:math';
import 'package:custom_time_picker_erfan/models/time_picker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable time picker widget for Flutter applications.
/// 
/// This widget provides a highly customizable time picker that supports both
/// scroll wheels and manual text input to select a valid time. It also restricts
/// future times if the selected date is today.
///
/// Example:
/// ```dart
/// CustomTimePickerErfan(
///   initialTime: TimeOfDay.now(),
///   selectedDate: DateTime.now(),
///   primaryColor: Colors.blue,
///   backgroundColor: Colors.white,
/// )
/// ```
class CustomTimePickerErfan extends StatefulWidget {
  /// The initial time to display when the picker is first shown.
  final TimeOfDay initialTime;
  
  /// The selected date context for the time picker.
  /// Used to restrict future times if the date is today.
  final DateTime selectedDate;
  
  /// The primary color used for highlights, headers, and selected values.
  final Color primaryColor;
  
  /// The background color of the time picker dialog.
  final Color backgroundColor;
  
  /// The color used for text elements throughout the widget.
  final Color textColor;
  
  /// The color used to indicate errors in input validation.
  final Color? errorColor;
  
  /// The color used for disabled elements like buttons.
  final Color? disabledColor;
  
  /// The text to display on the confirm button.
  final String? confirmText;
  
  /// The text to display on the cancel button.
  final String? cancelText;
  
  /// The text to display as the header/title of the time picker.
  final String? chooseTimeText;
  
  /// Callback function that is called when the date changes.
  final ValueChanged<DateTime>? onDateChanged;

  /// Creates a customizable time picker widget.
  ///
  /// The [initialTime] and [selectedDate] parameters are required.
  /// Other parameters allow customization of colors and text labels.
  const CustomTimePickerErfan({
    super.key,
    required this.initialTime,
    required this.selectedDate,
    this.primaryColor = TimePickerModel.defaultPrimaryColor,
    this.backgroundColor = TimePickerModel.defaultBackgroundColor,
    this.textColor = TimePickerModel.defaultTextColor,
    this.errorColor,
    this.disabledColor,
    this.confirmText,
    this.cancelText,
    this.chooseTimeText,
    this.onDateChanged,
  });

  @override
  State<CustomTimePickerErfan> createState() => _CustomTimePickerErfanState();
}

class _CustomTimePickerErfanState extends State<CustomTimePickerErfan> {
  late final TimePickerModel _model;
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;
  final TextEditingController _timeController = TextEditingController();

  void updateSelectedDate(DateTime newDate) {
    setState(() {
      _model.updateSelectedDate(newDate);
      widget.onDateChanged?.call(newDate);
    });
  }

  @override
  void initState() {
    super.initState();
    _model = TimePickerModel(
      initialTime: widget.initialTime,
      selectedDate: widget.selectedDate,
      primaryColor: widget.primaryColor,
      backgroundColor: widget.backgroundColor,
      textColor: widget.textColor,
      errorColor: widget.errorColor ?? TimePickerModel.defaultErrorColor,
      disabledColor: widget.disabledColor ?? TimePickerModel.defaultDisabledColor,
      confirmText: widget.confirmText ?? 'Confirm',
      cancelText: widget.cancelText ?? 'Cancel',
      chooseTimeText: widget.chooseTimeText ?? 'Choose Time',
    );
    _timeController.text = _model.getFormattedTime();
    _hourController = FixedExtentScrollController(initialItem: _model.selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _model.selectedMinute);
  }

  @override
  void dispose() {
    _timeController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  bool _isToday() {
    final now = DateTime.now();
    return widget.selectedDate.year == now.year &&
        widget.selectedDate.month == now.month &&
        widget.selectedDate.day == now.day;
  }

  int _getMaxHour() {
    if (_isToday()) {
      return TimeOfDay.now().hour;
    }
    return 23;
  }

  int _getMaxMinute() {
    if (_isToday() && _model.selectedHour == TimeOfDay.now().hour) {
      return TimeOfDay.now().minute;
    }
    return 59;
  }

  bool _canConfirm() {
    final cleanText = _timeController.text.replaceAll(':', '');
    return _model.errorMessage == null && cleanText.length == 4;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: _model.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: min(screenWidth * 0.9, 400),
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_model.chooseTimeText, style: _model.headerStyle),
            SizedBox(height: screenHeight * 0.02),
            _buildTimeDisplay(screenHeight),
            SizedBox(height: screenHeight * 0.02),
            _buildTimeWheels(screenHeight),
            const SizedBox(height: 8),
            _buildActionButtons(screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplay(double screenHeight) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _model.setEditing(true);
          _timeController.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: TimePickerModel.timeDisplayBackgroundColor,  // Use model color instead of hardcoded
          border: Border.all(color: _model.primaryColor.withValues(alpha: 0.6)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          height: screenHeight * 0.07,
          child: Stack(
            children: [
              Center(
                child: _model.isEditing
                    ? TextField(
                        controller: _timeController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: _model.timeDisplayStyle,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _model.handleTimeInput(value, _timeController);
                            if (_model.errorMessage == null) {
                              _hourController.jumpToItem(_model.selectedHour);
                              _minuteController.jumpToItem(_model.selectedMinute);
                            }
                          });
                        },
                        onSubmitted: (_) {
                          setState(() {
                            _model.setEditing(false);
                            if (_timeController.text.isEmpty) {
                              _timeController.text = _model.getFormattedTime();
                              _model.clearError();
                            }
                          });
                        },
                        autofocus: true,
                      )
                    : Text(
                        _model.getFormattedTime(),
                        style: _model.timeDisplayStyle,
                        textAlign: TextAlign.center,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeWheels(double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeWheel(
          label: _model.hourLabel,
          value: _model.selectedHour,
          maxValue: _getMaxHour(),
          onChanged: (value) {
            setState(() {
              _model.updateTime(value, _model.selectedMinute);
              _timeController.text = _model.getFormattedTime();
            });
          },
          controller: _hourController,
          screenHeight: screenHeight,
        ),
        _buildTimeWheel(
          label: _model.minuteLabel,
          value: _model.selectedMinute,
          maxValue: _getMaxMinute(),
          onChanged: (value) {
            setState(() {
              _model.updateTime(_model.selectedHour, value);
              _timeController.text = _model.getFormattedTime();
            });
          },
          controller: _minuteController,
          screenHeight: screenHeight,
        ),
      ],
    );
  }

  Widget _buildTimeWheel({
    required String label,
    required int value,
    required int maxValue,
    required ValueChanged<int> onChanged,
    required FixedExtentScrollController controller,
    required double screenHeight,
  }) {
    return Column(
      children: [
        Text(label, style: _model.wheelLabelStyle),
        SizedBox(height: screenHeight * 0.01),
        SizedBox(
          height: screenHeight * 0.25,
          width: 70,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 50,  // Increased from 40 for better spacing
            diameterRatio: 2.0,  // Increased from default 2.0 for smoother curve
            perspective: 0.005,   // Reduced from default 0.003 for subtler 3D effect
            physics: const FixedExtentScrollPhysics(
              parent: BouncingScrollPhysics(), // Added bouncing effect
            ),
            overAndUnderCenterOpacity: 0.7, // Added fade effect for non-selected items
            magnification: 1.2,  // Added magnification for selected item
            useMagnifier: true,  // Enable magnification
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index > maxValue) return null;
                final isSelected = index == value;
                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: _model.getWheelNumberStyle(isSelected),
                    child: Text(
                      index.toString().padLeft(2, '0'),
                    ),
                  ),
                );
              },
              childCount: maxValue + 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(double screenHeight) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              minimumSize: Size(double.infinity, screenHeight * 0.065),
            ),
            child: Text(
              _model.cancelText,
              style: _model.cancelButtonStyle.copyWith(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: _canConfirm()
                ? () => Navigator.pop(
                      context,
                      TimeOfDay(hour: _model.selectedHour, minute: _model.selectedMinute),
                    )
                : null,
            style: _model.confirmButtonTheme.copyWith(
              minimumSize: WidgetStateProperty.all(Size(double.infinity, screenHeight * 0.065)),
            ),
            child: Text(
              _model.confirmText,
              style: _model.confirmButtonStyle,
            ),
          ),
        ),
      ],
    );
  }
}

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
