// ignore_for_file: deprecated_member_use

import 'package:agritech/bloc/bug_report_bloc.dart';
import 'package:agritech/bloc/bug_report_event.dart';
import 'package:agritech/bloc/bug_report_state.dart';
import 'package:agritech/screens/bug_report_basic_info.dart';
import 'package:agritech/screens/bug_report_contact_information_step.dart';
import 'package:agritech/screens/bug_report_detailed_description_step.dart';
import 'package:agritech/screens/bug_report_environment_attachment_step.dart';
import 'package:agritech/screens/bug_report_submitted_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/*
  The BugReportMainScreen file orchestrates the multi-step bug reporting process, 
  acting as a container and navigator for the different input screens.
  This StatefulWidget utilizes a PageController to manage the seamless, 
  non-swipeable transition between BasicInfoStep, DetailedDescriptionStep, 
  EnvironmentAttachmentsStep, ContactInformationStep, and the final 
  BugReportSubmittedScreen.
  It integrates deeply with the BugReportBloc, dispatching a StartBugReport 
  event on initialization to reset the state and using a BlocConsumer to react 
  to BugReportState changes, specifically navigating to the 
  BugReportSubmittedScreen upon successful submission or displaying error 
  messages. 
  Furthermore, it renders a consistent header across all steps, dynamically 
  showing the current step number and providing a back button to exit the flow, 
  thereby ensuring a cohesive user experience throughout the bug reporting 
  journey.
 */

class BugReportMainScreen extends StatefulWidget {
  const BugReportMainScreen({super.key});

  @override
  State<BugReportMainScreen> createState() => _BugReportMainScreenState();
}

class _BugReportMainScreenState extends State<BugReportMainScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Dispatch StartBugReport when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BugReportBloc>().add(StartBugReport());
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_pageController.page! < 4) { 
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _previousPage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'B U G  R E P O R T', 
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<BugReportBloc, BugReportState>(
        listener: (context, state) {
          if (state.status == BugReportStatus.submitted) {
            // Navigate to the submitted screen or show a success dialog
            _pageController.animateToPage(
              4, // Last page for submission confirmation
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
        builder: (context, state) {
          if (state.status == BugReportStatus.loading && state.currentStep == 4) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.status == BugReportStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          return Column(
            children: [
              _buildBugReportHeader(state.currentStep),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Disable swipe
                  onPageChanged: (index) {
                    // Update the current step in the BLoC if needed, though not strictly necessary
                    // as we're controlling page navigation with buttons
                  },
                  children: [
                    BasicInfoStep(
                      bugReport: state.bugReport,
                      onNext: _nextPage,
                    ),
                    DetailedDescriptionStep(
                      bugReport: state.bugReport,
                      onNext: _nextPage,
                      onPrevious: _previousPage,
                    ),
                    EnvironmentAttachmentsStep(
                      bugReport: state.bugReport,
                      onNext: _nextPage,
                      onPrevious: _previousPage,
                    ),
                    ContactInformationStep(
                      bugReport: state.bugReport,
                      onSubmit: () {
                        context.read<BugReportBloc>().add(
                          SubmitBugReport(state.bugReport),
                        );
                      },
                      onPrevious: _previousPage,
                    ),
                    BugReportSubmittedScreen(
                      submissionId: state.bugReport.submissionId,
                      onNewReport: () {
                        context.read<BugReportBloc>().add(ResetBugReport());
                        _pageController.jumpToPage(0); // Go back to first step
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBugReportHeader(int currentStep) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bug Report',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Help us improve Bindisa Agritech by reporting issues',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Step ${currentStep + 1} of 4', 
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
