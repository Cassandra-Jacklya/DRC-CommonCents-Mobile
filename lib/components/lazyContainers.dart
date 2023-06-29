import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LazyContainer extends StatefulWidget {
  final List<dynamic>? feeds;
  final VoidCallback? onFeedsUpdated; // Add this line

  LazyContainer({Key? key, required this.feeds, this.onFeedsUpdated}) : super(key: key);

  _LazyContainerState createState() => _LazyContainerState();
}


class _LazyContainerState extends State<LazyContainer> {
  final controller = ScrollController();

  late List<dynamic> lazyFeeds;

  @override
  void initState(){
    super.initState();
    lazyFeeds = widget.feeds!.sublist(0,8);
    controller.addListener(() {
      print("here");
      print(controller.position.maxScrollExtent);
      print(controller.offset);
      if(controller.position.maxScrollExtent == controller.offset){
        fetch();
      }
    });
  }

  Future<void> fetch() async {
  setState(() {
    final nextIndex = lazyFeeds.length;
    final remainingFeeds = widget.feeds!.sublist(nextIndex, nextIndex + 8);
    lazyFeeds.addAll(remainingFeeds);
  });
}


  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.vertical, controller: controller,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lazyFeeds.length + 1,
        itemBuilder: (context, index) {
          if (index < lazyFeeds.length) {
            final news = lazyFeeds[index];
            return Container(
              margin: const EdgeInsets.all(10),
              height: 100,
              color: Colors.grey[300],
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      print(news['url']);
                      Uri url = Uri.parse(news['url']);
                      launchUrl(url);
                    },
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      width: 80,
                      child: Image.network(
                        (news['banner_image'] != null &&
                                news['banner_image'] != "")
                            ? news['banner_image']
                            : 'https://static.vecteezy.com/system/resources/previews/000/440/213/original/question-mark-vector-icon.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      news[
                          'title'], // Update this with the appropriate key for the news title
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else{
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
