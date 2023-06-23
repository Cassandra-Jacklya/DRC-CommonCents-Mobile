import 'package:flutter/material.dart';

class NewsContainer extends StatelessWidget {
  NewsContainer({super.key, required this.feeds});

  List<dynamic>? feeds;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: feeds?.length,
      itemBuilder: (context, index) {
        final news = feeds?[index];
        return Container(
          margin: const EdgeInsets.all(10),
          height: 100,
          color: Colors.grey[300],
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                color: Colors.white,
                height: 80,
                width: 80,
                child: Image.network(
                  news['banner_image'] != ""
                      ? news['banner_image']
                      : 'https://static.vecteezy.com/system/resources/previews/000/440/213/original/question-mark-vector-icon.jpg',
                  fit: BoxFit.cover,
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
      },
    );
  }
}
