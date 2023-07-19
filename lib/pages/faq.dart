import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;
  bool _isExpanded4 = false;
  bool _isExpanded5 = false;

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
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: const Text(
                    "Frequently Asked Questions",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Image.asset('assets/images/commoncents-logo.png')
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded1 = !_isExpanded1;
                        });
                      },
                      child: _isExpanded1
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black)),
                              child: Container(
                                //expanded
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: const EdgeInsets.all(0),
                                // height: MediaQuery.of(context).size.height * 0.23,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      //not expanded
                                      decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.all(10),
                                      // color: Colors.green,
                                      child: Row(
                                        children: const [
                                        Icon(FontAwesomeIcons.dollarSign),
                                          SizedBox(
                                            width: 260,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Text(
                                                  "Do I need to pay to use the application?", maxLines: 2,),
                                            ),
                                          ),
                                          Icon(Icons.expand_more),
                                        ],
                                      ),
                                    ),
                                    
                                    Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey))),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: SizedBox(
                                        width: 300,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                                          child: Text(
                                              "Absolutely not! The feature provides demo funds for you to use and does not require any deposit of real money.", maxLines: 3,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                            
                              //not expanded
                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.all(10),
                              // color: Colors.green,
                              child: Expanded(
                                child: Row(
                                  children: const [
                                   Icon(FontAwesomeIcons.dollarSign),
                                    SizedBox(
                                      width: 260,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: Text(
                                            "Do I need to pay to use the application?", maxLines: 2,),
                                      ),
                                    ),
                                    Icon(Icons.expand_more),
                                  ],
                                ),
                              ),
                            )),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded2 = !_isExpanded2;
                        });
                      },
                      child: _isExpanded2
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black)),
                              child: Container(
                                //expanded
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(0),
                                // height: MediaQuery.of(context).size.height * 0.23,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //not expanded
                                      decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.all(10),
                                      // color: Colors.green,
                                      child: Row(
                                        children: [
                                          const Icon(
                                              FontAwesomeIcons.question),
                                          SizedBox(
                                            width: 260,
                                            child: Padding(
                                                padding: EdgeInsets.only(left: 16),
                                                child: Text(
                                                    "I'm not familiar with trading, how can I get started with CommonCents?")),
                                          ),
                                          const Icon(Icons.expand_more),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey))),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: SizedBox(
                                        width: 300,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 30),
                                          child: Text(
                                              "Definitely! CommonCents was designed to cater for absolute beginners.", maxLines: 3,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              //not expanded
                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.all(10),
                              // color: Colors.green,
                              child: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(FontAwesomeIcons.question),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: const Text(
                                              "I'm not familiar with trading, how can I get started with CommonCents?",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.visible),
                                            ),
                                          )),
                                    ],
                                  ),
                                  const Icon(Icons.expand_more),
                                ],
                              ),
                            )),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded3 = !_isExpanded3;
                        });
                      },
                      child: _isExpanded3
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black)),
                              child: Container(
                                //expanded
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: const EdgeInsets.all(0),
                                // height: MediaQuery.of(context).size.height * 0.23,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //not expanded
                                      decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.all(10),
                                      // color: Colors.green,
                                      child: Row(
                                        children: [
                                          Icon(FontAwesomeIcons
                                              .arrowPointer),
                                          SizedBox(
                                            width: 260,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Text(
                                                "What trading market is CommonCents \nfocused on?",),
                                            ),
                                          ),
                                          const Icon(Icons.expand_more),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey))),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: SizedBox(
                                        width: 300,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                                          child: Text(
                                              "CommonCents only focuses on synthetic trading as it is one of the markets that people are afraid\n of getting into due to the risks.", maxLines: 5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              //not expanded
                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.all(10),
                              // color: Colors.green,
                              child: Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(FontAwesomeIcons.arrowPointer),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                              "What trading market is CommonCents \nfocused on?"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.expand_more),
                                ],
                              ),
                            )),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded4 = !_isExpanded4;
                        });
                      },
                      child: _isExpanded4
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black)),
                              child: Container(
                                //expanded
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: const EdgeInsets.all(0),
                                // height: MediaQuery.of(context).size.height * 0.23,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //not expanded
                                      decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.all(10),
                                      // color: Colors.green,
                                      child: Row(
                                        children: [
                                          Icon(FontAwesomeIcons.headset),
                                          SizedBox(
                                            width: 260,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Text(
                                                  "How can I get help and support?"),
                                            ),
                                          ),
                                          const Icon(Icons.expand_more),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey))),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: SizedBox(
                                        width: 300,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                                          child: Text(
                                              "You can submit an enquiry by going to Help and Support. Once your enquiry has been sent, we will get in touch with you within 12 hours.", maxLines: 6,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              //not expanded
                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.all(10),
                              // color: Colors.green,
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.headset),
                                  SizedBox(
                                    width: 260,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Text(
                                          "How can I get help and support?"),
                                    ),
                                  ),
                                  const Icon(Icons.expand_more),
                                ],
                              ),
                            )),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded5 = !_isExpanded5;
                        });
                      },
                      child: _isExpanded5
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black)),
                              child: Container(
                                //expanded
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: const EdgeInsets.all(0),
                                // height: MediaQuery.of(context).size.height * 0.23,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //not expanded
                                      decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.all(10),
                                      // color: Colors.green,
                                      child: Row(
                                        children: [
                                          Icon(FontAwesomeIcons.userSecret),
                                          SizedBox(
                                            width: 260,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Text(
                                                  "I forgot my password, what should I do now?", maxLines: 2,),
                                            ),
                                          ),
                                          const Icon(Icons.expand_more),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey))),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Row(
                                        children: const [
                                          SizedBox(
                                            width: 300,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 10, bottom: 10, left: 30),
                                              child: Text(
                                                  "Click on Forgot Password and provide your email to receive the change the change password link. You should receive the email within a minute.", maxLines: 5,),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              //not expanded
                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.all(10),
                              // color: Colors.green,
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.userSecret),
                                  SizedBox(
                                    width: 260,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Text(
                                          "I forgot my password, what should I do now?"),
                                    ),
                                  ),
                                  const Icon(Icons.expand_more),
                                ],
                              ),
                            )),
                            const SizedBox(height: 40,)
                ],
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}
