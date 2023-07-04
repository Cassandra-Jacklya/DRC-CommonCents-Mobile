import 'package:flutter/material.dart';

class MarketCard extends StatelessWidget {
  const MarketCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xFFD9D9D9),
          width: 1.5
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SizedBox(
        width: 312,
        height: 147,
        child: Center(child: Text('Market Types')),
      ),
    );
  }
}