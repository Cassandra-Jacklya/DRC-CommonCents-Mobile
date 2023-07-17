import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class NewsContainer extends StatelessWidget {
  NewsContainer({super.key, required this.feeds, required this.scrollable,required this.scrollController});

  List<dynamic>? feeds;
  bool scrollable;
  ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      physics: scrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
      itemCount: feeds?.length,
      itemBuilder: (context, index) {
        final news = feeds?[index];
        return GestureDetector(
          onTap: () async {
            // print(news['url']);
            showDialog(
              context: context,
              builder: (BuildContext newsContext) {
                return AlertDialog(
                  titlePadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  title: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: const Text('This action will exit CommonCents',
                        style: TextStyle(fontSize: 16, color: Color(0xFF3366FF)),
                      ),
                    ),
                  ),
                  content: Container(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                            'Redirecting to',
                              style: TextStyle(fontSize: 14),
                            ),
                        Text(news['url'], 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel',
                        style: TextStyle(color: Color(0xFF3366FF)),
                      ),
                      onPressed: () {
                        Navigator.of(newsContext).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Continue', 
                        style: TextStyle(color: Color(0xFF3366FF)),
                      ),
                      onPressed: () {
                        Uri url = Uri.parse(news['url']);
                        launchUrl(url,);
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 1),
            height: 90,
            width: 321,
            color: Colors.white,
            child: GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext newsContext) {
                    return AlertDialog(
                      titlePadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: const Text('This action will exit CommonCents',
                            style: TextStyle(fontSize: 16, color: Color(0xFF3366FF)),
                          ),
                        ),
                      ),
                      content: Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                'Redirecting to ',
                                  style: TextStyle(fontSize: 14),
                                ),
                            Text(news['url'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel',
                            style: TextStyle(color: Color(0xFF3366FF)),
                          ),
                          onPressed: () {
                            Navigator.of(newsContext).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Continue',
                            style: TextStyle(color: Color(0xFF3366FF),
                          ),),
                          onPressed: () {
                            Uri url = Uri.parse(news['url']);
                            launchUrl(url,);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Card(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xFFD9D9D9),
                    width: 1
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: SizedBox(
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                (news['banner_image'] != null &&
                                    news['banner_image'] != "")
                                ? news['banner_image']
                                : 'https://static.vecteezy.com/system/resources/previews/000/440/213/original/question-mark-vector-icon.jpg'
                              ),
                              fit: BoxFit.contain
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                            )
                          ),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          news[
                              'title'],
                          overflow: TextOverflow.ellipsis, 
                          maxLines: 3,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
