import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget {
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Map<String, dynamic>> data = [];
  Future<List<Map<String, dynamic>>> fetchLikedPostsAndComments() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      print(user!.displayName);
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final likedPostsSnapshot = await userRef.collection('favorites').get();
      print(likedPostsSnapshot.docs);

      late List<Map<String, dynamic>> likedPosts = [];

      for (final likedPostDoc in likedPostsSnapshot.docs) {
        final postId = likedPostDoc.id;
        final postRef =
            FirebaseFirestore.instance.collection('posts').doc(postId);
        final postSnapshot = await postRef.get();

        final post = {
          'postId': postId,
          'author': postSnapshot['author'],
          'title': postSnapshot['title'],
          'details': postSnapshot['details'],
          'comments': [],
        };

        final commentsSnapshot = await postRef.collection('comments').get();

        for (final commentDoc in commentsSnapshot.docs) {
          final commentId = commentDoc.id;
          final commentData = commentDoc.data();

          final comment = {
            'commentId': commentId,
            'author': commentData['author'],
            'content': commentData['content'],
            'timestamp': commentData['timestamp'],
          };

          post['comments'].add(comment);
        }

        likedPosts.add(post);
      }

      return likedPosts;
    } catch (e) {
      print('Error fetching liked posts and comments: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLikedPostsAndComments().then((result) {
      setState(() {
        data = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(appBar: AppBar(),body: Container(color: Colors.white,),);
  }
}
