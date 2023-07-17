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
          height: 160,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 15),
                child: Center(child: SizedBox(height: 70, width: 70, child: Image.asset(image,))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700),),
                    ),
                    Container(height: 123, width: 145,
                        child: Text(style: const TextStyle(fontSize: 11),
                          content,
                          softWrap:
                              true, // Allow the text to wrap to multiple lines
                          textAlign: TextAlign.justify,
                        )
                        )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
