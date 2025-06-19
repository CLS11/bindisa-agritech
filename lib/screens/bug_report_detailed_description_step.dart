import 'package:agritech/bloc/bug_report_bloc.dart';
import 'package:agritech/bloc/bug_report_event.dart';
import 'package:agritech/models/bug_report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
  The DetailedDescriptionStep file implements the second screen in the bug 
  reporting process, dedicated to gathering comprehensive details about the 
  encountered issue. 
  This StatefulWidget provides multiple TextFields for the user to input the 
  bug's detailed description, step-by-step instructions to reproduce it, 
  the expected behavior, and the actual observed behavior. 
  It pre-populates these fields with any existing data from the BugReport model 
  and employs TextEditingControllers to manage and react to user input. 
   Changes in these fields trigger UpdateDetailedDescription events to the 
   BugReportBloc, ensuring that the application's state is continuously 
   synchronized. 
   The screen also includes navigation buttons to move between the previous and 
   next steps in the bug report submission flow.
 */

class DetailedDescriptionStep extends StatefulWidget {

  const DetailedDescriptionStep({
    required this.bugReport, 
    required this.onNext, 
    required this.onPrevious, 
    super.key,
  });
  final BugReport bugReport;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  State<DetailedDescriptionStep> createState() => _DetailedDescriptionStepState();
}

class _DetailedDescriptionStepState extends State<DetailedDescriptionStep> {
  late TextEditingController _detailedDescriptionController;
  late TextEditingController _stepsToReproduceController;
  late TextEditingController _expectedBehaviorController;
  late TextEditingController _actualBehaviorController;

  @override
  void initState() {
    super.initState();
    _detailedDescriptionController = TextEditingController(
      text: widget.bugReport.detailedDescription,
    );
    _stepsToReproduceController = TextEditingController(
      text: widget.bugReport.stepsToReproduce,
    );
    _expectedBehaviorController = TextEditingController(
      text: widget.bugReport.expectedBehavior,
    );
    _actualBehaviorController = TextEditingController(
      text: widget.bugReport.actualBehavior,
    );

    _detailedDescriptionController.addListener(_onChanged);
    _stepsToReproduceController.addListener(_onChanged);
    _expectedBehaviorController.addListener(_onChanged);
    _actualBehaviorController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _detailedDescriptionController.removeListener(_onChanged);
    _stepsToReproduceController.removeListener(_onChanged);
    _expectedBehaviorController.removeListener(_onChanged);
    _actualBehaviorController.removeListener(_onChanged);
    _detailedDescriptionController.dispose();
    _stepsToReproduceController.dispose();
    _expectedBehaviorController.dispose();
    _actualBehaviorController.dispose();
    super.dispose();
  }

  void _onChanged() {
    context.read<BugReportBloc>().add(
          UpdateDetailedDescription(
            detailedDescription: _detailedDescriptionController.text,
            stepsToReproduce: _stepsToReproduceController.text,
            expectedBehavior: _expectedBehaviorController.text,
            actualBehavior: _actualBehaviorController.text,
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
          _buildSectionTitle('Detailed Description'),
          _buildTextFieldCard(
            controller: _detailedDescriptionController,
            label: 'Bug Description',
            maxLines: 4,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildTextFieldCard(
            controller: _stepsToReproduceController,
            label: 'Steps to Reproduce',
            maxLines: 4,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildTextFieldCard(
            controller: _expectedBehaviorController,
            label: 'Expected Behavior',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextFieldCard(
            controller: _actualBehaviorController,
            label: 'Actual Behavior',
            maxLines: 3,
          ),
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
                  side: BorderSide(color: Colors.green.shade600),
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
                  // Add validation if needed
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.rectangle_outlined,
          ),
          const SizedBox(
            width: 6,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldCard({
    required TextEditingController controller,
    required String label,
    String? hintText,
    int maxLines = 1,
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
              maxLines: maxLines,
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
}
