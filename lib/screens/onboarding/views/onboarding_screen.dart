import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'loginSignUp_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    _pageIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: demo_data.length,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnBoardContent(
                    image: demo_data[index].image,
                    title: demo_data[index].title,
                    description: demo_data[index].description,
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      child: SvgPicture.network(
                        'https://www.svgrepo.com/show/41905/left-arrow.svg',
                        placeholderBuilder: (context) =>
                            const CircularProgressIndicator(),
                        height: 100,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ...List.generate(
                    demo_data.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: DotIndicator(isActive: index == _pageIndex),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        if (_pageIndex == demo_data.length - 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginSignUpScreen();
                              },
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        }
                      },
                      child: SvgPicture.network(
                        'https://www.svgrepo.com/show/28675/right-arrow.svg',
                        placeholderBuilder: (context) =>
                            const CircularProgressIndicator(),
                        height: 100,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class OnBoard {
  final String image, title, description;

  const OnBoard({
    required this.description,
    required this.image,
    required this.title,
  });
}

// ignore: non_constant_identifier_names
final List<OnBoard> demo_data = [
  const OnBoard(
    image: 'assets/images/Scenes04.svg',
    title: "Find the item you've \nbeen looking for",
    description:
        "Here you'll see rich varieties of goods carefully curated for seamless browsing experience.",
  ),
  const OnBoard(
    image: 'assets/images/Scenes02.svg',
    title: "Get those shopping \nbags filled",
    description:
        "Add any item you want to your cart, or save it on your wishlist.",
  ),
  const OnBoard(
    image: 'assets/images/Scenes03.svg',
    title: "Find the item you've \nbeen looking for",
    description:
        "Here you'll see rich varieties of goods carefully curated for seamless browsing experience.",
  ),
  const OnBoard(
    image: 'assets/images/Scenes04.svg',
    title: "Nearby stores",
    description:
        "Easily track nearby shops, browse through their items and get.",
  )
];

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        // SvgPicture.network(
        //   image,
        //   placeholderBuilder: (context) => const CircularProgressIndicator(),
        //   height: 200,
        // ),
        SvgPicture.asset(
          image,
          semanticsLabel: 'Scene',
          height: 200,
          cacheColorFilter: true,
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}
