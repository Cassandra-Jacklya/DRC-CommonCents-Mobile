import 'package:commoncents/cubit/login_cubit.dart';
import 'package:commoncents/firebase_options.dart';
import 'package:commoncents/main.dart';
import 'package:commoncents/pages/auth_pages/register.dart';
import 'package:commoncents/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math' as math;

import '../../components/appbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {

  bool viewPass = false;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final Future<FirebaseApp> _firebaseInitialization;
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginStateBloc>(
            create: (context) => LoginStateBloc(),
          ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(title: "Log In", logo: "", hasBell: false,),
        body: FutureBuilder(
          future: _firebaseInitialization,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (_, child) { 
                              return Transform.rotate(
                                angle: _controller.value * 2 * math.pi,
                                child: child
                              );
                            },
                            child: const Image(
                              image: AssetImage("assets/images/commoncents-logo.png"),
                              height: 100,
                              width: 100,
                              ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("C", style: TextStyle(color: Color(0xFF0E34CC), fontWeight: FontWeight.bold),),
                          Text("ommon"),
                          Text("C", style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("ents")
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                        child: SizedBox(
                          height: 70,
                          width: 311,
                          child: TextFormField(
                            controller: _email,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFF5F5F5F))
                              ),
                              labelText: 'Email',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 85),
                        child: SizedBox(
                          height: 70,
                          width: 311,
                          child: TextFormField(
                            controller: _password,
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFF5F5F5F))
                              ),
                              labelText: 'Password',             
                              suffixIcon: GestureDetector(
                                child: viewPass ? const Icon(Iconsax.eye) : const Icon(Iconsax.eye_slash),
                                onTap: () {
                                  setState(() {
                                    viewPass = !viewPass;
                                  });
                                },
                              ), //Icon at the end
                            ),
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
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (BuildContext context) { return const HomePage(); }
                                        //       ),
                                        // );
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (context, anim1, anim2) => const HomePage(),
                                              transitionDuration: Duration.zero),
                                        );
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
                          child:ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3366FF)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 13
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegisterView()),
                                );
                              },
                              child: const Text("Sign Up",
                                style: TextStyle(fontSize: 13,
                                  color: Color(0XFF3366FF),
                                  decoration: TextDecoration.underline
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
                default:
                  return const CircularProgressIndicator();
            }
          }),
      ),
    );
  }
}