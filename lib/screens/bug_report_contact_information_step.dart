import 'package:agritech/bloc/bug_report_bloc.dart';
import 'package:agritech/bloc/bug_report_event.dart';
import 'package:agritech/models/bug_report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
  The ContactInformationStep file defines the final input screen in the bug 
  report flow, where users provide their contact details before submission.
  This StatefulWidget collects the user's full name, email address, and phone 
  number using TextEditingControllers, initializing them with any existing data 
  from the BugReport model. Similar to other steps, it integrates with the 
  BugReportBloc by dispatching UpdateContactInfo events as users type, keeping 
  the bug report data up-to-date.
  The screen also features informational sections like "What Happens Next?" and 
  a "Privacy Notice," and includes navigation buttons for returning to the 
  previous step or triggering the onSubmit callback to finalize the bug report 
  submission process.
  Before submitting, it includes basic validation to ensure required fields are 
  not empty.
 */

class ContactInformationStep extends StatefulWidget {

  const ContactInformationStep({
    required this.bugReport, 
    required this.onSubmit, 
    required this.onPrevious, 
    super.key,
  });
  final BugReport bugReport;
  final VoidCallback onSubmit;
  final VoidCallback onPrevious;

  @override
  State<ContactInformationStep> createState() => _ContactInformationStepState();
}

class _ContactInformationStepState extends State<ContactInformationStep> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailAddressController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.bugReport.fullName,
    );
    _emailAddressController = TextEditingController(
      text: widget.bugReport.emailAddress,
    );
    _phoneNumberController = TextEditingController(
      text: widget.bugReport.phoneNumber,
    );

    _fullNameController.addListener(_onChanged);
    _emailAddressController.addListener(_onChanged);
    _phoneNumberController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _fullNameController.removeListener(_onChanged);
    _emailAddressController.removeListener(_onChanged);
    _phoneNumberController.removeListener(_onChanged);
    _fullNameController.dispose();
    _emailAddressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _onChanged() {
    context.read<BugReportBloc>().add(
          UpdateContactInfo(
            fullName: _fullNameController.text,
            emailAddress: _emailAddressController.text,
            phoneNumber: _phoneNumberController.text,
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
          _buildSectionTitle('Contact Information'),
          _buildTextFieldCard(
            controller: _fullNameController,
            label: 'Full Name',
            hintText: 'Your full name',
          ),
          const SizedBox(height: 16),
          _buildTextFieldCard(
            controller: _emailAddressController,
            label: 'Email Address*',
            hintText: 'john.doe@agritech.com',
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildTextFieldCard(
            controller: _phoneNumberController,
            label: 'Phone Number*',
            hintText: '+91 98123 45678',
            keyboardType: TextInputType.phone,
            isRequired: true,
          ),
          const SizedBox(height: 24),
          _buildWhatHappensNext(),
          const SizedBox(height: 24),
          _buildPrivacyNotice(),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: widget.onPrevious,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40, 
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(
                    color: Colors.green.shade600,
                  ),
                ),
                child: Text(
                  'Previous', 
                  style: TextStyle(
                    color: Colors.green.shade600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add validation for required fields
                  if (_emailAddressController.text.isEmpty || 
                  _phoneNumberController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill in all required fields.',
                        ),
                      ),
                    );
                    return;
                  }
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24, 
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit Report', 
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
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

  Widget _buildWhatHappensNext() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline, 
                color: Colors.yellow.shade800, 
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'What Happens Next?',
                style: TextStyle(
                  color: Colors.yellow.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTipPoint('You receive a confirmation email within 2-4 hours'),
          _buildTipPoint('Our team will review within 24 hours'),
          _buildTipPoint("We'll contact you for more info"),
          _buildTipPoint("You'll get notified once it is resolved"),
        ],
      ),
    );
  }

  Widget _buildTipPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 4,
            width: 4,
            decoration: BoxDecoration(
              color: Colors.yellow.shade800,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13, 
                color: Colors.yellow.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.security, 
            color: Colors.green.shade700, 
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Notice',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your information is secure and will only be used to help us resolve the issue.',
                  style: TextStyle(
                    fontSize: 13, 
                    color: Colors.green.shade800,
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
