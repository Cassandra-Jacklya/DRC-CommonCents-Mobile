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

  PostModal(
      {required this.post,
      required this.formattedDate,
      required this.isFavorite,
      required this.hoursAgo,
      required this.refreshForumPage,
      required this.isLoggedin});

  @override
  _PostModalState createState() => _PostModalState();
}

class _PostModalState extends State<PostModal> {
  late TextEditingController _comment;

  User? user = FirebaseAuth.instance.currentUser;

  void refreshModal(List updatedComments) {
    setState(() {
      _comment.clear();
      widget.post['comments'] = updatedComments;
    });
  }

  Future<void> deleteComment(String commentId) async {
    try {
      final postId = widget.post['id'];

      // Get the reference to the post document
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      // Delete the comment document from Firestore
      await postRef.collection('comments').doc(commentId).delete();
      print('Comment deleted successfully.');

      // Refresh the comments list to remove the deleted comment
      final updatedCommentsSnapshot =
          await postRef.collection('comments').get();
      final updatedComments =
          updatedCommentsSnapshot.docs.map((doc) => doc.data()).toList();
      refreshModal(updatedComments);
      widget.refreshForumPage?.call();
    } catch (error) {
      print('Failed to delete comment: $error');
    }
  }

  void storeComment(
    String postId,
    String author,
    String authorImage,
    String content,
    String? email,
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
        'email': email
      });
    } else {
      await postRef.collection('comments').doc().set({
        'author': author,
        'authorImage': authorImage,
        'content': content,
        'postId': postId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'email': email
      });
    }

    final updatedCommentsSnapshot = await postRef.collection('comments').get();
    final updatedComments = updatedCommentsSnapshot.docs.map((doc) {
      final commentData = doc.data();
      final comment = {
        'id': doc.id, // Include the document ID in the comment data
        'author': commentData['author'],
        'authorImage': commentData['authorImage'],
        'content': commentData['content'],
        'postId': commentData['postId'],
        'timestamp': commentData['timestamp'],
        'email' : email
      };
      return comment;
    }).toList();

    // Call the refreshForumPage callback to refresh the forum page
    widget.refreshForumPage?.call();

    // Call the refreshModal callback to refresh the modal with the updated comments
    print("HOLA $updatedComments");
    refreshModal(updatedComments);

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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: 550,
          width: double.infinity,
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
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    widget.post['authorImage'] ??
                                        'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png',
                                  ),
                                  radius: 30,
                                ),
                              ),
                              const SizedBox(height: 10),
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
                                    width: 193,
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
                                // width: MediaQuery.of(context).size.width * 0.63,
                                width: 170,
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
                        child: widget.isLoggedin
                            ? Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
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
                                        scrollPadding: const EdgeInsets.all(10),
                                        controller: _comment,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                          isDense:
                                              true, // Reduce the overall height
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                      if (_comment.text.isEmpty) {
                                      } else {
                                        storeComment(
                                            data['id'],
                                            user!.displayName ?? user!.email!,
                                            user!.photoURL ??
                                                "https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png",
                                            _comment.text,
                                            user!.email);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: _comment.text == ""
                                              ? Colors.grey[300]
                                              : Color(0xFF6699ff),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Icon(Iconsax.send),
                                    ),
                                  ),
                                ],
                              )
                            : Container()),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Comments",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            // height: MediaQuery.of(context).size.height * 0.2,
                            // width: MediaQuery.of(context).size.width,
                            child: const Center(
                                child: Text(
                              "No comments yet!",
                              style: TextStyle(fontSize: 20),
                            )),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: comments.length,
                            itemBuilder: (BuildContext context, int index) {
                              // Sort comments based on timestamp in descending order
                              comments.sort((a, b) =>
                                  a['timestamp'].compareTo(b['timestamp']));

                              return GestureDetector(
                                onLongPress: () {
                                  if (comments[index]['email'] ==
                                      user!.email) {
                                    print(
                                        "HUH ${comments[index]['content']}\n${comments[index]['email']}");
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Delete Comment"),
                                          content: const Text(
                                              "Are you sure you want to delete this comment?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                print(
                                                    "WOI ${comments[index]['id']}");
                                                deleteComment(
                                                    comments[index]['id']);

                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFD9D9D9),
                                    // border: Border(bottom: BorderSide(color: Colors.black))
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                comments[index]
                                                        ['authorImage'] ??
                                                    'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png',
                                              ),
                                              radius: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: SizedBox(
                                                width: 50,
                                                child: Center(
                                                  child: Text(
                                                    comments[index]['author'],
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          child:
                                              Text(comments[index]['content']),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
              ),
              SizedBox(
                // width: MediaQuery.of(context).size.width,
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
      ),
    );
  }
}
