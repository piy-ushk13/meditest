import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Medication {
  final String name;
  final String description;
  final String dosage;
  final String form;
  final String? route;
  final String frequency;
  final String duration;
  final String? timing;
  final List<String> sideEffects;
  final List<String> precautions;
  final String activeIngredient;
  final String manufacturer;
  final bool prescriptionRequired;

  const Medication({
    required this.name,
    required this.description,
    required this.dosage,
    required this.form,
    this.route,
    required this.frequency,
    required this.duration,
    this.timing,
    required this.sideEffects,
    required this.precautions,
    required this.activeIngredient,
    required this.manufacturer,
    required this.prescriptionRequired,
  });
}

class MedicationDetailsScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailsScreen({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, theme),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(theme),
                  const SizedBox(height: 24),
                  _buildDosageSection(theme),
                  const SizedBox(height: 24),
                  _buildScheduleSection(theme),
                  const SizedBox(height: 24),
                  _buildSideEffectsSection(theme),
                  const SizedBox(height: 24),
                  _buildPrecautionsSection(theme),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showReminderDialog(context),
        icon: const Icon(Icons.alarm_add_rounded),
        label: const Text('Set Reminder'),
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar.medium(
      expandedHeight: 200,
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
          child: Stack(
            children: [
              Positioned(
                right: -50,
                bottom: -50,
                child: Icon(
                  Icons.medication_rounded,
                  size: 200,
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          medication.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline_rounded),
          onPressed: () => _showInfoDialog(context),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
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
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                  const SizedBox(height: 4),
                  Text(
                    medication.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDosageSection(ThemeData theme) {
    return _buildSection(
      theme,
      'Dosage Information',
      Icons.medical_information_rounded,
      [
        _buildInfoRow(
          theme,
          'Strength:',
          medication.dosage,
          Icons.medication_liquid_rounded,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          theme,
          'Form:',
          medication.form,
          Icons.medication_rounded,
        ),
        if (medication.route != null) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            theme,
            'Route:',
            medication.route!,
            Icons.route_rounded,
          ),
        ],
      ],
    );
  }

  Widget _buildScheduleSection(ThemeData theme) {
    return _buildSection(
      theme,
      'Schedule',
      Icons.schedule_rounded,
      [
        _buildInfoRow(
          theme,
          'Frequency:',
          medication.frequency,
          Icons.repeat_rounded,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          theme,
          'Duration:',
          medication.duration,
          Icons.calendar_today_rounded,
        ),
        if (medication.timing != null) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            theme,
            'Best taken:',
            medication.timing!,
            Icons.access_time_rounded,
          ),
        ],
      ],
    );
  }

  Widget _buildSideEffectsSection(ThemeData theme) {
    return _buildSection(
      theme,
      'Possible Side Effects',
      Icons.warning_rounded,
      [
        ...medication.sideEffects.map((effect) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      effect,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildPrecautionsSection(ThemeData theme) {
    return _buildSection(
      theme,
      'Precautions',
      Icons.shield_rounded,
      [
        ...medication.precautions.map((precaution) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      precaution,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildSection(
    ThemeData theme,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  void _showReminderDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ReminderSheet(medication: medication),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Medication Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Active Ingredient: ${medication.activeIngredient}'),
              const SizedBox(height: 8),
              Text('Manufacturer: ${medication.manufacturer}'),
              if (medication.prescriptionRequired) ...[
                const SizedBox(height: 8),
                const Text(
                  'This medication requires a prescription',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ReminderSheet extends StatefulWidget {
  final Medication medication;

  const _ReminderSheet({
    required this.medication,
  });

  @override
  State<_ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends State<_ReminderSheet> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final List<bool> _selectedDays = List.generate(7, (_) => false);

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
            child: Column(
              children: [
                Text(
                  'Set Reminder',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTimePicker(theme),
                const SizedBox(height: 24),
                _buildDaySelector(theme),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // TODO: Implement reminder setting
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reminder set successfully!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text('Set Reminder'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2, curve: Curves.easeOutQuart);
  }

  Widget _buildTimePicker(ThemeData theme) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
        );
        if (time != null) {
          setState(() {
            _selectedTime = time;
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Text(
              'Reminder Time',
              style: theme.textTheme.titleMedium,
            ),
            const Spacer(),
            Text(
              _selectedTime.format(context),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector(ThemeData theme) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        return InkWell(
          onTap: () {
            setState(() {
              _selectedDays[index] = !_selectedDays[index];
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _selectedDays[index]
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedDays[index]
                    ? Colors.transparent
                    : theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Center(
              child: Text(
                days[index],
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _selectedDays[index]
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  fontWeight: _selectedDays[index]
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
