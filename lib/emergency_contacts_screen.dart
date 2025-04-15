import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';
import 'widgets/custom_app_bar.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      await launchUrl(launchUri);
    } catch (e) {
      debugPrint('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Emergency',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmergencyHeader(),
              const SizedBox(height: 24),
              _buildEmergencyServices(context),
              const SizedBox(height: 24),
              _buildPersonalContacts(context),
              const SizedBox(height: 24),
              _buildNearbyHospitals(context),
              const SizedBox(height: 24),
              _buildEmergencyTips(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _makePhoneCall('112');
        },
        backgroundColor: Colors.red,
        icon: const Icon(Icons.phone),
        label: const Text('Emergency 112'),
      ).animate().scale(
            delay: 500.ms,
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
    );
  }

  Widget _buildEmergencyHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emergency,
              color: Colors.red.shade700,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency Help',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quick access to emergency services and contacts',
                  style: TextStyle(
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildEmergencyServices(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {
        'name': 'Ambulance',
        'number': '102',
        'icon': Icons.local_hospital,
        'color': Colors.red.shade400,
      },
      {
        'name': 'Police',
        'number': '100',
        'icon': Icons.local_police,
        'color': Colors.blue.shade400,
      },
      {
        'name': 'Fire',
        'number': '101',
        'icon': Icons.fire_truck,
        'color': Colors.orange.shade400,
      },
      {
        'name': 'Emergency',
        'number': '112',
        'icon': Icons.emergency,
        'color': Colors.purple.shade400,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emergency Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () => _makePhoneCall(service['number'] as String),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        service['icon'] as IconData,
                        size: 32,
                        color: service['color'] as Color,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().scale(delay: 50.ms * index);
          },
        ),
      ],
    );
  }

  Widget _buildPersonalContacts(BuildContext context) {
    final contacts = [
      {
        'name': 'Dr. Sarah Johnson',
        'relation': 'Primary Doctor',
        'number': '+1 234 567 8900',
      },
      {
        'name': 'Jane Doe',
        'relation': 'Emergency Contact',
        'number': '+1 234 567 8901',
      },
      {
        'name': 'City General Hospital',
        'relation': 'Primary Hospital',
        'number': '+1 234 567 8902',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Emergency Contacts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...contacts.asMap().entries.map((entry) {
          final index = entry.key;
          final contact = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () => _makePhoneCall(contact['number']!),
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  contact['name']!.substring(0, 1),
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(contact['name']!),
              subtitle: Text(contact['relation']!),
              trailing: IconButton(
                icon: const Icon(Icons.phone),
                color: AppTheme.primaryColor,
                onPressed: () => _makePhoneCall(contact['number']!),
              ),
            ),
          ).animate().fadeIn(delay: 100.ms * index).slideX(begin: 0.2);
        }),
      ],
    );
  }

  Widget _buildNearbyHospitals(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nearby Hospitals',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            onTap: () {
              Navigator.pushNamed(context, '/map');
            },
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_on,
                color: AppTheme.primaryColor,
              ),
            ),
            title: const Text('Find Nearby Hospitals'),
            subtitle: const Text('View hospitals in your area'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
        ).animate().fadeIn().slideX(begin: 0.2),
      ],
    );
  }

  Widget _buildEmergencyTips(BuildContext context) {
    final tips = [
      'Stay calm and assess the situation',
      'Call emergency services immediately if needed',
      'Keep emergency contacts easily accessible',
      'Know your current location',
      'Follow emergency service instructions',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emergency Tips',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: tips.asMap().entries.map((entry) {
                final index = entry.key;
                final tip = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(tip),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms * index).slideX(begin: 0.2);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
