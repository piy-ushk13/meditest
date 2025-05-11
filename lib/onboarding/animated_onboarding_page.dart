import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../theme.dart';

class AnimatedOnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final int pageIndex;
  final int totalPages;
  final VoidCallback? onGetStarted;
  final VoidCallback onNext;
  final String imagePath;
  final Color bgColor;
  final String animationPath;
  final String animationText;

  const AnimatedOnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.pageIndex,
    required this.totalPages,
    required this.imagePath,
    required this.bgColor,
    required this.animationPath,
    required this.animationText,
    this.onGetStarted,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = pageIndex == totalPages - 1;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                bgColor.withValues(alpha: 0.2),
                AppTheme.backgroundColor,
              ],
            ),
          ),
        ),

        // Background patterns
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(300),
              ),
            ),
          ),
        ),

        // Additional decorative elements
        Positioned(
          bottom: size.height * 0.1,
          left: 0,
          child: Container(
            width: size.width * 0.6,
            height: size.height * 0.3,
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(300),
              ),
            ),
          ),
        ),

        // Small decorative circles
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.1,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ).animate().scale(
                duration: 1200.ms,
                curve: Curves.elasticOut,
                delay: 300.ms,
              ),
        ),

        Positioned(
          bottom: size.height * 0.25,
          right: size.width * 0.15,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ).animate().scale(
                duration: 1200.ms,
                curve: Curves.elasticOut,
                delay: 500.ms,
              ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Adjust top spacing based on page index
              SizedBox(
                  height:
                      pageIndex == 0 ? 10 : 20), // Less space for first screen
              // Animation at the top with transform to move it up
              // Apply extra offset for health tracking animation (page index 1)
              Transform.translate(
                offset: Offset(
                    0,
                    pageIndex == 0
                        ? -10 // Reduced offset for welcome animation to increase spacing
                        : pageIndex == 1
                            ? -60 // More offset for health tracking
                            : -20), // Default offset for other animations
                child: _buildAnimation(context),
              ),

              // Compact content section
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Adjust title position based on page index
                    Transform.translate(
                      offset: Offset(
                          0,
                          pageIndex == 0
                              ? 10 // Positive offset for welcome screen to increase spacing significantly
                              : -30), // Negative offset for other screens
                      child: Column(
                        children: [
                          _buildTitle(context),
                          SizedBox(
                              height: pageIndex == 0
                                  ? 8
                                  : 2), // More spacing for first screen
                          _buildDescription(context),
                        ],
                      ),
                    ),

                    // Move bottom elements further up
                    Transform.translate(
                      offset: const Offset(
                          0, -35), // Move up by 35 pixels (increased from -15)
                      child: Column(
                        children: [
                          _buildPageIndicator(context),
                          const SizedBox(height: 10), // Further reduced from 12
                          isLastPage
                              ? _buildGetStartedButton(context)
                              : _buildNextButton(context),
                          const SizedBox(
                              height:
                                  16), // Maintain bottom padding to prevent overflow
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimation(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Adjust height based on page index
    // Using slightly smaller heights to prevent overflow
    final double animationHeight;

    if (pageIndex == 0) {
      // Welcome screen animation - smaller to increase spacing with heading
      animationHeight =
          size.height * 0.35; // 35% for welcome screen (reduced from 40%)
    } else if (pageIndex == 1) {
      // Health tracking animation
      animationHeight = size.height * 0.42; // 42% for health tracking
    } else {
      // Other animations
      animationHeight = size.height * 0.38; // 38% for others
    }

    return SizedBox(
      height: animationHeight,
      width: size.width,
      child: Lottie.asset(
        animationPath,
        repeat: true,
        animate: true,
        // Use different fit for welcome animation to ensure it fills the space properly
        fit: pageIndex == 0 ? BoxFit.cover : BoxFit.contain,
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 500.ms)
        .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 500.ms);
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondaryColor,
            height: 1.5,
          ),
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 500.ms)
        .slideY(begin: 0.2, end: 0, delay: 600.ms, duration: 500.ms);
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == pageIndex ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == pageIndex
                ? AppTheme.primaryColor
                : AppTheme.primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onGetStarted,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Get Started',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 500.ms)
        .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 500.ms);
  }

  Widget _buildNextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 500.ms)
        .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 500.ms);
  }
}
