import 'package:commoncents/cubit/login_cubit.dart';
import 'package:commoncents/firebase_options.dart';
import 'package:commoncents/main.dart';
import 'package:commoncents/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email;
  late final TextEditingController _password;
  late final Future<FirebaseApp> _firebaseInitialization;

  Future<FirebaseApp> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return Firebase.initializeApp();
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
        title: const Text("Log In"),
      ),
      body: FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType:  TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email address",
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(95, 95, 95, 100)
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                          )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(95, 95, 95, 100)
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                          )
                        ),
                      ),
                    ),
                    BlocConsumer<LoginStateBloc, LoginState>(
                      listener: (context, state) {
                        if (state is AppStateInitial) {}
                        else if (state is AppStateLoggedIn) {
                          showDialog<String>(
                            barrierDismissible: false,
                            context: context, 
                            builder: (BuildContext context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text('Login Successful!'),
                              content: Text(
                                'You are logged in as ${state.email}'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context, 
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const MainApp();
                                        }));
                                    },
                                    child: const Text('Go to home page'),
                                  )
                                ],
                              ));
                        }
                        else {
                          const Text("not working");
                        }
                      },
                      builder: (context, state) {
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
                            BlocProvider.of<LoginStateBloc>(context).initFirebase(email, password);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      );
                      },
                    )
                  ],
                ),
                
              );
              default:
                return const CircularProgressIndicator();
          }
        }),
    );
  }
}