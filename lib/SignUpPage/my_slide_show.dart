import 'dart:async';
import 'package:flutter/material.dart';

class MySlideshow extends StatefulWidget {
  const MySlideshow({super.key});

  @override
  State<MySlideshow> createState() => _MySlideshowState();
}

class _MySlideshowState extends State<MySlideshow> {
  // Create a PageController for PageView.
  final PageController _pageController = PageController(initialPage: 0);

  // Create a list of images.
  final List<String> images = [
    'assets/images/3.jpg',
    'assets/images/4.jpg',
    'assets/images/5.jpg',
    'assets/images/6.jpg',
    'assets/images/7.jpg',
    'assets/images/8.jpg',
    'assets/images/9.jpg',
    'assets/images/10.jpg',
    'assets/images/11.jpg',
    'assets/images/12.jpg',
    'assets/images/13.jpg',
  ];

  // Initialize the current page index.
  int currentPage = 0;

  // Create a timer to automatically change the slide.
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), _nextPage);
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(Timer timer) {
    final nextPage = (currentPage + 1) % images.length;

    if (nextPage == 0) {
      _pageController.jumpToPage(0);
    } else {
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    currentPage = nextPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height:
            MediaQuery.of(context).size.height, // Adjust the height as needed
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            // Update the current page index when the page changes.
            currentPage = index;
          },
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.asset(
              images[index],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
