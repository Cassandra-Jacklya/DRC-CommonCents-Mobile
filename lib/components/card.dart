import 'package:flutter/material.dart';

class MarketCard extends StatelessWidget {
  late String image;
  late String title;
  late String content;
  MarketCard(
      {required this.image,
      required this.title,
      required this.content,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFD9D9D9), width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SizedBox(
          width: 312,
          height: 400,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(child: SizedBox(height: 70, width: 70, child: Image.asset(image,))),
              Column(
                children: [
                  Container(margin: const EdgeInsets.only(top: 10, bottom: 5),child: Text(title, style: TextStyle(fontWeight: FontWeight.w700),)),
                  Container(height: 80, width: 140,
                      child: Text(style: const TextStyle(fontSize: 11),
                        content,
                        softWrap:
                            true, // Allow the text to wrap to multiple lines
                        textAlign: TextAlign.justify,
                      )
                      )
                ],
              )
            ],
          )),
    );
  }
}
