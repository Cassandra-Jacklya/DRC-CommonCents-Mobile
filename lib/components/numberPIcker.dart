// ignore: file_names
import 'package:flutter/material.dart';

class IntegerExample extends StatefulWidget {
  const IntegerExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IntegerExampleState createState() => _IntegerExampleState();
}

class _IntegerExampleState extends State<IntegerExample> {
  int currentHorizontalIntValue = 10;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => setState(() {
            final newValue = currentHorizontalIntValue - 10;
            currentHorizontalIntValue = newValue.clamp(0, 100);
            _controller.text = currentHorizontalIntValue.toString();
          }),
        ),
        Expanded(
          child: TextField( textAlign: TextAlign.center,
            controller: _controller,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                currentHorizontalIntValue = int.tryParse(value) ?? 0;
              });
            },
            decoration: InputDecoration(
              // labelText: 'USD',
              hintText: 'USD',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => setState(() {
            final newValue = currentHorizontalIntValue + 10;
            currentHorizontalIntValue = newValue.clamp(0, 100);
            _controller.text = currentHorizontalIntValue.toString();
          }),
        ),
      ],
    );
  }
}
