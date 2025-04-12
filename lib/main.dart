import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
// Import the details screen
import 'package:myapp/profile_screen.dart'; // Import the profile screen
import 'package:myapp/ai_chat_screen.dart'; // Import the AI chat screen
import 'package:myapp/login_screen.dart'; // Import the Login screen
import 'package:myapp/signup_screen.dart'; // Import the Signup screen
import 'package:myapp/search_screen.dart'; // Import the Search screen
import 'package:myapp/doctors_screen.dart'; // Import the Doctors screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Health App UI',
      theme: ThemeData(
        primaryColor: const Color(0xFF5A67D8),
        scaffoldBackgroundColor: const Color(0xFFF7FAFC),
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5A67D8),
          secondary: const Color(0xFF38B2AC),
          brightness: Brightness.light,
        ).copyWith(
          surface: Colors.white,
          onSurface: const Color(0xFF1A202C),
          primaryContainer: const Color(0xFF5A67D8).withAlpha(26),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shadowColor: Colors.black.withAlpha(13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF4A5568)),
          bodyMedium: TextStyle(color: Color(0xFF718096)),
          titleLarge: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A202C)),
          titleMedium: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
          titleSmall: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF4A5568)),
          labelLarge: TextStyle(fontWeight: FontWeight.w600),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF5A67D8),
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          elevation: 0,
        ),
      ),
      initialRoute: LoginScreen.routeName, // Start with Login screen
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(), // Add route for Home
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home'; // Define route name for Home

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0; // To track selected bottom nav item
  late final AnimationController _pageAnimationController;
  late final TabController _tabController;

  // List of pages corresponding to the BottomNavigationBar items
  final List<Widget> _pages = [
    const HomePageContent(), // Index 0: Home
    const SearchScreen(),    // Index 1: Search
    const AiChatScreen(),    // Index 2: Assistant
    const ProfileScreen(),   // Index 3: Profile
    const DoctorsScreen(),   // Index 4: Doctors
  ];

  @override
  void initState() {
    super.initState();
    _pageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _tabController = TabController(length: _pages.length, vsync: this); // Use length of _pages

    // Start the initial page animation
    _pageAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // Logic for all tabs (Home, Search, Assistant, Profile, Doctors)
    if (_selectedIndex == index) return; // Do nothing if the same tab is tapped

    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index); // Sync TabController if needed elsewhere
    });

    // Restart animation when changing pages
    _pageAnimationController.reset();
    _pageAnimationController.forward();
  }

  // Helper method for responsive text scaling (kept for HomePageContent)
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    return baseSize * (screenWidth / 375).clamp(0.8, 1.2);
  }

  // Build method for _HomeScreenState (was missing)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder( // Keep page transition animation
          animation: _pageAnimationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                curve: Curves.easeInOut,
                parent: _pageAnimationController,
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  curve: Curves.easeOutQuart,
                  parent: _pageAnimationController,
                )),
                child: child,
              ),
            );
          },
          // Use IndexedStack to keep the state of each page
          child: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
        ), // End SafeArea
      ),
      bottomNavigationBar: Container( // Wrap BottomNavBar for custom shadow/border
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect( // Clip the content to the rounded corners
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              _buildNavItem(Icons.home_rounded, 'Home'),
              _buildNavItem(Icons.search_rounded, 'Search'),
              _buildNavItem(Icons.smart_toy_rounded, 'Assistant'), // Correct label
              _buildNavItem(Icons.person_rounded, 'Profile'),
              _buildNavItem(Icons.location_on_rounded, 'Doctors'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            // Theme properties are applied from BottomNavigationBarThemeData
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Emergency contact feature activated')),
          );
        },
        backgroundColor: Colors.red.shade400,
        shape: const CircleBorder(),
        child: const Icon(Icons.emergency_outlined, color: Colors.white),
      ).animate().scale(
        duration: 700.ms,
        curve: Curves.elasticOut,
        delay: 300.ms,
      ),
    );
  }

  // _buildNavItem remains the same
  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 24),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
      ).animate().scale(
        duration: 200.ms,
        curve: Curves.easeOut,
        begin: const Offset(0.9, 0.9),
        end: const Offset(1.0, 1.0),
      ).fadeIn(duration: 150.ms),
      label: label,
    );
  }
}

// The Medication class definition has been removed from here.
// It is imported from 'package:myapp/medication_details_screen.dart' where needed.


