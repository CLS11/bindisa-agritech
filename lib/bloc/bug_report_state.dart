import 'package:agritech/models/bug_report_model.dart';
import 'package:equatable/equatable.dart';


/*
  The bug_report_state.dart file defines the different states that the bug 
  reporting feature can be in, acting as a snapshot of the UI and data at any 
  given moment for the BLoC pattern.
  It introduces an enum called BugReportStatus to clearly categorize the overall
  status (initial, loading, loaded, submitted, error), and then declares the 
  BugReportState class which bundles all relevant data, including the current 
  BugReport object, its status, any errorMessage, and the currentStep in the 
  multi-step report process. 
  Designed as an immutable class inheriting from Equatable for efficient 
  state comparison, BugReportState also provides a copyWith method, enabling the 
  BugReportBloc to efficiently generate new state instances with updated 
  properties without altering the existing state, thus ensuring predictable UI 
  updates.
 */

enum BugReportStatus { initial, loading, loaded, submitted, error }

class BugReportState extends Equatable { 

  const BugReportState({
    required this.bugReport,
    this.status = BugReportStatus.initial,
    this.errorMessage,
    this.currentStep = 0,
  });
  final BugReport bugReport;
  final BugReportStatus status;
  final String? errorMessage;
  final int currentStep;

  BugReportState copyWith({
    BugReport? bugReport,
    BugReportStatus? status,
    String? errorMessage,
    int? currentStep,
  }) {
    return BugReportState(
      bugReport: bugReport ?? this.bugReport,
      status: status ?? this.status,
      errorMessage: errorMessage,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  @override
  List<Object?> get props => [
        bugReport,
        status,
        errorMessage,
        currentStep,
      ];
}
