import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Assuming theme colors are accessible via Theme.of(context)
// const Color primaryColor = Color(0xFF5A67D8);
// const Color secondaryColor = Color(0xFF38B2AC);
// const Color backgroundColor = Color(0xFFF7FAFC);
// const Color textColor = Color(0xFF1A202C);
// const Color subtleTextColor = Color(0xFF718096);

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  String _selectedFilter = 'All Doctors'; // To track the selected filter chip

  // Dummy data for doctors list
  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Sarah Wilson',
      'specialty': 'Cardiologist',
      'rating': 4.8,
      'reviews': 124,
      'available': true,
      'image': 'https://via.placeholder.com/150/AAAAAA/FFFFFF?text=Dr.W', // Placeholder
    },
    {
      'name': 'Dr. Michael Chen',
      'specialty': 'Pediatrician',
      'rating': 4.9,
      'reviews': 198,
      'available': true,
      'image': 'https://via.placeholder.com/150/333333/FFFFFF?text=Dr.C', // Placeholder
    },
    {
      'name': 'Dr. Emily Carter',
      'specialty': 'Dentist',
      'rating': 4.7,
      'reviews': 95,
      'available': false,
      'image': 'https://via.placeholder.com/150/CCCCCC/FFFFFF?text=Dr.E', // Placeholder
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Find Doctors',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: colorScheme.onSurface.withOpacity(0.7)),
            onPressed: () {
              // TODO: Implement filter action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Map Placeholder
          Container(
            height: 200, // Adjust height as needed
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade300, // Placeholder color
              borderRadius: BorderRadius.circular(12.0),
              image: const DecorationImage( // Optional: Placeholder image
                image: NetworkImage('https://via.placeholder.com/600x300/E0E0E0/AAAAAA?text=Map+Placeholder'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Icon(Icons.map_outlined, color: Colors.grey.shade600, size: 50),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 16.0),

          // Filter Chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildFilterChip(context, 'All Doctors'),
                _buildFilterChip(context, 'Cardiologist'),
                _buildFilterChip(context, 'Dentist'),
                _buildFilterChip(context, 'Pediatrician'),
                _buildFilterChip(context, 'General'),
                // Add more filters if needed
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16.0),

          // Doctors List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _doctors.length,
              itemBuilder: (context, index) {
                return _buildDoctorCard(context, _doctors[index])
                    .animate(delay: (300 + index * 100).ms)
                    .fadeIn()
                    .slideY(begin: 0.2, curve: Curves.easeOut);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isSelected = _selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedFilter = label;
              // TODO: Add logic to filter doctors list based on chip
            });
          }
        },
        selectedColor: colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.3),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map<String, dynamic> doctor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(doctor['image']),
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            doctor['name'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: doctor['available']
                                  ? colorScheme.secondary.withOpacity(0.1)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              doctor['available'] ? 'Available' : 'Unavailable',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: doctor['available']
                                    ? colorScheme.secondary
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor['specialty'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${doctor['rating']} (${doctor['reviews']} reviews)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement booking logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Book Appointment with ${doctor['name']}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 48), // Full width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2,
                shadowColor: colorScheme.primary.withOpacity(0.2),
              ),
              child: const Text('Book Appointment', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}