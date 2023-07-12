import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/authStore/authentication.dart';
import 'package:commoncents/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:commoncents/pages/changePassword.dart';
import 'package:iconsax/iconsax.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Account Settings',
              style: Theme.of(context).textTheme.displayLarge!.merge(
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Align(
          heightFactor: 0.9,
          alignment: Alignment.centerLeft,
          child: Text(
            'Are you sure you want to change your details?',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF5F5F5F))),
              child: const Center(child: Text("Cancel")),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Color(0XFF3366FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                  child: Text("Yes", style: TextStyle(color: Colors.white))),
            ),
          ),
        ),
      ],
    );
  }
}

class LogOut extends StatelessWidget {
  const LogOut({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logout',
              style: Theme.of(context).textTheme.displayLarge!.merge(
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Align(
          heightFactor: 0.9,
          alignment: Alignment.centerLeft,
          child: Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF5F5F5F))),
              child: const Center(child: Text("Cancel")),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              await Authentication.signOut(context: context);
              if (context.mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainApp(),
                    ));
              }
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Color(0XFF3366FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                  child: Text(style: TextStyle(color: Colors.white), "Yes")),
            ),
          ),
        ),
      ],
    );
  }
}

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController textEditingController = TextEditingController();
  late bool viewPass;
  final _auth = FirebaseAuth.instance;

  Future<void> checkPassword(BuildContext context) async {
    final user = _auth.currentUser;
    if (user != null) {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: textEditingController.text,
      );
      final authResult = await user.reauthenticateWithCredential(credential);

      if (authResult.user != null) {
        // Password is correct, proceed with changing the password or any other actions
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePassword()),
        );
      } else {
        // Password is incorrect, display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid password')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    viewPass = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 300,
      child: Builder(
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            titlePadding: EdgeInsets.zero,
            title: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(11),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Align(
                      heightFactor: 0.9,
                      alignment: Alignment.center,
                      child: Text(
                        'Enter your current password',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge!.merge(
                              const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: TextFormField(
              controller: textEditingController,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: viewPass ? false : true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF5F5F5F))),
                labelText: 'Password',
                suffixIcon: GestureDetector(
                  child: viewPass
                      ? const Icon(Iconsax.eye)
                      : const Icon(Iconsax.eye_slash),
                  onTap: () {
                    setState(() {
                      viewPass = !viewPass;
                    });
                  },
                ), //Icon at the end
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    child: const Center(child: Text("Cancel")),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    checkPassword(context);
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Color(0XFF3366FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child:
                            Text(style: TextStyle(color: Colors.white), "Yes")),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TradeDetails extends StatefulWidget {
  late String status;
  late double entry;
  late double exit;
  late double pNl;
  late String marketType;
  late int duration;
  late String basis;
  late double buyPrice;
  late double payout;
  late String strategy;

  TradeDetails({
    super.key,
    required this.status,
    required this.entry,
    required this.exit,
    required this.pNl,
    required this.marketType,
    required this.duration,
    required this.basis,
    required this.buyPrice,
    required this.payout,
    required this.strategy,
  });
  _TradeDetailsState createState() => _TradeDetailsState();
}

class _TradeDetailsState extends State<TradeDetails> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
            color:
                widget.status == 'Win' ? Colors.greenAccent : Colors.redAccent,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.status == "Win" ? "WON" : "LOST",
              style: Theme.of(context).textTheme.displayLarge!.merge(
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
            ),
          ],
        ),
      ),
      content: Container(
          // padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  // const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              padding: const EdgeInsets.only(top: 10),
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(widget.entry.toStringAsFixed(2)),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 17,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26)),
                              child: const Text(
                                "Entry spot",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              padding: const EdgeInsets.only(top: 10),
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(widget.exit.toStringAsFixed(2)),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 17,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26)),
                              child: const Text(
                                "Entry spot",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Profit/loss",
                        style: TextStyle(
                            color: widget.status == "Win"
                                ? Colors.greenAccent
                                : Colors.redAccent),
                      ),
                      const Flexible(
                        child: Text(
                          "......................",
                        ),
                      ),
                      Text(
                        widget.status == "Win"
                            ? "+ ${widget.pNl.toStringAsFixed(2)}"
                            : "-${widget.pNl.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: widget.status == "Win"
                                ? Colors.greenAccent
                                : Colors.redAccent),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Market Type",
                      ),
                      const Flexible(
                        child: Text(
                          "......................",
                        ),
                      ),
                      Text(widget.marketType),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Duration",
                      ),
                      const Flexible(
                        child: Text(
                          "......................",
                        ),
                      ),
                      Text(widget.duration.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Basis",
                      ),
                      const Flexible(
                        child: Text(
                          "......................",
                        ),
                      ),
                      Text(widget.basis),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Buy Price",
                      ),
                      const Flexible(
                        child: Text(
                          "......................",
                        ),
                      ),
                      Text("${widget.buyPrice.toStringAsFixed(2)} USD"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Payout limit",
                      ),
                      const Flexible(
                        child: Text(
                          "......................",
                        ),
                      ),
                      Text("${widget.payout.toStringAsFixed(2)} USD"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Strategy",
                      ),
                      const Flexible(
                        child: Text(
                          "......................",
                        ),
                      ),
                      Text(widget.strategy),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      )),
    );
  }
}

class PostSomething extends StatefulWidget {
  _PostSomethingState createState() => _PostSomethingState();
}

class _PostSomethingState extends State<PostSomething> {
  TextEditingController _postController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> createPost(String? author, String? authorImage, String? details,
      int? timestamp, String? title) async {
    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'author': author,
        'authorImage': authorImage,
        'details': details,
        'timestamp': timestamp,
        'title': title,
      });
      print('Post created successfully!');
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Color(0XFF3366FF),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Share Something',
              style: Theme.of(context).textTheme.displayLarge!.merge(
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
            ),
          ],
        ),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.only(top: 10),
        child: Column(children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF5F5F5F))),
            ),
            maxLength: 100,
            maxLines: 1,
          ),
          TextFormField(
            controller: _postController,
            decoration: InputDecoration(
              labelText: "Post",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF5F5F5F))),
            ),
            maxLength: 300,
            maxLines: 5,
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              _postController.text == "" ? {} : print(user!.displayName);
              Navigator.of(context).pop();
              createPost(
                  user!.displayName,
                  user!.photoURL,
                  _postController.text,
                  DateTime.now().millisecondsSinceEpoch,
                  _titleController.text);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _postController.text == ""
                          ? Colors.grey[400]
                          : const Color(0XFF3366FF)),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Center(
                    child: const Text(
                      "Post",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class ResetBalance extends StatelessWidget {
  late String balance;

  Future<void> resetBalance() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      CollectionReference collectionReference =
          firebaseFirestore.collection('users');
      DocumentReference userDocument = collectionReference.doc(user.uid);

      await userDocument.update({
        'balance': 100000,
      });
      print("Balance reset");
    }
  }

  ResetBalance({required this.balance});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [const Text("Current Balance: "), Text(balance)],
            ),
            const SizedBox(height: 10),
            GestureDetector( onTap: (){
              resetBalance();
            },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0XFF3366FF)),
                child: const Text(
                  "Click to reset balance",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
