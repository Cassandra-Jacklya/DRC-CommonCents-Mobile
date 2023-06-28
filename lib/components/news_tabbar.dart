import 'package:commoncents/cubit/news_tabbar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/newspage.dart';
import '../apistore/news_lazyLoading.dart';

class NewsTabBar extends StatefulWidget {
  final Function(String) onTopicChanged; // Add this line

  NewsTabBar({required this.onTopicChanged}); // Add this line

  _NewsTabBarState createState() => _NewsTabBarState();
}

class _NewsTabBarState extends State<NewsTabBar>
    with SingleTickerProviderStateMixin {
  List<dynamic> topics = [
    'All',
    'Blockchain',
    'Earnings',
    'IPO',
    'Mergers & Acquisition',
    'Financial Markets',
    'Econ - Fiscal Policy',
    'Econ - Monetary Policy',
    'Econ - Macro/Overall',
    'Finance',
    'Retail & Wholesale',
    'Technology'
  ];

  String formatTopicForAPI(String topic) {
    switch (topic) {
      case 'All':
        return 'All';
      case 'Blockchain':
        return 'blockchain';
      case 'Earnings':
        return 'earnings';
      case 'IPO':
        return 'ipo';
      case 'Mergers & Acquisition':
        return 'mergers_and_acquisition';
      case 'Financial Markets':
        return 'financial_markets';
      case 'Econ - Fiscal Policy':
        return 'economy_fiscal';
      case 'Econ - Monetary Policy':
        return 'economy_monetary';
      case 'Econ - Macro/Overall':
        return 'economy_macro';
      case 'Finance':
        return 'finance';
      case 'Retail & Wholesale':
        return 'retail_wholesale';
      case 'Technology':
        return 'technology';
      default:
        return topic.toLowerCase().replaceAll(' ', '_');
    }
  }

  String selectedTopic = 'All'; // Default selected topic

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsTabBarCubit = context.read<NewsTabBarCubit>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Wrap(
          spacing: 0,
          children: topics.map((topic) {
            bool isSelected = (selectedTopic == topic);
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTopic = topic;
                  newsTabBarCubit.updateTopic(formatTopicForAPI(topic));
                });
                if (_animationController.status != AnimationStatus.forward) {
                  _animationController.forward(from: 0.0);
                }

                final chosenTopic = formatTopicForAPI(topic);
                widget.onTopicChanged(selectedTopic);
              },
              child: AnimatedContainer(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? Colors.black : Colors.grey,
                      style: BorderStyle.solid,
                      width: isSelected ? 3 + 5 * _animation.value : 1,
                    ),
                  ),
                ),
                height: 40,
                duration: const Duration(milliseconds: 300),
                child: Center(
                  child: Text(
                    topic,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
