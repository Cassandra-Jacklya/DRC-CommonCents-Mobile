import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 50,
          // color: Colors.green,
          // margin: const EdgeInsets.all(10),
          // padding: const EdgeInsets.all(10),
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(20), color: Colors.green[300]),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 250,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey),
              ),
              Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300]),
                child: Center(child: Text("Post")),
              )
            ],
          ),
        )
      ],
    ));
  }
}
