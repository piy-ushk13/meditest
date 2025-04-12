import 'package:flutter/material.dart';

class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  // Helper method for responsive text scaling (copied from main.dart)
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Adjust the scale factor as needed
    return baseSize * (screenWidth / 375).clamp(0.8, 1.2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Medications',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface, // Use theme color
            fontSize: _getResponsiveFontSize(context, 22), // Make consistent
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor, // Match screen background
        elevation: 0, // Flat app bar
        centerTitle: true, // Center title for this page style
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        children: [
          // Placeholder for medication list - Adapt _buildInfoCard or create new widgets
          _buildSectionTitle('Active Medications', context),
          const SizedBox(height: 16),
          _buildPlaceholderCard(context, 'Lisinopril', '10mg, once daily', Icons.medical_services_rounded),
          _buildPlaceholderCard(context, 'Metformin', '500mg, twice daily', Icons.medication_liquid_rounded),
          const SizedBox(height: 30),
          _buildSectionTitle('Reminders', context),
          const SizedBox(height: 16),
           _buildPlaceholderCard(context, 'Morning Dose', 'Take Lisinopril & Metformin', Icons.alarm_on_rounded),
          // Add more content as needed
        ],
      ),
    );
  }

  // Placeholder card (adapt or replace with your actual card widget)
  Widget _buildPlaceholderCard(BuildContext context, String title, String subtitle, IconData icon) {
     final theme = Theme.of(context);
     final colorScheme = theme.colorScheme;
    return Card(
       // Use CardTheme from main theme
       // margin: const EdgeInsets.only(bottom: 16), // Let CardTheme handle margin if defined
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
             Container(
               padding: const EdgeInsets.all(12),
               decoration: BoxDecoration(
                 color: colorScheme.primaryContainer, // Use theme color
                 borderRadius: BorderRadius.circular(12.0),
               ),
               child: Icon(icon, color: colorScheme.primary, size: 22),
             ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith( // Use theme style
                       fontSize: _getResponsiveFontSize(context, 15),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                     style: theme.textTheme.bodyMedium?.copyWith( // Use theme style
                       fontSize: _getResponsiveFontSize(context, 13),
                     ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
             Icon(
               Icons.arrow_forward_ios_rounded,
               size: 14,
               color: Colors.grey.shade400,
             ),
          ],
        ),
      ),
    );
  }

   // Copied from main.dart for consistency (Consider extracting to a shared utility file)
   Widget _buildSectionTitle(String title, BuildContext context) {
     final theme = Theme.of(context);
     return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Text(
           title,
           style: TextStyle( // Keep explicit style for section title emphasis
             fontSize: _getResponsiveFontSize(context, 18),
             fontWeight: FontWeight.bold,
             color: theme.colorScheme.onSurface,
           ),
         ),
         // Optional: Add a 'View All' button if needed for this section
         // TextButton(...)
       ],
     );
   }
}