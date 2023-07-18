import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/components/appbar.dart';
import 'package:commoncents/components/popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/fullPost.dart';
import '../components/navbar.dart';
import 'auth_pages/login.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> refreshPosts() async {
    setState(() {
      postsList = []; // Clear the existing posts list
    });

    await loadPosts().then((result) {
      setState(() {
        postsList = result;
        print("Hola ${postsList.length}");

      });
    });
  }

  Future<void> deletePost(Map<String, dynamic> post) async {
    try {
      final postID = post['id']; // Get the unique post ID

      // Delete the post document
      await FirebaseFirestore.instance.collection('posts').doc(postID).delete();

      // Delete the comments subcollection of the post
      final commentsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postID)
          .collection('comments')
          .get();

      // Delete each comment document in the comments subcollection
      for (final commentDoc in commentsSnapshot.docs) {
        await commentDoc.reference.delete();
      }

      print('Post and associated comments deleted successfully.');
    } catch (error) {
      print('Failed to delete post and comments: $error');
    }
  }

  void savePost(Map<String, dynamic> post) async {
    try {
      final userId = user!.uid;
      final favoritesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites');

      final existingFavoriteSnapshot = await favoritesCollection
          .where('title', isEqualTo: post['title'])
          .where('details', isEqualTo: post['details'])
          .get();

      if (existingFavoriteSnapshot.docs.isNotEmpty) {
        // Post is already favorited, so remove it
        final existingFavoriteDoc = existingFavoriteSnapshot.docs.first;
        await existingFavoriteDoc.reference.delete();
        print('Post removed from favorites');

        setState(() {
          favouritePosts.removeWhere((favoritePost) =>
              favoritePost['title'] == post['title'] &&
              favoritePost['details'] == post['details']);
        });
      } else {
        // Post is not favorited, so save it as a new favorite
        await favoritesCollection.add(post);
        print('Post added to favorites');

        setState(() {
          favouritePosts.add(post);
        });
      }
    } catch (error) {
      print('Failed to update favorites: $error');
    }
  }

  TextEditingController textController = TextEditingController();
  late List<Map<String, dynamic>> postsList = [];
  late List<Map<String, dynamic>> favouritePosts = [];
  late bool isExpanded; // Track the expansion state

  Future<List<Map<String, dynamic>>> fetchFavoritedPostIds() async {
    if (user != null) {
      final userId = user!.uid;
      final favoritesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites');

      final querySnapshot = await favoritesCollection.get();
      final List<Map<String, dynamic>> favouritePosts = [];

      for (final doc in querySnapshot.docs) {
        favouritePosts.add(doc.data());
      }

      return favouritePosts;
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> loadPosts() async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    if (docSnapshot.docs.isEmpty) {
      print("No Posts yet");
      return postsList;
    } else {
      final postsDocs = docSnapshot.docs;

      for (final postDoc in postsDocs) {
        final post = postDoc.data();
        post['id'] = postDoc.id;

        // Retrieve comments for the post
        final commentsSnapshot =
            await postDoc.reference.collection('comments').get();
        final List<Map<String, dynamic>> commentsList = [];

        if (commentsSnapshot.docs.isNotEmpty) {
          for (final commentDoc in commentsSnapshot.docs) {
            final commentData = commentDoc.data();
            final comment = {
              'id': commentDoc.id,
              'author': commentData['author'],
              'authorImage': commentData['authorImage'],
              'content': commentData['content'],
              'postId': commentData['postId'],
              'timestamp': commentData['timestamp'],
            };
            commentsList.add(comment);
          }
        }

        post['comments'] = commentsList;

        postsList.add(post);
      }

      return postsList;
    }
  }

  @override
  void initState() {
    super.initState();
    // print(mounted);
    fetchFavoritedPostIds().then((result) {
      if (mounted) {
        setState(() {
          favouritePosts = result;
        });
      }
    });

    loadPosts().then((result) {
      if (mounted) {
        setState(() {
          postsList = result;
        });
      }
    });
    isExpanded = false;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: const CustomAppBar(
            title: "Forum",
            logo: "assets/images/commoncents-logo.png",
            isTradingPage: false),
        body: Container(
          child: postsList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginView()),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: const Color(0XFF3366FF), width: 2),
                              ),
                              padding: const EdgeInsets.all(10),
                              // height: 50,
                              // width: 50,
                              child: const Text(" Log in"),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: postsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final sortedPosts = postsList
                            ..sort((a, b) =>
                                b['timestamp'].compareTo(a['timestamp']));
                          final post = sortedPosts[index];
                          final bool isFavorite = favouritePosts.any(
                              (favoritePost) =>
                                  favoritePost['title'] == post['title'] &&
                                  favoritePost['details'] == post['details']);

                          final timestamp = post['timestamp'] as int;
                          final date =
                              DateTime.fromMillisecondsSinceEpoch(timestamp);
                          final formattedDate =
                              DateFormat('yyyy-MM-dd').format(date);

                          final now = DateTime.now();
                          final difference = now.difference(date);
                          String hoursAgo;

                          if (difference.inHours < 1) {
                            hoursAgo = 'less than an hour ago';
                          } else {
                            hoursAgo = '${difference.inHours} hours ago';
                          }

                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return PostModal(
                                    post: post,
                                    formattedDate: formattedDate,
                                    isFavorite: isFavorite,
                                    hoursAgo: hoursAgo,
                                    isLoggedin: false,
                                    refreshForumPage: refreshPosts,
                                  );
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                post['authorImage'] ??
                                                    'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png',
                                              ),
                                              radius: 40,
                                            ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: Center(
                                                child: Text(
                                                  post['author'],
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  padding:
                                                      const EdgeInsets.all(1),
                                                  child: Text(
                                                    post['title'],
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    formattedDate,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.63,
                                              padding: const EdgeInsets.all(1),
                                              child: Text(
                                                post['details'],
                                                style: const TextStyle(
                                                    fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          hoursAgo,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${post['comments'].length}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.comment),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return PostModal(
                                                    post: post,
                                                    formattedDate:
                                                        formattedDate,
                                                    isFavorite: isFavorite,
                                                    hoursAgo: hoursAgo,
                                                    refreshForumPage:
                                                        refreshPosts,
                                                    isLoggedin: false,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
        ),
        bottomNavigationBar: const BottomNavBar(index: 3),
      );
    } else {
      return Scaffold(
        appBar: const CustomAppBar(
            title: "Forum",
            logo: "assets/images/commoncents-logo.png",
            isTradingPage: false),
        body: postsList.isNotEmpty
            ? Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: postsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final sortedPosts = postsList
                                ..sort((a, b) =>
                                    b['timestamp'].compareTo(a['timestamp']));
                              final post = sortedPosts[index];
                              final bool isFavorite = favouritePosts.any(
                                  (favoritePost) =>
                                      favoritePost['title'] == post['title'] &&
                                      favoritePost['details'] ==
                                          post['details']);

                              final timestamp = post['timestamp'] as int;
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                  timestamp);
                              final formattedDate =
                                  DateFormat('yyyy-MM-dd').format(date);

                              final now = DateTime.now();
                              final difference = now.difference(date);
                              String hoursAgo;

                              if (difference.inHours < 1) {
                                hoursAgo = 'less than an hour ago';
                              } else {
                                hoursAgo = '${difference.inHours} hours ago';
                              }

                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return PostModal(
                                        post: post,
                                        formattedDate: formattedDate,
                                        isFavorite: isFavorite,
                                        hoursAgo: hoursAgo,
                                        isLoggedin: true,
                                        refreshForumPage: refreshPosts,
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    post['authorImage'] ??
                                                        'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png',
                                                  ),
                                                  radius: 40,
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child: Center(
                                                    child: Text(
                                                      post['author'] ??
                                                          'Anonymous',
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1),
                                                      child: Text(
                                                        post['title'],
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        formattedDate,
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.63,
                                                  padding:
                                                      const EdgeInsets.all(1),
                                                  child: Text(
                                                    post['details'],
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              hoursAgo,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                  child:
                                                      user!.displayName ==
                                                              post['author']
                                                          ? IconButton(
                                                              icon: const Icon(
                                                                  Icons.delete),
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          "Delete Post"),
                                                                      content:
                                                                          const Text(
                                                                              "Are you sure you want to delete this post?"),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop(); // Close the dialog
                                                                          },
                                                                          child:
                                                                              const Text("Cancel"),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                           deletePost(post);
                                                                            refreshPosts();
                                                                            Navigator.of(context).pop(); // Close the dialog
                                                                          },
                                                                          child:
                                                                              const Text("Delete"),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            )
                                                          : Container()),
                                              Text(
                                                '${post['comments'].length}',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.comment),
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder:
                                                        (BuildContext context) {
                                                      return PostModal(
                                                        post: post,
                                                        formattedDate:
                                                            formattedDate,
                                                        isFavorite: isFavorite,
                                                        hoursAgo: hoursAgo,
                                                        refreshForumPage:
                                                            refreshPosts,
                                                        isLoggedin: true,
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: isFavorite
                                                      ? Colors.red
                                                      : null,
                                                ),
                                                onPressed: () {
                                                  savePost(post);
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
        floatingActionButton: Stack(
          children: [
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PostSomething(
                      // Pass the callback function to the PostSomething dialog
                      refreshPosts: () {
                        postsList = [];
                        loadPosts().then((result) {
                          setState(() {
                            postsList = result;
                          });
                        });
                      },
                    );
                  },
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(index: 3),
      );
    }
  }
}
