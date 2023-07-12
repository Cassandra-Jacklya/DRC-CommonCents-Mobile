import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FullPost extends StatefulWidget {
  final Map<String, dynamic> post;
  final String formattedDate;
  final bool isFavorite;
  final String hoursAgo;
  final Function(Map<String, dynamic> post) savePostCallback;

  FullPost({
    required this.post,
    required this.formattedDate,
    required this.isFavorite,
    required this.hoursAgo,
    required this.savePostCallback,
  });

  _FullPostState createState() => _FullPostState();
}

class _FullPostState extends State<FullPost> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align children to the top
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          widget.post['authorImage'] ??
                              'https://static01.nyt.com/newsgraphics/2019/08/01/candidate-pages/3b31eab6a3fd70444f76f133924ae4317567b2b5/trump-circle.png',
                        ),
                        radius: 20,
                      ),
                      SizedBox(
                        child: Center(
                          child: Text(
                            widget.post['author'],
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            // color: Colors.blue,
                            width: MediaQuery.of(context).size.width * 0.29,
                            padding: const EdgeInsets.all(1),
                            child: Text(
                              widget.post['title'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.13,
                          ),
                          Container(
                            child: Text(
                              widget.formattedDate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.all(1),
                        child: Text(
                          widget.post['details'],
                          style: const TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

// Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         children: [
                          
//                           const SizedBox(height: 10),

//                         ],
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(10),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [

                               
//                               ],
//                             ),
//                             const SizedBox(height: 5),
                            
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(left: 5),
//                         child: Text(
//                           widget.hoursAgo,
//                           style: TextStyle(
//                               fontSize: 13, fontWeight: FontWeight.w300),
//                         ),
//                       ),
                     
//                     ],
//                   ),
