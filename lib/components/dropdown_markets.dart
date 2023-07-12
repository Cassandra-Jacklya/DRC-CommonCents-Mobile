import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class Markets extends StatefulWidget{
  _MarketsState createState() => _MarketsState();
}

class _MarketsState extends State<Markets>{

   final List<String> items = [
    'Volatility 10',
    'Volatility 25',
    'Volatility 50',
    'Volatility 75',
    'Volatility 100',
    'Volatility 10 (1S)',
    'Volatility 25 (1S)',
    'Volatility 50 (1S)',
    'Volatility 75 (1S)',
    'Volatility 100 (1S)',
    'Jump 10',
    'Jump 25',
    'Jump 50',
    'Jump 75',
    'Jump 100',
    'Bear',
    'Bull'
  ];
  String? selectedValue;
  @override
  
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

