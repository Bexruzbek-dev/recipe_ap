import 'package:flutter/material.dart';
import 'package:recipe_app/ui/screens/splash/choose_auth_screen.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  final List<SplashPageData> _pages = const [
    SplashPageData(
      image: "assets/images/splash1.png",
      title: "Share Your Recipes",
      description: "Lorem ipsum dolor sit amet, consectetur elit.",
    ),
    SplashPageData(
      image: "assets/images/splash2.png",
      title: "Cook with Friends",
      description: "Share and enjoy recipes with friends.",
    ),
    SplashPageData(
      image: "assets/images/splash3.png",
      title: "Discover New Flavors",
      description: "Explore new recipes and cooking methods.",
    ),
  ];

  int _currentPage = 0;
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            // Swiping Right (Previous Page)
            _goToPreviousPage();
          } else if (details.delta.dx < 0) {
            // Swiping Left (Next Page)
            _goToNextPage();
          }
        },
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 500),
              child: SplashPage(
                data: _pages[_currentPage],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / _pages.length,
                backgroundColor: Colors.grey[300],
                color: Colors.teal,
                minHeight: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _animatePageChange(_currentPage - 1);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _animatePageChange(_currentPage + 1);
    } else {
      _navigateToRegisterScreen();
    }
  }

  void _animatePageChange(int newPage) {
    setState(() {
      _opacity = 0.8;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentPage = newPage;
        _opacity = 1.0;
      });
    });
  }

  void _navigateToRegisterScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CreateAccountScreen()),
    );
  }
}

class SplashPageData {
  final String image;
  final String title;
  final String description;

  const SplashPageData({
    required this.image,
    required this.title,
    required this.description,
  });
}

class SplashPage extends StatelessWidget {
  final SplashPageData data;

  const SplashPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            data.image,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
        Container(
          color: Colors.black54,
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.65,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                data.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
