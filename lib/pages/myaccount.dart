import 'package:flutter/material.dart';
import 'citizenship.dart';
import 'package:iconsax/iconsax.dart';
import '../components/popup.dart';

class MyAccount extends StatefulWidget {
  final String photoUrl;
  final String displayName;
  final double balance;

  MyAccount({
    Key? key,
    required this.photoUrl,
    required this.displayName,
    required this.balance,
  }) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  DateTime? _selectedDate;
  String? _selectedCitizenship;
  TextEditingController textEditingController = TextEditingController();

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
        backgroundColor: Color(0XFF3366FF),
        title: const Text("My Account"),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 40),
            Hero(
              tag: 'test',
              child: ClipOval(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.photoUrl.isNotEmpty
                          ? NetworkImage(widget.photoUrl)
                          : NetworkImage(
                              'https://static01.nyt.com/newsgraphics/2019/08/01/candidate-pages/3b31eab6a3fd70444f76f133924ae4317567b2b5/trump-circle.png',
                            ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF5F5F5F))),
                  labelText: 'Username',
                  hintText: 'ben',
                  suffixIcon: const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _navigateToCitizenship(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(width: 0.6, color: const Color(0xFF5F5F5F)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCitizenship ?? 'Citizenship',
                      style: const TextStyle(
                          color: Color(0xFF5F5F5F), fontSize: 16),
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
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(width: 0.6, color: const Color(0xFF5F5F5F)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? "${_selectedDate!.day} / ${_selectedDate!.month} / ${_selectedDate!.year}"
                          : 'Date of Birth',
                      style: const TextStyle(color: Color(0xFF5F5F5F), fontSize: 16),
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
                    color: Color(0xFF3366FF),
                  ),
                  child: const Center(
                    child: Text("Save", style: TextStyle(color: Colors.white,fontSize: 20)),
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
