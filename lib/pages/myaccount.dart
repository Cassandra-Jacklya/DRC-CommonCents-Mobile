import 'package:flutter/material.dart';
import 'citizenship.dart';
import 'package:iconsax/iconsax.dart';
import '../components/popup.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  DateTime? _selectedDate;
  String? _selectedCitizenship;

  void _navigateToCitizenship(BuildContext context) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => Citizenship()),
    );

    if (result != null) {
      setState(() {
        _selectedCitizenship = result;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        toolbarHeight: 60,
        backgroundColor: Colors.grey[300],
        title: const Text("My Account"),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 50),
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  suffixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => _navigateToCitizenship(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCitizenship ?? 'Citizenship',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? "${_selectedDate!.day} / ${_selectedDate!.month} / ${_selectedDate!.year}"
                          : 'Date of Birth',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AccountSettings();
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 30, top: 30),
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[400],
                  ),
                  child: const Center(
                    child: Text("Save", style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
