import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RecentTrades extends StatelessWidget{
  const RecentTrades({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.grey[300],
        title: const Text("Recent Trades"),
        foregroundColor: Colors.black,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Iconsax.logout),
          ),
        ],
      ),
    );
  }
}