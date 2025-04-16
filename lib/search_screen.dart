import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/error_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _medicineInfo;

  Future<void> _searchMedicine(String name) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _medicineInfo = null;
    });
    try {
      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyAEhIaX4EHvfR3iA-WS2HIqdohs3EjI9ns'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      '''You are a medical information assistant. Please provide detailed information about the medicine: $name.
                  
Respond ONLY in this exact JSON format:
{
  "name": "Medicine Name",
  "description": "A brief description of what this medicine is and what it does",
  "category": "Type/category of medicine (e.g., Antibiotic, Painkiller, etc.)",
  "uses": [
    "Primary use 1",
    "Primary use 2"
  ],
  "sideEffects": [
    "Common side effect 1",
    "Common side effect 2"
  ],
  "dosage": {
    "adults": "Typical adult dosage",
    "children": "Typical children dosage (if applicable)",
    "frequency": "How often to take"
  },
  "warnings": [
    "Important warning 1",
    "Important warning 2"
  ],
  "contraindications": [
    "Should not be taken with condition 1",
    "Should not be taken with condition 2"
  ],
  "storage": "How to store the medicine",
  "interactions": [
    "Interaction with other medicine/substance 1",
    "Interaction with other medicine/substance 2"
  ]
}'''
                }
              ]
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

        // Extract JSON from the response text
        final jsonStart = text.indexOf('{');
        final jsonEnd = text.lastIndexOf('}') + 1;
        if (jsonStart >= 0 && jsonEnd > jsonStart) {
          final jsonStr = text.substring(jsonStart, jsonEnd);
          try {
            final info = jsonDecode(jsonStr);
            setState(() {
              _medicineInfo = info;
              _isLoading = false;
            });
          } catch (e) {
            setState(() {
              _error = 'Failed to parse medicine information.';
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _error = 'Invalid response format.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to fetch medicine info.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Search Medicines',
        showBackButton: false,
      ),
      body: Column(
        children: [
          _buildSearchHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter medicine name',
                prefixIcon: const Icon(Icons.search,
                    color: AppTheme.textSecondaryColor),
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _searchMedicine(value.trim());
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                final value = _searchController.text.trim();
                if (value.isNotEmpty) {
                  _searchMedicine(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingIndicator(message: 'Searching...');
    }
    if (_error != null) {
      return ErrorView(
        message: _error!,
        actionLabel: 'Retry',
        onActionPressed: () {
          final value = _searchController.text.trim();
          if (value.isNotEmpty) {
            _searchMedicine(value);
          }
        },
      );
    }
    if (_medicineInfo != null) {
      return _buildMedicineInfo(_medicineInfo!);
    }
    return Center(
      child: Text(
        'Search for a medicine to see details.',
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildMedicineInfo(Map<String, dynamic> info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Medicine Information',
            [
              _buildTitleValue('Name', info['name'] ?? 'Unknown Medicine'),
              if (info['category'] != null)
                _buildTitleValue('Category', info['category']),
              if (info['description'] != null)
                _buildTitleValue('Description', info['description']),
            ],
            icon: Icons.medication,
          ),
          const SizedBox(height: 16),
          if (info['uses'] != null)
            _buildInfoCard(
              'Uses',
              [_buildBulletPoints(info['uses'] as List<dynamic>)],
              icon: Icons.check_circle_outline,
            ),
          if (info['dosage'] != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Dosage Instructions',
              [
                if (info['dosage']['adults'] != null)
                  _buildTitleValue('Adults', info['dosage']['adults']),
                if (info['dosage']['children'] != null)
                  _buildTitleValue('Children', info['dosage']['children']),
                if (info['dosage']['frequency'] != null)
                  _buildTitleValue('Frequency', info['dosage']['frequency']),
              ],
              icon: Icons.schedule,
            ),
          ],
          if (info['sideEffects'] != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Side Effects',
              [_buildBulletPoints(info['sideEffects'] as List<dynamic>)],
              icon: Icons.warning_amber_rounded,
              isWarning: true,
            ),
          ],
          if (info['warnings'] != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Important Warnings',
              [_buildBulletPoints(info['warnings'] as List<dynamic>)],
              icon: Icons.error_outline,
              isWarning: true,
            ),
          ],
          if (info['contraindications'] != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Contraindications',
              [_buildBulletPoints(info['contraindications'] as List<dynamic>)],
              icon: Icons.do_not_disturb_alt,
              isWarning: true,
            ),
          ],
          if (info['interactions'] != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Drug Interactions',
              [_buildBulletPoints(info['interactions'] as List<dynamic>)],
              icon: Icons.sync_problem,
              isWarning: true,
            ),
          ],
          if (info['storage'] != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Storage Instructions',
              [_buildTitleValue('Storage', info['storage'])],
              icon: Icons.inventory_2_outlined,
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              'Disclaimer: This information is for educational purposes only. Always consult your healthcare provider before taking or changing any medication.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> content,
      {IconData? icon, bool isWarning = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isWarning
              ? Colors.orange.withOpacity(0.5)
              : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: isWarning ? Colors.orange : AppTheme.primaryColor,
                    size: 24,
                  ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isWarning ? Colors.orange[700] : Colors.black87,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildTitleValue(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoints(List<dynamic> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  point.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
