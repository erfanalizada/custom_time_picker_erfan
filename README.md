# 📆 Custom Time Picker Erfan

A highly customizable, editable, and responsive time picker widget for Flutter.
Supports both scroll wheels and manual text input to pick a valid time — and restricts future times if the selected date is 
today.

# ☕ Support

If you find this package helpful, consider supporting my work:

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20me%20a%20coffee-%23FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/erfan1)


## ✨ Features


📜 Wheel Scrolling: Pick hours and minutes via scrollable wheels.

⌨️ Manual Typing: Tap to type time directly (with validation).

📅 Today-Aware: Restricts selecting future times if today is selected.

🎨 Customizable UI: Customize primary, background, text, error, and disabled colors.

📝 Customizable Labels: Customizable button texts and choose-time prompt.

📱 Responsive: Looks good on any screen size.

❗ Input Validation: Only valid times are allowed (with automatic error handling).

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_time_picker_erfan: ^0.0.4
```
Then run:

flutter pub get

## Full usage example in a Screen

```dart
import 'package:flutter/material.dart';
import 'package:custom_time_picker_erfan/custom_time_picker_erfan.dart';

class TimePickerScreen extends StatefulWidget {
  const TimePickerScreen({super.key});

  @override
  State<TimePickerScreen> createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Picker Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Time: ${selectedTime?.format(context) ?? "No time selected"}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePickerErfan(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                  primaryColor: Colors.deepPurple,
                  backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                  textColor: const Color(0xFF2C3E50),
                  confirmText: "Confirm",
                  cancelText: "Cancel",
                  chooseTimeText: "Choose Time",
                );
                if (picked != null && mounted) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
              child: const Text('Select Time'),
            ),
          ],
        ),
      ),
    );
  }
}


```

# Additional information

## 🛠 Customization Options

Parameter | Type | Description | Default
initialTime | TimeOfDay | Initial selected time. | Required
selectedDate | DateTime | Date that determines if future time is allowed. | DateTime.now()
primaryColor | Color | Color for main buttons, header, etc. | Colors.blue[700]
backgroundColor | Color | Dialog background color. | Light grey (240, 240, 240)
textColor | Color | General text color. | Dark blue-gray
errorColor | Color? | Color for errors. | Material Red 700
disabledColor | Color? | Color for disabled states. | Light grey
confirmText | String? | Confirm button text. | "Confirm"
cancelText | String? | Cancel button text. | "Cancel"
chooseTimeText | String? | Header text. | "Choose Time"
hourLabel | String? | Label for hour wheel | "hour"
minuteLabel | String? | Label for minute wheel | "min"


## 📋 Behavior Details

Editing: When the user taps on the time display, it switches to a TextField for direct input.

### Validation:

Only 4 digits allowed (HHMM).

Auto-formats input to HH:MM style.

Restricts selection to valid times (e.g., prevents selecting 25:61).

If today is selected as date: you cannot select future hours/minutes compared to now.

Scroll Sync: After manual typing, the scroll wheels jump automatically to the correct position if input is valid.


## 🎨 UI and Theming

Primary Color: Used for highlights, headers, selected numbers, confirm button.

Background Color: Dialog background.

Error Color: Applied to text input if invalid.

Text Colors: Applied across the widget.

Disabled Color: Applied to disabled states (like a disabled confirm button).


## ❓ FAQ
Q: Can I disable editing?
No, editing is always allowed by tapping the time field. You can customize the icon to guide users though.

Q: Does it support AM/PM format?
Not directly; it uses 24-hour format for simplicity. You can convert it manually using Flutter's built-in methods if needed.

Q: Does it block future dates?
Only future times for today are blocked. Future dates allow any time.

# 👨‍💻 Contributing

If you'd like to contribute improvements, feel free to fork the repository and open a PR!

# 📃 License

MIT License


For more information on the code and structure, please visit [https://github.com/erfanalizada/custom_time_picker_erfan]





## 📝 API Documentation

This package follows Dart's documentation standards to ensure good code readability and usability.

### Documentation Coverage

All public API elements include dartdoc comments that explain:
- What the element does
- Parameters and their purpose
- Return values
- Usage examples where appropriate

### Viewing Documentation

You can view the full API documentation on [pub.dev](https://pub.dev/documentation/custom_time_picker_erfan/latest/).

### For Contributors

When contributing to this package, please ensure all public API elements have proper documentation:

1. Document all public classes, methods, properties, and functions
2. Use `///` triple-slash comments for dartdoc
3. Include parameter descriptions with `@param` tags
4. Describe return values with `@return` tags
5. Add examples with `/// Example:` followed by code blocks

Example of good documentation:

```dart
/// A customizable time picker widget that supports both wheel scrolling and manual input.
/// 
/// This widget provides a dialog with time selection capabilities through either
/// scrollable wheels or direct text input, with validation for both methods.
/// 
/// @param initialTime The time to display when the picker is first shown.
/// @param selectedDate The date context for the time picker, used to restrict future times.
/// @param primaryColor The main color used for highlights and selected values.
/// @return A [TimeOfDay] object representing the selected time, or null if canceled.
/// 
/// Example:
/// ```dart
/// final TimeOfDay? result = await showTimePickerErfan(
///   context: context,
///   initialTime: TimeOfDay.now(),
/// );
/// ```
```

The package uses the `public_member_api_docs` lint rule to ensure documentation coverage.


