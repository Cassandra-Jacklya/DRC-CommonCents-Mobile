import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  String selectedValue = 'Option 1';
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQs"),
        backgroundColor: const Color(0XFF3366FF),
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: const Text(
                    "Frequently Asked Questions",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Image.asset('assets/images/commoncents-logo.png')
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Container(
                    color: Colors.grey[300],
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(selectedValue),
                          ),
                        ),
                        Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[100],
                    child: Column(
                      children: const [
                        // More information here
                        Text('Additional Information'),
                        SizedBox(height: 10),
                        Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                        // Add more widgets as needed
                      ],
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
