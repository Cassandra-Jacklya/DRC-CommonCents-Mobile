import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModal extends StatefulWidget {
  final Map<String, dynamic> post;
  final String formattedDate;
  final bool isFavorite;
  final String hoursAgo;
  final VoidCallback? refreshForumPage;
  late bool isLoggedin;

  PostModal({
    required this.post,
    required this.formattedDate,
    required this.isFavorite,
    required this.hoursAgo,
    required this.refreshForumPage,
    required this.isLoggedin
  });

  @override
  _PostModalState createState() => _PostModalState();
}

class _PostModalState extends State<PostModal> {
  late TextEditingController _comment;

  User? user = FirebaseAuth.instance.currentUser;

  // void refreshModal(){
  //   setState(() {
  //     _comment.clear();

  //   });
  // }

  void storeComment(
    String postId,
    String author,
    String authorImage,
    String content,
  ) async {
    final CollectionReference postsCollection =
        FirebaseFirestore.instance.collection('posts');

    // Create a document reference for the specific post
    final DocumentReference postRef = postsCollection.doc(postId);

    // Check if the 'comments' collection exists for the post
    final commentsSnapshot = await postRef.collection('comments').get();
    final hasComments = commentsSnapshot.size > 0;

    // Store the new comment
    if (hasComments) {
      await postRef.collection('comments').add({
        'author': author,
        'authorImage': authorImage,
        'content': content,
        'postId': postId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      await postRef.collection('comments').doc().set({
        'author': author,
        'authorImage': authorImage,
        'content': content,
        'postId': postId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }

    // Call the refreshForumPage callback to refresh the forum page
    widget.refreshForumPage?.call();

    // Call the refreshModal callback to refresh the modal
    // refreshModal();
  }

  @override
  void initState() {
    _comment = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _comment.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.post;
    List comments = data['comments'];
    print("Here: $comments");
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200]),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                widget.post['authorImage'] ??
                                    'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png',
                              ),
                              radius: 40,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Center(
                                child: Text(
                                  widget.post['author'] ?? 'Anonymous',
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  padding: const EdgeInsets.all(1),
                                  child: Text(
                                    widget.post['title'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                            const SizedBox(height: 5),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.63,
                              padding: const EdgeInsets.all(1),
                              child: Text(
                                widget.post['details'],
                                style: const TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: widget.isLoggedin ? Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              user!.photoURL ??
                                  'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png',
                            ),
                            radius: 20,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ), // Adjust the padding values as needed
                            child: TextFormField(
                              scrollPadding: EdgeInsets.all(10),
                              controller: _comment,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                isDense: true, // Reduce the overall height
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF5F5F5F)),
                                ),
                                labelText: 'Comment',
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            print("Legit: $data");
                            storeComment(
                                data['id'],
                                user!.displayName ?? "Anonymous",
                                user!.photoURL ?? "",
                                _comment.text);
                            // await Future.delayed(Duration(milliseconds: 500));
                            // Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: _comment.text == ""
                                    ? Colors.grey[300]
                                    : Colors.greenAccent,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Icon(Iconsax.send),
                          ),
                        ),
                      ],
                    ) : Container()
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    "Comments",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                  child: comments.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                              child: Text(
                            "No comments yet!",
                            style: TextStyle(fontSize: 25),
                          )),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            // Sort comments based on timestamp in descending order
                            comments.sort((a, b) =>
                                a['timestamp'].compareTo(b['timestamp']));

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            comments[index]['authorImage'] ??
                                                'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png',
                                          ),
                                          radius: 20,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Center(
                                            child: Text(
                                              comments[index]['author'] ??
                                                  'Anonymous',
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      child: Text(comments[index]['content']),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
