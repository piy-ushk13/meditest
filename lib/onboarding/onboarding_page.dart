import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final int pageIndex;
  final int totalPages;
  final VoidCallback? onGetStarted;
  final VoidCallback onNext;
  final String imagePath;
  final Color bgColor;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.pageIndex,
    required this.totalPages,
    required this.imagePath,
    required this.bgColor,
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildIllustration(context),
              const SizedBox(height: 40),
              _buildTitle(context),
              const SizedBox(height: 16),
              _buildDescription(context),
              const Spacer(),
              _buildPageIndicator(context),
              const SizedBox(height: 40),
              isLastPage
                  ? _buildGetStartedButton(context)
                  : _buildNextButton(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
        ).animate().scale(
              duration: 800.ms,
              curve: Curves.elasticOut,
              delay: 100.ms,
            ),

        // Main circle with icon
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 100,
            color: AppTheme.primaryColor,
          ),
        )
            .animate()
            .scale(
              duration: 600.ms,
              curve: Curves.elasticOut,
              delay: 200.ms,
            )
            .fadeIn(duration: 300.ms),

        // Floating elements
        Positioned(
          top: 20,
          right: 40,
          child: _buildFloatingElement(
            Icons.favorite,
            AppTheme.primaryColor.withValues(alpha: 0.8),
            30,
            delay: 400.ms,
          ),
        ),

        Positioned(
          bottom: 30,
          left: 50,
          child: _buildFloatingElement(
            Icons.medical_services,
            AppTheme.secondaryColor.withValues(alpha: 0.8),
            24,
            delay: 600.ms,
          ),
        ),

        Positioned(
          top: 80,
          left: 30,
          child: _buildFloatingElement(
            Icons.monitor_heart,
            Colors.redAccent.withValues(alpha: 0.7),
            28,
            delay: 800.ms,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingElement(IconData icon, Color color, double size,
      {required Duration delay}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    )
        .animate()
        .scale(
          duration: 400.ms,
          curve: Curves.elasticOut,
          delay: delay,
        )
        .fadeIn(duration: 300.ms, delay: delay)
        .moveY(
          begin: 10,
          end: 0,
          curve: Curves.easeOutQuad,
          duration: 600.ms,
          delay: delay,
        );
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
