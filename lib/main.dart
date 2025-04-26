import 'package:custom_time_picker_erfan/custom_time_picker_erfan.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Screen(),
    );
  }
}

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final time = await showTimePickerErfan(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              final pickedTime = await showTimePickerErfan(
                context: context,
                initialTime: TimeOfDay.now(),
                selectedDate: DateTime(2024, 1, 1),
                confirmText: "Ok",
                cancelText: "Back",
                chooseTimeText: "Select a time",
              );
              if (pickedTime != null) {
                print('Selected time: ${pickedTime.format(context)}');
              }
            }
          },
          child: const Text('Pick Time'),
        ),
      ),
    );
  }
}
