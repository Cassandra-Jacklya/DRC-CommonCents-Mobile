import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../components/popup.dart';

class MyAccount extends StatefulWidget {
  final String photoUrl;
  final String displayName;
  final double balance;
  final String email;

  MyAccount(
      {Key? key,
      required this.photoUrl,
      required this.displayName,
      required this.balance,
      required this.email})
      : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  TextEditingController textEditingController = TextEditingController();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Hero(
                  tag: 'test',
                  child: ClipOval(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.3,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.displayName,
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet_sharp),
                          const SizedBox(width: 10),
                          Text(
                            "${widget.balance.toStringAsFixed(2)} USD",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
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
                  labelText: widget.displayName,
                  suffixIcon: const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width * 0.9,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Row(children: [
              Container(
                  margin: const EdgeInsets.only(left: 30),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: const Text(
                    "This is the email associated with CommonCents.",
                    style: TextStyle(fontSize: 18),
                  ))
            ]),
            const SizedBox(height: 20),
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF5F5F5F))),
                  labelText: widget.email,
                  suffixIcon: const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Container(
                  margin: const EdgeInsets.only(left: 30),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: const Text(
                    "Click Change Password to change your CommonCents password",
                    style: TextStyle(fontSize: 18),
                  ))
            ]),
            Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Password();
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 30, top: 20),
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF3366FF),
                  ),
                  child: const Center(
                    child: Text("Change Password",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
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
