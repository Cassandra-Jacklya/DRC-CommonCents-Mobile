//Register View
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/register_cubit.dart';
import '../../firebase_options.dart';
import 'login.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final Future<FirebaseApp> _firebaseInitialization;

  Future<FirebaseApp> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return Firebase.initializeApp();
  }

  void addDocument() async {
     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      CollectionReference collectionReference = firebaseFirestore.collection('users');
      collectionReference.doc(user!.uid).set({
        'balance': 100000,
        'displayName': user.email,
        'email': user.email,
        'photoUrl': '',
      });
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firebaseInitialization = initializeFirebase();
    super.initState();
  }

  //clean up
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "SIGN UP FOR YOUR ACCOUNT",
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(30))),
      ),
      body: FutureBuilder<FirebaseApp>(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 50, 40, 0),
                          child: SizedBox(

                            //email text field
                            child: TextField(
                              controller: _email,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Enter your email here",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 3, //<-- SEE HERE
                                    color: Color.fromRGBO(240, 140, 15, 100),
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 3, //<-- SEE HERE
                                    color: Color.fromRGBO(240, 140, 15, 100),
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: SizedBox(
                            child: TextField(
                              controller: _password,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,

                              //password text field
                              decoration: InputDecoration(
                                hintText: "Enter password",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 3, 
                                    color: Color.fromRGBO(240, 140, 15, 100),
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 3, 
                                    color: Color.fromRGBO(240, 140, 15, 100),
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    BlocConsumer<SignUpStateBloc, RegisterState>(
                        listener: (context, state) {
                      if (state is RegisterStateInitial) {
                      } else if (state is RegisterStateDone) {
                        addDocument();
                        //show dialog to show user is registered 
                        showDialog<String>(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text('Registered!'),
                                  content: Text(
                                      'You have registered using ${state.email}'),
                                  actions: <Widget>[
                                    TextButton(

                                      //goes to log in page
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginView()));
                                      },
                                      child: const Text('Login'),
                                    ),
                                  ],
                                ));
                      } else if (state is RegisterStateError) {

                        //show error dialog upon registering
                        showDialog<String>(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(state.error.dialogTitle),
                                  content: Text(state.error.dialogText),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ));
                      }
                    }, builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            BlocProvider.of<SignUpStateBloc>(context)
                                .signUp(email, password);
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      );
                    }),
                    
                  ],
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
