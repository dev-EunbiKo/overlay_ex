import 'package:flutter/material.dart';
import 'package:overlay_ex/pages/widgets/custom_dropdown.dart';

class DropdownPage extends StatefulWidget {
  const DropdownPage({super.key});

  @override
  State<DropdownPage> createState() => _DropdownPageState();
}

class _DropdownPageState extends State<DropdownPage> {
  String? selectedValue;
  final List<String> items = [
    'Flutter',
    'Swift',
    'Kotlin',
    'Objective-C',
    'Vue.js',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Development Framework',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            CustomDropdown(
              items: items,
              value: selectedValue,
              hint: 'Select Framework',
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
            SizedBox(height: 20),
            if (selectedValue != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Selected >>> $selectedValue',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
