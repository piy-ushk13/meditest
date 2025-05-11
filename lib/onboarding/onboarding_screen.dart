import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'onboarding_page.dart';
import 'animated_onboarding_page.dart';
import '../theme.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Welcome to MediAssist AI',
      'description':
          'Your personal healthcare companion for managing appointments, medications, and health records.',
      'icon': Icons.medical_services_rounded,
      'imagePath': 'assets/images/doctor_illustration.png',
      'bgColor': const Color(0xFFE3F2FD),
      'isAnimated': true,
      'animationPath': 'assets/animations/welcome_animation.json',
      'animationText': '',
    },
    {
      'title': 'Track Your Health Journey',
      'description':
          'Monitor vital signs, schedule appointments with top doctors, and access your medical records anytime.',
      'icon': Icons.monitor_heart_rounded,
      'imagePath': 'assets/images/health_tracking.png',
      'bgColor': const Color(0xFFE8F5E9),
      'isAnimated': true,
      'animationPath': 'assets/animations/health_tracking.json',
      'animationText': '',
    },
    {
      'title': '24/7 Medical Assistance',
      'description':
          'Get instant medical advice, emergency support, and personalized health recommendations.',
      'icon': Icons.health_and_safety_rounded,
      'imagePath': 'assets/images/medical_assistance.png',
      'bgColor': const Color(0xFFE1F5FE),
      'isAnimated': true,
      'animationPath': 'assets/animations/medical_assistance.json',
      'animationText': '',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Set system UI overlay style for better visibility
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _skipToLastPage() {
    final lastPageIndex = _onboardingData.length - 1;
    _pageController.animateToPage(
      lastPageIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildSkipButton(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final bool isAnimated =
                      _onboardingData[index]['isAnimated'] ?? false;

                  if (isAnimated) {
                    return AnimatedOnboardingPage(
                      title: _onboardingData[index]['title'],
                      description: _onboardingData[index]['description'],
                      icon: _onboardingData[index]['icon'],
                      imagePath: _onboardingData[index]['imagePath'],
                      bgColor: _onboardingData[index]['bgColor'],
                      animationPath: _onboardingData[index]['animationPath'],
                      animationText: _onboardingData[index]['animationText'],
                      pageIndex: index,
                      totalPages: _onboardingData.length,
                      onGetStarted: index == _onboardingData.length - 1
                          ? _navigateToLogin
                          : null,
                      onNext: _nextPage,
                    );
                  } else {
                    return OnboardingPage(
                      title: _onboardingData[index]['title'],
                      description: _onboardingData[index]['description'],
                      icon: _onboardingData[index]['icon'],
                      imagePath: _onboardingData[index]['imagePath'],
                      bgColor: _onboardingData[index]['bgColor'],
                      pageIndex: index,
                      totalPages: _onboardingData.length,
                      onGetStarted: index == _onboardingData.length - 1
                          ? _navigateToLogin
                          : null,
                      onNext: _nextPage,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    final bool isLastScreen = _currentPage == _onboardingData.length - 1;

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextButton(
          onPressed: isLastScreen ? _navigateToLogin : _skipToLastPage,
          style: TextButton.styleFrom(
            backgroundColor: isLastScreen
                ? AppTheme.primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isLastScreen ? 16 : 12),
            ),
            padding: isLastScreen
                ? const EdgeInsets.all(12) // Square padding for arrow button
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: isLastScreen
                ? const Size(48, 48)
                : null, // Fixed size for arrow button
          ),
          child: isLastScreen
              // Show only arrow icon on last screen
              ? Icon(
                  Icons.arrow_forward_rounded,
                  color: AppTheme.primaryColor,
                  size: 24,
                )
              // Show Skip text on other screens
              : Text(
                  'Skip',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
