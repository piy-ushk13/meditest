import 'package:flutter/material.dart';

// Placeholder for medication data - replace with your actual data model
class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final List<String> sideEffects;
  final List<DateTime> history;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.sideEffects,
    required this.history,
  });
}

class MedicationDetailsScreen extends StatefulWidget {
  final Medication medication;

  const MedicationDetailsScreen({super.key, required this.medication});

  @override
  _MedicationDetailsScreenState createState() => _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use Theme colors for consistency - Adjust if your theme setup differs
    final Color primaryColor = Theme.of(context).primaryColor; // Or specific color from your theme
    final Color accentColor = Theme.of(context).colorScheme.secondary; // Or specific color
    final Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final Color subtleTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey.shade600;
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color cardBackgroundColor = Theme.of(context).cardColor; // Usually white/light grey in light themes

    // Assuming a light theme based on the image
    final Color iconColor = primaryColor; // Match icon color from image

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.medication.name, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor, // Match background
        elevation: 0, // Flat design like the image
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor, // Active tab color
          unselectedLabelColor: subtleTextColor, // Inactive tab color
          indicatorColor: primaryColor, // Underline color
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailsTab(context, iconColor, textColor, subtleTextColor, cardBackgroundColor),
          _buildHistoryTab(context, iconColor, textColor, subtleTextColor, cardBackgroundColor),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(BuildContext context, Color iconColor, Color textColor, Color subtleTextColor, Color cardBackgroundColor) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildDetailCard(
          context: context,
          icon: Icons.medical_services_outlined, // Example icon
          title: 'Dosage',
          content: widget.medication.dosage,
          iconColor: iconColor,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
          cardBackgroundColor: cardBackgroundColor,
        ),
        const SizedBox(height: 16),
        _buildDetailCard(
          context: context,
          icon: Icons.schedule_outlined, // Example icon
          title: 'Frequency',
          content: widget.medication.frequency,
          iconColor: iconColor,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
          cardBackgroundColor: cardBackgroundColor,
        ),
        const SizedBox(height: 16),
        _buildDetailCard(
          context: context,
          icon: Icons.warning_amber_outlined, // Example icon
          title: 'Possible Side Effects',
          content: widget.medication.sideEffects.join('\n'), // Display as list
          iconColor: iconColor,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
          cardBackgroundColor: cardBackgroundColor,
        ),
      ],
    );
  }

   Widget _buildDetailCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    required Color iconColor,
    required Color textColor,
    required Color subtleTextColor,
    required Color cardBackgroundColor,
  }) {
    return Card(
      elevation: 1.0, // Subtle shadow like the image cards
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Rounded corners
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: subtleTextColor,
                      height: 1.4, // Improve readability
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(BuildContext context, Color iconColor, Color textColor, Color subtleTextColor, Color cardBackgroundColor) {
    if (widget.medication.history.isEmpty) {
      return Center(
        child: Text(
          'No history recorded yet.',
          style: TextStyle(color: subtleTextColor),
        ),
      );
    }

    // Sort history, newest first
    final sortedHistory = List<DateTime>.from(widget.medication.history)
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemCount: sortedHistory.length,
      itemBuilder: (context, index) {
        final dateTime = sortedHistory[index];
        // TODO: Replace with actual date/time formatting logic
        final formattedDate = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
        final formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

        return HistoryLogItem(
          date: formattedDate,
          time: formattedTime,
          iconColor: iconColor,
          textColor: textColor,
          subtleTextColor: subtleTextColor,
          cardBackgroundColor: cardBackgroundColor,
        );
      },
    );
  }
}

// Separate widget for history item to handle micro-interaction state
class HistoryLogItem extends StatefulWidget {
  final String date;
  final String time;
  final Color iconColor;
  final Color textColor;
  final Color subtleTextColor;
  final Color cardBackgroundColor;

  const HistoryLogItem({
    super.key,
    required this.date,
    required this.time,
    required this.iconColor,
    required this.textColor,
    required this.subtleTextColor,
    required this.cardBackgroundColor,
  });

  @override
  _HistoryLogItemState createState() => _HistoryLogItemState();
}

class _HistoryLogItemState extends State<HistoryLogItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    Future.delayed(const Duration(milliseconds: 100), () {
       if (mounted) {
         _controller.reverse();
       }
    });
    // Add any action on tap here, e.g., show details
    print("History item tapped: ${widget.date} ${widget.time}");
  }

   void _handleTapCancel() {
     if (mounted) {
       _controller.reverse();
     }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 0.5, // Very subtle elevation
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          color: widget.cardBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: ListTile(
            leading: Icon(Icons.check_circle_outline, color: widget.iconColor, size: 22),
            title: Text(
              widget.date,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: widget.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              widget.time,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: widget.subtleTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}