//Register View
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/components/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../cubit/register_cubit.dart';
import '../../firebase_options.dart';
import 'login.dart';
import 'dart:math' as math;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with SingleTickerProviderStateMixin {
  bool viewPass = false;
  bool viewConfirmPass = false;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late final Future<FirebaseApp> _firebaseInitialization;
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();

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
    _confirmPassword = TextEditingController();
    _firebaseInitialization = initializeFirebase();
    super.initState();
  }

  //clean up
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Create an Account", logo: "", hasBell: false,),
      body: FutureBuilder<FirebaseApp>(
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
                    SizedBox(
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 45),
                      child: SizedBox(
                        height: 70,
                        width: 311,
                        child: TextFormField(
                          controller: _confirmPassword,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF5F5F5F))
                            ),
                            labelText: 'Confirm Password',
                            suffixIcon: GestureDetector(
                            child: viewConfirmPass ? const Icon(Iconsax.eye) : const Icon(Iconsax.eye_slash),
                            onTap: () {
                              setState(() {
                                viewConfirmPass = !viewConfirmPass;
                              });
                            },
                          ),
                          ),
                        ),
                      ),
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
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (context, anim1, anim2) => const LoginView(),
                                              transitionDuration: Duration.zero),
                                        );
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
                            BlocProvider.of<SignUpStateBloc>(context)
                                .signUp(email, password);
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      );

                    }),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Have an account? ",
                            style: TextStyle(
                              fontSize: 13
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginView()),
                              );
                            },
                            child: const Text("Log In",
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
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
