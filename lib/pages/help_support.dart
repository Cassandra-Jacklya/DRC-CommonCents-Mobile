import 'package:flutter/material.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.grey[300],
          title: const Text("Help and Support"),
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 25),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide.none),
                          labelText: 'Username',
                          filled: true,
                          fillColor: Colors.grey, // Set the fill color to grey
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 15,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        color: Colors.white,
                        child: const Center(
                          child: Text("Username"),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide.none),
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.grey, // Set the fill color to grey
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: const TextField(
                    obscureText: false,
                    maxLines: null, // Allows multiple lines
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enquiry',
                      filled: true,
                      fillColor: Colors.grey,
                      contentPadding: EdgeInsets.symmetric(
                          vertical:
                              150.0), // Set the vertical padding to achieve the desired height
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {Navigator.pop(context);},
                          child: Container(decoration: BoxDecoration(color: Colors.grey[500], borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.only(right: 25),
                              height: 50,
                              width: 120,
                              child: const Center(child: Text("Submit")),),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
