import 'package:flutter/material.dart';
import 'package:treatos_bd/intro/intro_page_1.dart';
import 'package:treatos_bd/intro/intro_page_2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:treatos_bd/screens/home_screen.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  final PageController _pageController = PageController();

  // keep track of which page we are in
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                // if index is 1, we are on last page
                onLastPage = (index == 1);
              });
            },
            children: [IntroPage1(), IntroPage2()],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => HomeScreen()),
                    );
                  },
                  child: Text('Skip'),
                ),
                SmoothPageIndicator(controller: _pageController, count: 2),

                // check to see if on last page then next => done
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (ctx) => HomeScreen()),
                          );
                        },
                        child: Text('Done'),
                      )
                    : GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text('Next'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
