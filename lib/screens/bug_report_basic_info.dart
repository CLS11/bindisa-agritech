import 'package:agritech/bloc/bug_report_bloc.dart';
import 'package:agritech/bloc/bug_report_event.dart';
import 'package:agritech/models/bug_report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
  The BasicInfoStep file defines the first screen of the bug report flow, 
  focusing on collecting fundamental information about the issue from the user.
  This StatefulWidget renders input fields for the bug title, a "sprint to LOAN" 
  reference, and a category selection using a DropdownButtonFormField.
  It initializes these fields with existing data from the BugReport model, if 
  available, and uses TextEditingControllers to manage user input. 
  Crucially, it integrates with the BugReportBloc by dispatching UpdateBasicInfo 
  events whenever the user modifies an input field, ensuring that the latest 
  data is reflected in the application's state.
  The screen also includes informative "Reporting Tips" and "Bug Status" sections, 
  along with navigation controls to proceed to the next step of the bug reporting 
  process.
 */


class BasicInfoStep extends StatefulWidget {

  const BasicInfoStep({
    required this.bugReport, 
    required this.onNext, super.key,
  });
  final BugReport bugReport;
  final VoidCallback onNext;

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  late TextEditingController _bugTitleController;
  late TextEditingController _sprintToLoanController;
  String? _selectedCategory;

  final List<String> _categories = [
    'General', 
    'UI/UX', 
    'Performance', 
    'Crashing', 
    'Data Issue', 
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _bugTitleController = TextEditingController(
      text: widget.bugReport.bugTitle
      );
    _sprintToLoanController = TextEditingController(
      text: widget.bugReport.sprintToLoan
    );
    _selectedCategory = widget.bugReport.category;

    _bugTitleController.addListener(_onChanged);
    _sprintToLoanController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _bugTitleController.removeListener(_onChanged);
    _sprintToLoanController.removeListener(_onChanged);
    _bugTitleController.dispose();
    _sprintToLoanController.dispose();
    super.dispose();
  }

  void _onChanged() {
    context.read<BugReportBloc>().add(
          UpdateBasicInfo(
            bugTitle: _bugTitleController.text,
            sprintToLoan: _sprintToLoanController.text,
            category: _selectedCategory,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            'Basic Information',
          ),
          _buildTextFieldCard(
            controller: _bugTitleController,
            label: 'Bug Title',
            hintText: 'Add a brief description of the issue',
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildTextFieldCard(
            controller: _sprintToLoanController,
            label: 'Sprint to LOAN*',
            hintText: 'e.g., 2024-Q3-Sprint 2',
          ),
          const SizedBox(height: 16),
          _buildDropdownCard(
            label: 'Category',
            value: _selectedCategory,
            items: _categories,
            hintText: 'Select category',
            onChanged: (newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
              _onChanged(); // Trigger BLoC update
            },
          ),
          const SizedBox(height: 24),
          _buildReportingTips(),
          const SizedBox(height: 24),
          _buildBugStatus(),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                // You might add validation here before moving to the next step
                widget.onNext();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40, 
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Next', 
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextFieldCard({
    required TextEditingController controller,
    required String label,
    String? hintText,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16, 
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isRequired ? '$label*' : label,
              style: const TextStyle(
                fontSize: 12, 
                color: Colors.grey,
              ),
            ),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(
                fontSize: 16, 
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownCard({
    required String label,
    required List<String> items, 
    required ValueChanged<String?> onChanged, 
    String? value,
    String? hintText,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16, 
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label*',
              style: const TextStyle(
                fontSize: 12, 
                color: Colors.grey,
              ),
            ),
            DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down, 
                color: Colors.grey,
              ),
              style: const TextStyle(
                fontSize: 16, 
                color: Colors.black87,
              ),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportingTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline, 
                color: Colors.blue.shade700, 
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Reporting Tips',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTipPoint(
            'Be specific and describe steps to reproduce.',
          ),
          _buildTipPoint(
            'Choose the most appropriate severity level.',
          ),
          _buildTipPoint(
            'Attach files if the bug is visual.',
          ),
          _buildTipPoint(
            'Include crash logs or error messages.',
          ),
        ],
      ),
    );
  }

  Widget _buildTipPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4, 
        bottom: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 4,
            width: 4,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13, 
                color: Colors.blue.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBugStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline, 
            color: Colors.grey.shade600, 
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bug Status',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'All updates on your report are viewed by a team 2-3 hours',
                  style: TextStyle(
                    fontSize: 13, 
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
