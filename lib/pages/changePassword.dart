import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 60,
          backgroundColor: Color(0XFF3366FF),
          title: const Text("Change Password"),
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.only(top: 40, bottom: 30),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF5F5F5F))),
                  labelText: 'New Password',
                  // hintText: 'ben',
                  suffixIcon: const Icon(Icons.person),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.only(bottom: 30),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF5F5F5F))),
                  labelText: 'Confirm Password',
                  // hintText: 'ben',
                  suffixIcon: const Icon(Icons.person),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0XFF3366FF),
                      borderRadius: BorderRadius.circular(10),),
                  margin: const EdgeInsets.only(top: 10, right: 30),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const Center(child: Text(style: TextStyle(color: Colors.white),"Save")),
                ),
              ),
            ),
          ],
        ));
  }
}
