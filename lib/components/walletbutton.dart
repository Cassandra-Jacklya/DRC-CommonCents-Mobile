import 'package:commoncents/components/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../cubit/login_cubit.dart';
import '../cubit/resetwallet_cubit.dart';

class WalletButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ResetWalletBloc>(create: (context) => ResetWalletBloc(),)
      ],
      child: BlocConsumer<LoginStateBloc, LoginState>(
        builder: (context, state) {
          BlocProvider.of<LoginStateBloc>(context).initFirebase('','');
          if (state is AppStateInitial) {
          } else if (state is AppStateLoggedIn) {
            return Stack(
              children: [
                GestureDetector(
                onTap: () {   
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ResetBalance();
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFF3366ff), width: 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF3366ff), 
                        offset: Offset(2, 2)
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Demo Funds:",
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        children: [
                          Text(double.parse(state.balance).toStringAsFixed(2),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const Text(" USD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)
                        ],
                      ),
                    ],
                  )),
              ),
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(FontAwesomeIcons.wallet,
                  size: 20,
                ),
              ),]
            );
          } else if (state is AppStateError) {
            return const Text("null");
          }
          return const CircularProgressIndicator();
        },
        listenWhen: (previous, current) {
          return current is AppStateLoggedIn;
        },
        listener: (context, state) {
          if (state is AppStateLoggedIn) {}
        },
      ),
    );
  }
}