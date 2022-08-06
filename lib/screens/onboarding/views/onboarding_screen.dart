import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
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
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: demo_data.length,
                itemBuilder: (context, index) => OnBoardContent(
                  image: demo_data[index].image,
                  title: demo_data[index].title,
                  description: demo_data[index].description,
                ),
              ),
            ),
            SizedBox(
              height: 60,
              width: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), primary: Colors.indigo[800]),
                onPressed: () {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease);
                },
                child: SvgPicture.network(
                  'https://www.svgrepo.com/show/115046/right-arrow.svg',
                  placeholderBuilder: (context) =>
                      const CircularProgressIndicator(),
                  height: 100,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
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
    image: 'https://www.svgrepo.com/show/281711/meeting-interview.svg',
    title: "Find the item you've \nbeen looking for",
    description:
        "Here you'll see rich varieties of goods carefully curated for seamless browsing experience.",
  ),
  const OnBoard(
    image: 'https://www.svgrepo.com/show/281711/meeting-interview.svg',
    title: "Get those shopping \nbags filled",
    description:
        "Add any item you want to your cart, or save it on your wishlist.",
  ),
  const OnBoard(
    image: 'https://www.svgrepo.com/show/281711/meeting-interview.svg',
    title: "Find the item you've \nbeen looking for",
    description:
        "Here you'll see rich varieties of goods carefully curated for seamless browsing experience.",
  ),
  const OnBoard(
    image: 'https://www.svgrepo.com/show/281711/meeting-interview.svg',
    title: "Find the item you've \nbeen looking for",
    description:
        "Here you'll see rich varieties of goods carefully curated for seamless browsing experience.",
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
        SvgPicture.network(
          image,
          placeholderBuilder: (context) => const CircularProgressIndicator(),
          height: 200,
        ),
        // SvgPicture.asset('assets/images/Scenes03.svg',
        //     semanticsLabel: 'Meeting'),
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
