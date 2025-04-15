import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, String> _userInfo = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+1 234 567 8900',
    'dob': '15 April 1990',
    'gender': 'Male',
    'bloodGroup': 'O+',
    'height': '175 cm',
    'weight': '70 kg',
    'address': '123 Healthcare Street, Medical City, MC 12345',
    'emergencyContact': 'Jane Doe (+1 234 567 8901)',
    'allergies': 'Peanuts, Penicillin',
    'chronicConditions': 'None',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildProfileContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar.large(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // TODO: Implement edit profile
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // TODO: Implement settings
          },
        ),
      ],
    );
  }

  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildInfoSection('Personal Information', [
            _buildInfoItem(Icons.person, 'Full Name', _userInfo['name']!),
            _buildInfoItem(Icons.email, 'Email', _userInfo['email']!),
            _buildInfoItem(Icons.phone, 'Phone', _userInfo['phone']!),
            _buildInfoItem(Icons.cake, 'Date of Birth', _userInfo['dob']!),
            _buildInfoItem(
                Icons.person_outline, 'Gender', _userInfo['gender']!),
          ]),
          const SizedBox(height: 24),
          _buildInfoSection('Medical Information', [
            _buildInfoItem(
                Icons.bloodtype, 'Blood Group', _userInfo['bloodGroup']!),
            _buildInfoItem(Icons.height, 'Height', _userInfo['height']!),
            _buildInfoItem(
                Icons.monitor_weight, 'Weight', _userInfo['weight']!),
            _buildInfoItem(
                Icons.warning_amber, 'Allergies', _userInfo['allergies']!),
            _buildInfoItem(
              Icons.medical_information,
              'Chronic Conditions',
              _userInfo['chronicConditions']!,
            ),
          ]),
          const SizedBox(height: 24),
          _buildInfoSection('Address & Emergency Contact', [
            _buildInfoItem(Icons.location_on, 'Address', _userInfo['address']!),
            _buildInfoItem(
              Icons.emergency,
              'Emergency Contact',
              _userInfo['emergencyContact']!,
            ),
          ]),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Text(
                _userInfo['name']!.substring(0, 2).toUpperCase(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 20,
                color: Colors.white,
              ),
            ).animate().scale(delay: 200.ms, duration: 400.ms),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _userInfo['name']!,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
        const SizedBox(height: 4),
        Text(
          _userInfo['email']!,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          ...items,
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.2);
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Implement medical records
          },
          icon: const Icon(Icons.library_books),
          label: const Text('View Medical Records'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Implement logout
          },
          icon: const Icon(Icons.logout),
          label: const Text('Log Out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2);
  }
}
