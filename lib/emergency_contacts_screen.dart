import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  static const String routeName = '/emergency';

  // Helper method for responsive text scaling
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    return baseSize * (screenWidth / 375).clamp(0.8, 1.2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Emergency Contacts',
          style: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.bold,
            fontSize: _getResponsiveFontSize(context, 20),
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildEmergencyContactSection(
                      'National Emergency Numbers',
                      [
                        EmergencyContact(
                          name: 'National Emergency Number',
                          number: '112',
                          description: 'Unified emergency helpline',
                          icon: Icons.emergency,
                        ),
                        EmergencyContact(
                          name: 'Police',
                          number: '100',
                          description: 'Law enforcement assistance',
                          icon: Icons.local_police_rounded,
                        ),
                        EmergencyContact(
                          name: 'Ambulance',
                          number: '102',
                          description: 'Medical emergency',
                          icon: Icons.medical_services_rounded,
                        ),
                        EmergencyContact(
                          name: 'Fire',
                          number: '101',
                          description: 'Fire emergency services',
                          icon: Icons.local_fire_department_rounded,
                        ),
                      ],
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildEmergencyContactSection(
                      'Women & Child Safety',
                      [
                        EmergencyContact(
                          name: 'Women Helpline',
                          number: '1091',
                          description: 'Assistance for women in distress',
                          icon: Icons.woman_rounded,
                        ),
                        EmergencyContact(
                          name: 'Women Helpline (Domestic Violence)',
                          number: '181',
                          description: 'Domestic abuse assistance',
                          icon: Icons.home_rounded,
                        ),
                        EmergencyContact(
                          name: 'Child Helpline',
                          number: '1098',
                          description: 'Assistance for children in distress',
                          icon: Icons.child_care_rounded,
                        ),
                      ],
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildEmergencyContactSection(
                      'Health & Disaster',
                      [
                        EmergencyContact(
                          name: 'COVID-19 Helpline',
                          number: '1075',
                          description: 'COVID-19 related assistance',
                          icon: Icons.coronavirus_rounded,
                        ),
                        EmergencyContact(
                          name: 'Disaster Management',
                          number: '108',
                          description: 'Disaster response services',
                          icon: Icons.warning_amber_rounded,
                        ),
                        EmergencyContact(
                          name: 'Road Accident Emergency',
                          number: '1073',
                          description: 'Highway emergency assistance',
                          icon: Icons.car_crash_rounded,
                        ),
                      ],
                      context,
                    ),
                  ]
                      .animate(interval: 50.ms)
                      .fadeIn(duration: 400.ms, curve: Curves.easeOutQuad)
                      .slideY(
                          begin: 0.1,
                          end: 0,
                          duration: 400.ms,
                          curve: Curves.easeOutQuad),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red.shade700,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'In case of emergency',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _getResponsiveFontSize(context, 16),
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap the call button to directly contact emergency services',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.red.shade800.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildEmergencyContactSection(
      String title, List<EmergencyContact> contacts, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 18),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ...contacts.map((contact) => _buildContactCard(context, contact)),
      ],
    );
  }

  Widget _buildContactCard(BuildContext context, EmergencyContact contact) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showCallConfirmation(context, contact),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  contact.icon,
                  color: Colors.red.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    contact.number,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _getResponsiveFontSize(context, 16),
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showCallConfirmation(context, contact),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      elevation: 2,
                    ),
                    child: const Icon(Icons.phone, size: 20),
                  ).animate().scale(
                        duration: 200.ms,
                        curve: Curves.easeOut,
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1.0, 1.0),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCallConfirmation(BuildContext context, EmergencyContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call ${contact.name}?'),
        content: Text('Are you sure you want to call ${contact.number}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _makePhoneCall(contact.number);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red.shade600,
            ),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.DIAL',
        data: 'tel:$phoneNumber',
      );
      await intent.launch();
    } on PlatformException catch (e) {
      debugPrint('Error making phone call: $e');
      // You might want to show a snackbar or dialog here
    }
  }
}

class EmergencyContact {
  final String name;
  final String number;
  final String description;
  final IconData icon;

  EmergencyContact({
    required this.name,
    required this.number,
    required this.description,
    required this.icon,
  });
}
