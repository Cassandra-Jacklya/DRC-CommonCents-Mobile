import 'package:flutter/material.dart';

import '../components/appbar.dart';

class SendEnquiry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Help and Support"),
          backgroundColor: const Color(0XFF3366FF),
          shadowColor: Colors.transparent,
        ),
        body: Column(
          children: [
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.all(10),
              child: const Text(
                  style: TextStyle(fontSize: 20),
                  'Thank you for contacting us. We have received your enquiry and will get back to you within 12 hours'),
            )
          ],
        ));
  }
}
