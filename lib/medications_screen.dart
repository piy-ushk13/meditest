import 'package:flutter/material.dart';
import 'medication_details_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['Current', 'Upcoming', 'Past'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                  ),
                ),
              ),
              title: const Text(
                'My Medications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: _categories
                  .map((category) => _MedicationList(category: category))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMedicationDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Medication'),
      ).animate().scale(delay: 500.ms),
    );
  }

  void _showAddMedicationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddMedicationSheet(),
    );
  }
}

class _MedicationList extends StatelessWidget {
  final String category;

  const _MedicationList({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual medication data
    final medications = [
      Medication(
        name: 'Amoxicillin',
        description: 'Antibiotic used to treat bacterial infections',
        dosage: '500mg',
        form: 'Capsule',
        route: 'Oral',
        frequency: '3 times daily',
        duration: '7 days',
        timing: 'After meals',
        sideEffects: [
          'Nausea',
          'Diarrhea',
          'Rash',
          'Vomiting',
        ],
        precautions: [
          'Take with food',
          'Complete the full course',
          'Avoid alcohol',
        ],
        activeIngredient: 'Amoxicillin trihydrate',
        manufacturer: 'Generic Pharma Inc.',
        prescriptionRequired: true,
      ),
      // Add more medications here
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: medications.length,
      itemBuilder: (context, index) {
        final medication = medications[index];
        return _MedicationCard(
          medication: medication,
          index: index,
        );
      },
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final Medication medication;
  final int index;

  const _MedicationCard({
    required this.medication,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationDetailsScreen(
              medication: medication,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.medication_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          medication.dosage,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded),
                    onPressed: () => _showMedicationOptions(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(
                    theme,
                    Icons.schedule_rounded,
                    medication.frequency,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    theme,
                    Icons.calendar_today_rounded,
                    medication.duration,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.2);
  }

  Widget _buildInfoChip(ThemeData theme, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showMedicationOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Edit Medication'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement edit medication
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded),
              title: const Text('Delete Medication'),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement delete medication
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AddMedicationSheet extends StatefulWidget {
  const _AddMedicationSheet();

  @override
  State<_AddMedicationSheet> createState() => _AddMedicationSheetState();
}

class _AddMedicationSheetState extends State<_AddMedicationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  String? _selectedForm;
  String? _selectedFrequency;

  final _forms = ['Tablet', 'Capsule', 'Liquid', 'Injection', 'Other'];
  final _frequencies = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Four times daily',
    'As needed',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.of(context).viewPadding;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16 + padding.bottom),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Medication',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Medication Name',
                        prefixIcon: Icon(Icons.medication_rounded),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter medication name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Dosage',
                        prefixIcon: Icon(Icons.scale_rounded),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter dosage';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedForm,
                      decoration: const InputDecoration(
                        labelText: 'Form',
                        prefixIcon: Icon(Icons.category_rounded),
                      ),
                      items: _forms
                          .map((form) => DropdownMenuItem(
                                value: form,
                                child: Text(form),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedForm = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a form';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedFrequency,
                      decoration: const InputDecoration(
                        labelText: 'Frequency',
                        prefixIcon: Icon(Icons.schedule_rounded),
                      ),
                      items: _frequencies
                          .map((frequency) => DropdownMenuItem(
                                value: frequency,
                                child: Text(frequency),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFrequency = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a frequency';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submitForm,
                        child: const Text('Add Medication'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 0.2, curve: Curves.easeOutQuart);
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement adding medication
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medication added successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
