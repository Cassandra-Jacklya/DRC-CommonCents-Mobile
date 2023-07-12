import 'package:commoncents/components/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../cubit/login_cubit.dart';

class WalletButton extends StatefulWidget {
  final LoginStateBloc loginStateBloc;

  WalletButton({required this.loginStateBloc});

  _WalletButtonState createState() => _WalletButtonState();
}

class _WalletButtonState extends State<WalletButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ResetBalance(loginStateBloc: widget.loginStateBloc);
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: BlocConsumer<LoginStateBloc, LoginState>(
                builder: (context, state) {
                  if (state is AppStateInitial) {
                  } else if (state is AppStateLoggedIn) {
                    return Row(
                      children: [
                        Text(state.balance),
                      ],
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
            ),
          ),
          const Positioned(
            top: 0,
            right: 0,
            child: Icon(FontAwesomeIcons.wallet),
          ),
        ],
      ),
    );
  }
}
