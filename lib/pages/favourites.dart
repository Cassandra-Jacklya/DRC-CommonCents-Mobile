import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget {
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  Future<List<Map<String, dynamic>>>? _favouritesFuture;

  List<Map<String, dynamic>> favouritePosts = [];

  Future<List<Map<String, dynamic>>> getFavoritePosts() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> data = [];
    final QuerySnapshot favoriteSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .get();

    if (favoriteSnapshot.docs.isNotEmpty) {
      final List<String> favoritePostIds = favoriteSnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['id'] as String)
          .toList();

      print("Lol $favoritePostIds");

      final QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where(FieldPath.documentId, whereIn: favoritePostIds)
          .get();

      print("Middle ${postsSnapshot.docs}");

      if (postsSnapshot.docs.isNotEmpty) {
        final List<Map<String, dynamic>> favoritePosts = postsSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        data = favoritePosts;
        print("Final $data");
        return data;
      } else {
        data = [];
        return data;
      }
    } else {
      data = [];
      return data;
    }
  }

  @override
  void initState() {
    super.initState();
    getFavoritePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0XFF3366FF),
        ),
        body: Container(
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _favouritesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator()),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  favouritePosts = snapshot.data!;
                  if (favouritePosts.isEmpty) {
                    Center(child: Text("You dont have favourite posts"));
                  } else {
                    Center(
                      child: Text("Yay"),
                    );
                  }
                }
                return Text("You dont have favourite posts");
              }),
        ));
  }
}


  // Future<List<Map<String, dynamic>>> fetchLikedPostsAndComments() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     print(user!.displayName);
  //     final userRef =
  //         FirebaseFirestore.instance.collection('users').doc(user.uid);
  //     final likedPostsSnapshot = await userRef.collection('favorites').get();
  //     print(likedPostsSnapshot.docs);

  //     late List<Map<String, dynamic>> likedPosts = [];

  //     for (final likedPostDoc in likedPostsSnapshot.docs) {
  //       final postId = likedPostDoc.id;
  //       final postRef =
  //           FirebaseFirestore.instance.collection('posts').doc(postId);
  //       final postSnapshot = await postRef.get();

  //       final post = {
  //         'postId': postId,
  //         'author': postSnapshot['author'],
  //         'title': postSnapshot['title'],
  //         'details': postSnapshot['details'],
  //         'comments': [],
  //       };

  //       final commentsSnapshot = await postRef.collection('comments').get();

  //       for (final commentDoc in commentsSnapshot.docs) {
  //         final commentId = commentDoc.id;
  //         final commentData = commentDoc.data();

  //         final comment = {
  //           'commentId': commentId,
  //           'author': commentData['author'],
  //           'content': commentData['content'],
  //           'timestamp': commentData['timestamp'],
  //         };

  //         post['comments'].add(comment);
  //       }

  //       likedPosts.add(post);
  //     }

  //     return likedPosts;
  //   } catch (e) {
  //     print('Error fetching liked posts and comments: $e');
  //     return [];
  //   }
  // }
