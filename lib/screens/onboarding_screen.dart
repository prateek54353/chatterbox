import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'Welcome to Chatterbox',
      description: 'Your all-in-one AI assistant for text, images, and code.',
      image: Icons.chat_bubble_outline,
    ),
    _OnboardingPage(
      title: 'AI Text Writer',
      description: 'Generate creative, insightful text with a tap.',
      image: Icons.text_fields,
    ),
    _OnboardingPage(
      title: 'AI Image Generator',
      description: 'Turn prompts into stunning images instantly.',
      image: Icons.image,
    ),
    _OnboardingPage(
      title: 'AI Code Tutor',
      description: 'Learn, practice, and get code help in any language.',
      image: Icons.code,
    ),
    _OnboardingPage(
      title: 'Get Started!',
      description: 'Tap below to explore Chatterbox.',
      image: Icons.rocket_launch,
    ),
  ];

  void _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.ease);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate adaptive sizes based on screen constraints
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            final iconSize = maxHeight * 0.15; // 15% of screen height for icon
            final titleFontSize = maxWidth * 0.07; // 7% of screen width for title
            final descriptionFontSize = maxWidth * 0.045; // 4.5% of screen width for description
            final buttonPadding = EdgeInsets.symmetric(
              horizontal: maxWidth * 0.15, // 15% of screen width for horizontal padding
              vertical: maxHeight * 0.02, // 2% of screen height for vertical padding
            );
            final pagePadding = EdgeInsets.all(maxWidth * 0.08); // 8% of screen width for page padding
            
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Padding(
                        padding: pagePadding,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(page.image, color: Colors.purpleAccent, size: iconSize),
                            SizedBox(height: maxHeight * 0.03), // 3% of screen height
                            Text(
                              page.title,
                              style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: maxHeight * 0.02), // 2% of screen height
                            Text(
                              page.description,
                              style: TextStyle(fontSize: descriptionFontSize, color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: maxWidth * 0.01, vertical: maxHeight * 0.02),
                      width: _currentPage == index ? maxWidth * 0.04 : maxWidth * 0.02, // 4% and 2% of screen width
                      height: maxHeight * 0.01, // 1% of screen height
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.purpleAccent : Colors.white24,
                        borderRadius: BorderRadius.circular(maxWidth * 0.01),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: maxHeight * 0.03), // 3% of screen height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                      padding: buttonPadding,
                    ),
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Get Started' : 'Next', 
                      style: TextStyle(fontSize: titleFontSize * 0.7), // Slightly smaller than title
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String description;
  final IconData image;

  const _OnboardingPage({required this.title, required this.description, required this.image});
}
