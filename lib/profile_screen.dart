import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming a light theme with blue/teal accents based on the screenshot
    final Color primaryColor = Colors.teal; // Or your app's primary color
    final Color accentColor = Colors.blue.shade600; // Or your app's accent color
    final Color cardBackgroundColor = Colors.white;
    final Color textColor = Colors.black87;
    final Color subtleTextColor = Colors.grey.shade600;
    final Color iconColor = Colors.teal.shade300;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      appBar: AppBar(
        title: const Text('Profile'), // Placeholder title, can be removed if not needed
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: textColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(accentColor, textColor, subtleTextColor),
            const SizedBox(height: 24.0),
            Text('Health Metrics', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor)),
            const SizedBox(height: 16.0),
            _buildHealthMetrics(cardBackgroundColor, iconColor, textColor, subtleTextColor),
            const SizedBox(height: 24.0),
            _buildMedicalRecordsHeader(context, accentColor, textColor),
            const SizedBox(height: 16.0),
            _buildMedicalRecordItem(
              title: 'Annual Checkup',
              subtitle: 'Dr. Smith • General',
              date: '15 Jan 2025',
              icon: Icons.description, // Placeholder icon
              iconColor: iconColor,
              cardBackgroundColor: cardBackgroundColor,
              textColor: textColor,
              subtleTextColor: subtleTextColor,
            ),
            const SizedBox(height: 12.0),
            _buildMedicalRecordItem(
              title: 'Blood Test Results',
              subtitle: 'City Lab',
              date: '02 Jan 2025',
              icon: Icons.science_outlined, // Placeholder icon
              iconColor: iconColor,
              cardBackgroundColor: cardBackgroundColor,
              textColor: textColor,
              subtleTextColor: subtleTextColor,
            ),
            const SizedBox(height: 12.0),
            _buildMedicalRecordItem(
              title: 'Prescription',
              subtitle: 'Dr. Chen • Cardiology',
              date: '28 Dec 2024',
              icon: Icons.receipt_long, // Placeholder icon (Rx symbol might need custom icon)
              iconColor: iconColor,
              cardBackgroundColor: cardBackgroundColor,
              textColor: textColor,
              subtleTextColor: subtleTextColor,
            ),
          ],
        ),
      ),
      // The BottomNavigationBar will be handled in the main scaffold (e.g., main.dart)
    );
  }

  Widget _buildProfileHeader(Color accentColor, Color textColor, Color subtleTextColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35.0,
            // Placeholder image - replace with actual image loading
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alex Parker',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 4.0),
              Text(
                'ID: MED-2025-0123',
                style: TextStyle(fontSize: 14.0, color: subtleTextColor),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  _buildInfoChip('Age: 32', accentColor),
                  const SizedBox(width: 8.0),
                  _buildInfoChip('B+', accentColor),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.0, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildHealthMetrics(Color cardBackgroundColor, Color iconColor, Color textColor, Color subtleTextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetricCard(
          icon: Icons.monitor_weight_outlined,
          label: 'Weight',
          value: '75 kg',
          iconColor: iconColor,
          cardBackgroundColor: cardBackgroundColor,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
        ),
        _buildMetricCard(
          icon: Icons.height,
          label: 'Height',
          value: '180 cm',
          iconColor: iconColor,
          cardBackgroundColor: cardBackgroundColor,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
        ),
        _buildMetricCard(
          icon: Icons.show_chart,
          label: 'BMI',
          value: '23.1',
          iconColor: iconColor,
          cardBackgroundColor: cardBackgroundColor,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color cardBackgroundColor,
    required Color textColor,
    required Color subtleTextColor,
  }) {
    return Expanded(
      child: Card(
        color: cardBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        margin: const EdgeInsets.symmetric(horizontal: 4.0), // Add some spacing between cards
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 30.0, color: iconColor),
              const SizedBox(height: 8.0),
              Text(label, style: TextStyle(fontSize: 12.0, color: subtleTextColor)),
              const SizedBox(height: 4.0),
              Text(value, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalRecordsHeader(BuildContext context, Color accentColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Medical Records', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor)),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Implement Add Record functionality
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalRecordItem({
    required String title,
    required String subtitle,
    required String date,
    required IconData icon,
    required Color iconColor,
    required Color cardBackgroundColor,
    required Color textColor,
    required Color subtleTextColor,
  }) {
    return Card(
      color: cardBackgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
        subtitle: Text('$subtitle\n$date', style: TextStyle(color: subtleTextColor, height: 1.4)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // TODO: Implement navigation to record details
        },
      ),
    );
  }
}