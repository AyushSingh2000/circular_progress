import 'package:flutter/material.dart';

import 'circular_progress.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<DashedCircularProgressIndicatorState> _progressKey =
      GlobalKey<DashedCircularProgressIndicatorState>();
  final TextEditingController _controller = TextEditingController();

  // Initial colors
  Color _filledColor = Colors.blue;
  Color _unfilledColor = Colors.grey;

  // Available color options
  final Map<String, Color> _colorOptions = {
    'Red': Colors.red,
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Grey': Colors.grey,
    'Yellow': Colors.yellow,
    'Orange': Colors.orange,
    'Pink': Colors.pink,
  };

  String _selectedFilledColor = 'Blue';
  String _selectedUnfilledColor = 'Grey';

  void _updateProgress() {
    double? inputValue = double.tryParse(_controller.text);
    if (inputValue != null && inputValue >= 0.0 && inputValue <= 1.0) {
      _progressKey.currentState?.updateProgress(inputValue);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a value between 0.0 and 1.0')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DashedCircularProgressIndicator(
          key: _progressKey,
          progress: 0.5,
          strokeWidth: 4.0,
          filledColor: _filledColor,
          unfilledColor: _unfilledColor,
          duration: Duration(seconds: 2),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter progress (0.0 to 1.0)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedFilledColor,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilledColor = newValue!;
                  _filledColor = _colorOptions[_selectedFilledColor]!;
                });
              },
              items: _colorOptions.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(width: 20),
            DropdownButton<String>(
              value: _selectedUnfilledColor,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUnfilledColor = newValue!;
                  _unfilledColor = _colorOptions[_selectedUnfilledColor]!;
                });
              },
              items: _colorOptions.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _updateProgress,
          child: Text("Update Progress"),
        ),
      ],
    );
  }
}
