# 📆 Custom Time Picker Erfan

A highly customizable, editable, and responsive time picker widget for Flutter.
Supports both scroll wheels and manual text input to pick a valid time — and restricts future times if the selected date is today.

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
  custom_time_picker_erfan: ^0.0.1
```
Then run:

flutter pub get

## Usage

```dart
import 'package:custom_time_picker_erfan/custom_time_picker_erfan.dart';

// inside your function
void _pickTime(BuildContext context) async {
  final selectedTime = await showTimePickerErfan(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (selectedTime != null) {
    print('Picked time: ${selectedTime.format(context)}');
  }
}

```
### Full Example

```dart
ElevatedButton(
  onPressed: () async {
    final pickedTime = await showTimePickerErfan(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 30),
      primaryColor: Colors.blue[700],
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      textColor: const Color(0xFF2C3E50),
      confirmText: "Confirm",
      cancelText: "Cancel",
      chooseTimeText: "Choose Time",
      hourLabel: "hour",
      minuteLabel: "min",
    );

    if (!mounted) return;

    if (pickedTime != null) {
      debugPrint('Selected time: ${pickedTime.format(context)}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected time: ${pickedTime.format(context)}')),
      );
    }
  },
  child: const Text("Open Custom Time Picker"),
)
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





