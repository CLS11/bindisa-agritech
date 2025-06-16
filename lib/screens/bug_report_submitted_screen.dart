import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
  The BugReportSubmittedScreen file defines the final confirmation screen in the 
  bug reporting flow, displayed after a bug report has been successfully 
  submitted. 
  This StatelessWidget presents a visual confirmation (a checkmark icon) along 
  with a success message and an optional, clickable "Report ID" for the user to 
  copy to their clipboard. 
  It is designed to be a static display, with its primary interaction being a 
  "Submit New Report" button that, when pressed, triggers the onNewReport 
  callback to reset the bug report process and navigate back to the first step, 
  allowing the user to submit another report.
 */

class BugReportSubmittedScreen extends StatelessWidget {

  const BugReportSubmittedScreen({
    required this.onNewReport, super.key,
    this.submissionId,
  });
  final String? submissionId;
  final VoidCallback onNewReport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline, 
                    color: Colors.green.shade600, 
                    size: 50,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bug Report Submitted!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Thank you for reporting a bug. We'll get back to you soon.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (submissionId != null)
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: submissionId!
                          ),
                        ).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Copied to clipboard!',
                            ),
                          ),
                        );
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, 
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.copy, 
                            color: Colors.green.shade700, 
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Report ID: $submissionId',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNewReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Submit New Report',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
