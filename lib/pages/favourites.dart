import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/fullPost.dart';

class FavouritesPage extends StatefulWidget {
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  Future<List<Map<String, dynamic>>>? _favouritesFuture;
  User? user = FirebaseAuth.instance.currentUser;

  List<Map<String, dynamic>> favouritePosts = [];

  void removePostFromFavorites(Map<String, dynamic> post) async {
    try {
      final userId = user!.uid;
      final favoritesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites');

      final existingFavoriteSnapshot =
          await favoritesCollection.where('id', isEqualTo: post['id']).get();

      if (existingFavoriteSnapshot.docs.isNotEmpty) {
        // Post is favorited, so remove it
        final existingFavoriteDoc = existingFavoriteSnapshot.docs.first;
        await existingFavoriteDoc.reference.delete();
        print('Post removed from favorites');

        setState(() {
          favouritePosts
              .removeWhere((favoritePost) => favoritePost['id'] == post['id']);
        });
      }
    } catch (error) {
      print('Failed to remove post from favorites: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getFavoritePosts() async {
    List<Map<String, dynamic>> data = [];

    try {
      final userId = user!.uid;

      final QuerySnapshot favoriteSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      if (favoriteSnapshot.docs.isNotEmpty) {
        final List<String> favoriteDocIds = favoriteSnapshot.docs
            .map((doc) => (doc.data() as Map<String, dynamic>)['id'] as String)
            .toList();

        // Step 2: Fetch the favorite posts from the posts collection using the IDs
        final QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where(FieldPath.documentId, whereIn: favoriteDocIds)
            .get();

        if (postsSnapshot.docs.isNotEmpty) {
          final List<Map<String, dynamic>> favoritePosts = [];

          for (final postDoc in postsSnapshot.docs) {
            final post = postDoc.data() as Map<String, dynamic>;

            // Fetch comments for the current post from the 'comments' subcollection
            final commentsSnapshot =
                await postDoc.reference.collection('comments').get();

            final comments = commentsSnapshot.docs.map((commentDoc) {
              final commentData = commentDoc.data();
              return {
                ...commentData,
                'id': commentDoc.id,
              };
            }).toList();

            post['id'] = postDoc.id; // Include the post ID
            post['comments'] = comments;
            favoritePosts.add(post);
          }

          data = favoritePosts;
        }
      }
    } catch (error) {
      print('Failed to get favorite posts: $error');
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    _favouritesFuture = getFavoritePosts();
  }

  @override
  Widget build(BuildContext context) {
    _favouritesFuture = getFavoritePosts();
    return Scaffold(
      appBar: AppBar(title: const Text("Favourites", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0XFF3366FF),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _favouritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            favouritePosts = snapshot.data!;
            if (favouritePosts.isNotEmpty) {
              return ListView.builder(
                itemCount: favouritePosts.length,
                itemBuilder: (context, index) {
                  final post = favouritePosts[index];
                  final timestamp = post['timestamp'] as int;
                  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                  final formattedDate = DateFormat('yyyy-MM-dd').format(date);
                  final now = DateTime.now();
                  final difference = now.difference(date);
                  String hoursAgo;

                  if (difference.inHours < 1) {
                    hoursAgo = 'less than an hour ago';
                  } else {
                    hoursAgo = '${difference.inHours} hours ago';
                  }
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return PostModal(
                                post: post,
                                formattedDate: formattedDate,
                                isFavorite: true,
                                hoursAgo: hoursAgo,
                                isLoggedin: true,
                                refreshForumPage: null,
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black26),
                          ),
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
                                                  fontWeight: FontWeight.w800,
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
                                            style:
                                                const TextStyle(fontSize: 15),
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
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${post['comments']?.length ?? 0}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.comment),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return PostModal(
                                                post: post,
                                                formattedDate: formattedDate,
                                                isFavorite: true,
                                                hoursAgo: hoursAgo,
                                                isLoggedin: true,
                                                refreshForumPage: null,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.favorite),
                                        color: Colors.red,
                                        onPressed: () {
                                          removePostFromFavorites(post);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: Text("No favourites yet!"),
              );
            }
          }
          // Return an empty container if none of the conditions are met
          return Container();
        },
      ),
    );
  }
}
