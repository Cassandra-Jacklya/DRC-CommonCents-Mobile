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
    return Center(
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: SizedBox(
            width: 312,
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 20),
                  child: Center(child: SizedBox(height: 60, width: 60, child: Image.asset(image, color: Color(0xFF5F5F5F)))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF5F5F5F)),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: SizedBox(height: 123, width: 145,
                            child: Text(style: const TextStyle(fontSize: 11, color: Color(0xFF5F5F5F)),
                              content,
                              softWrap:
                                  true, // Allow the text to wrap to multiple lines
                              textAlign: TextAlign.justify,
                            )
                            ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
