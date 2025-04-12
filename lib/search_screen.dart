import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:myapp/medication_details_screen.dart'; // For Medication class and potential navigation

// Assuming theme colors are accessible via Theme.of(context)
// Or define them explicitly if needed, matching main.dart
// const Color primaryColor = Color(0xFF5A67D8);
// const Color secondaryColor = Color(0xFF38B2AC);
// const Color backgroundColor = Color(0xFFF7FAFC);
// const Color textColor = Color(0xFF1A202C);
// const Color subtleTextColor = Color(0xFF718096);

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy data for medication list
  final List<Medication> _searchResults = [
    Medication(
      name: 'Paracetamol 500mg',
      dosage: 'Generic Medicine • Tablet', // Using dosage field for subtitle
      frequency: '', // Not used directly in this card
      sideEffects: ['Pain relief, fever reduction', 'May cause nausea, stomach pain'], // Using sideEffects for info/warnings
      history: [], // Not used here
    ),
    Medication(
      name: 'Ibuprofen 400mg',
      dosage: 'NSAID • Tablet',
      frequency: '',
      sideEffects: ['Anti-inflammatory, pain relief', 'Avoid on empty stomach'],
      history: [],
    ),
    // Add more dummy medications if needed
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToDetails(Medication medication) {
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicationDetailsScreen(
            medication: medication, // Pass the selected medication
          ),
        ),
      );
  }


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
          'MediAssist AI', // Title from screenshot
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              // Placeholder image - replace with actual user image logic if available
              backgroundImage: NetworkImage('https://via.placeholder.com/150/771796'), // Placeholder
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
      body: ListView( // Use ListView to allow scrolling
        padding: const EdgeInsets.all(16.0),
        children: [
          // Search Input Field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search medicines...',
              prefixIcon: Icon(Icons.search, color: colorScheme.primary),
              filled: true,
              fillColor: colorScheme.surface, // White background
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none, // No border needed if filled
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0), // Adjust padding
            ),
            onChanged: (value) {
              // TODO: Implement search filtering logic
            },
          ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.1),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.camera_alt_outlined, color: colorScheme.primary),
                  label: Text('Scan Medicine', style: TextStyle(color: colorScheme.primary)),
                  onPressed: () {
                    // TODO: Implement Scan Medicine
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.mic_none_rounded, color: colorScheme.primary),
                  label: Text('Voice Search', style: TextStyle(color: colorScheme.primary)),
                  onPressed: () {
                    // TODO: Implement Voice Search
                  },
                   style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 24),

          // Search Results List
          // Using dummy data for now
          ..._searchResults.map((med) => _buildMedicationCard(context, med))
              .toList()
              .animate(interval: 100.ms)
              .fadeIn(delay: 300.ms)
              .slideY(begin: 0.1),

        ],
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context, Medication medication) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Extract info and warnings from sideEffects list (assuming specific structure)
    String infoText = medication.sideEffects.isNotEmpty ? medication.sideEffects[0] : 'No information available.';
    String warningText = medication.sideEffects.length > 1 ? medication.sideEffects[1] : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 1, // Subtle elevation
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: colorScheme.surface, // White card background
      child: InkWell( // Make card tappable
        borderRadius: BorderRadius.circular(12.0),
        onTap: () => _navigateToDetails(medication),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      medication.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(Icons.bookmark_border_rounded, color: colorScheme.primary.withOpacity(0.7)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                medication.dosage, // Using dosage as subtitle
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      infoText,
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.8)),
                    ),
                  ),
                ],
              ),
              if (warningText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        warningText,
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.8)),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}