// Extracted HomePage Content into its own StatelessWidget
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  // Helper method for responsive text scaling (copied from _HomeScreenState)
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    return baseSize * (screenWidth / 375).clamp(0.8, 1.2);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        _buildHealthStats(context),
        const SizedBox(height: 30),
        _buildSectionTitle('Daily Health Tips', context),
        const SizedBox(height: 16),
        _buildHealthTips(context),
        const SizedBox(height: 30),
        _buildNextMedicineDue(context),
        const SizedBox(height: 30),
        _buildSectionTitle('Health Updates', context),
        const SizedBox(height: 16),
        _buildHealthUpdates(context),
      ]
          .animate(interval: 50.ms)
          .fadeIn(duration: 400.ms, curve: Curves.easeOutQuad)
          .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
    );
  }

  // All the _build* methods previously in _HomeScreenState are moved here
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 16),
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Nilesh!', // Assuming this should be dynamic later
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 26),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Health favorites accessed')),
            );
          },
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withAlpha(204),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withAlpha(77),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.favorite_rounded, color: Colors.white),
          ),
        ).animate().scale(
          duration: 300.ms,
          curve: Curves.easeOut,
          delay: 200.ms,
        ),
      ],
    );
  }

  Widget _buildHealthStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withAlpha(204),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(77),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Todays Health',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: _getResponsiveFontSize(context, 16),
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white,
                      size: _getResponsiveFontSize(context, 14),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'April 7', // Assuming this should be dynamic later
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withAlpha(230),
                            fontSize: _getResponsiveFontSize(context, 13),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(context, '8,546', 'Steps', Icons.directions_walk_rounded),
              _buildStatItem(context, '6.2', 'Hours', Icons.nightlight_rounded),
              _buildStatItem(context, '72', 'BPM', Icons.favorite_rounded),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: 600.ms,
      curve: Curves.easeOut,
      delay: 200.ms,
    ).slideY(
      begin: 0.2,
      end: 0,
      duration: 600.ms,
      curve: Curves.easeOutQuart,
      delay: 200.ms,
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(38),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: _getResponsiveFontSize(context, 20),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: _getResponsiveFontSize(context, 18),
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withAlpha(204),
                fontSize: _getResponsiveFontSize(context, 12),
              ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 18),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('View all $title')),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthTips(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context: context,
            icon: Icons.restaurant_rounded,
            iconBgColor: Colors.blue.shade100,
            iconColor: Colors.blue.shade700,
            title: 'Healthy Diet',
            subtitle: 'Include fruits and vegetables in your daily meals',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Healthy Diet tips accessed')),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            context: context,
            icon: Icons.fitness_center_rounded,
            iconBgColor: Colors.green.shade100,
            iconColor: Colors.green.shade700,
            title: 'Exercise',
            subtitle: 'Stay active for at least 30 minutes a day',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exercise tips accessed')),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextMedicineDue(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: primaryColor.withOpacity(0.05),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.05),
              primaryColor.withOpacity(0.01),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Text(
                      'Next Medicine Due',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: secondaryColor.withOpacity(0.9),
                            fontSize: _getResponsiveFontSize(context, 13),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.medication_rounded,
                          color: secondaryColor,
                          size: 20,
                        ),
                      ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
                      const SizedBox(width: 10),
                      Text(
                        'Vitamin D3', // Example name
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: _getResponsiveFontSize(context, 18),
                              fontWeight: FontWeight.bold,
                            ),
                      ).animate().fadeIn(duration: 300.ms),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: _buildCountdown(context),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Medicine taken!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: Colors.black.withAlpha(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              child: const Text('Take Now'),
            ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2, duration: 400.ms, curve: Curves.easeOut);
  }

  List<Widget> _buildCountdown(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    const String hours = '01';
    const String minutes = '45';
    const String seconds = '30';

    TextStyle numberStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
          color: onSurfaceColor,
          fontWeight: FontWeight.bold,
          fontSize: _getResponsiveFontSize(context, 22),
        );
    TextStyle labelStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: onSurfaceColor.withOpacity(0.6),
          fontSize: _getResponsiveFontSize(context, 10),
        );
    TextStyle separatorStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
          color: primaryColor.withOpacity(0.5),
          fontWeight: FontWeight.bold,
          fontSize: _getResponsiveFontSize(context, 20),
        );

    return [
      _buildTimePart(context, hours, 'hr', numberStyle, labelStyle),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(':', style: separatorStyle),
      ),
      _buildTimePart(context, minutes, 'min', numberStyle, labelStyle),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(':', style: separatorStyle),
      ),
      _buildTimePart(context, seconds, 'sec', numberStyle, labelStyle),
    ].animate(interval: 100.ms).fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildTimePart(BuildContext context, String value, String label, TextStyle numberStyle, TextStyle labelStyle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: numberStyle),
        Text(label, style: labelStyle),
      ],
    );
  }

  Widget _buildHealthUpdates(BuildContext context) {
    return Column(
      children: [
        _buildUpdateItem(
          context: context,
          icon: Icons.article_rounded,
          iconBgColor: Colors.orange.shade100,
          iconColor: Colors.orange.shade700,
          title: 'New Health Article',
          subtitle: 'Benefits of Meditation',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Health Article tapped')),
          ),
        ),
        _buildUpdateItem(
          context: context,
          icon: Icons.local_hospital_rounded,
          iconBgColor: Colors.purple.shade100,
          iconColor: Colors.purple.shade700,
          title: 'Upcoming Appointment',
          subtitle: 'Dr. Smith - April 10th',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment tapped')),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: _getResponsiveFontSize(context, 24),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: _getResponsiveFontSize(context, 15),
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: _getResponsiveFontSize(context, 13),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateItem({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: _getResponsiveFontSize(context, 22),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: _getResponsiveFontSize(context, 15),
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: _getResponsiveFontSize(context, 13),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
                size: _getResponsiveFontSize(context, 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}