import 'package:commoncents/components/popup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

class WalletButton extends StatefulWidget {
  late String balance;

  WalletButton({required this.balance});

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
                   return ResetBalance(balance: widget.balance);
                  });
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 3),
                  borderRadius: BorderRadius.circular(10)),
              child: Text("${widget.balance} USD"),
            ),
          ),
          const Positioned(
              top: 0, right: 0, child: Icon(FontAwesomeIcons.wallet))
        ],
      ),
    );
  }
}
