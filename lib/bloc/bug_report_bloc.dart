import 'package:agritech/bloc/bug_report_event.dart';
import 'package:agritech/bloc/bug_report_state.dart';
import 'package:agritech/models/bug_report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

/*
  The BugReportBloc file is the central business logic component for the bug 
  reporting feature, responsible for managing the state of a bug report as a user
  progresses through different steps.
  It extends Bloc from the flutter_bloc package, listening for various 
  BugReportEvents dispatched by the UI, such as updates to basic information, 
  detailed descriptions, environment details, or contact info, and reacting to a 
  SubmitBugReport event by simulating an asynchronous submission process before 
  emitting new BugReportStates to reflect the current data and status (e.g., 
  loading, loaded, submitted, or error). 
  Essentially, it acts as the brain of the bug report flow, ensuring data 
  consistency and handling all interactions and transitions related to submitting
   a bug.

 */

class BugReportBloc extends Bloc<BugReportEvent, BugReportState> {
  BugReportBloc() : super(const BugReportState(bugReport: BugReport())) {
    on<StartBugReport>(_onStartBugReport);
    on<UpdateBasicInfo>(_onUpdateBasicInfo);
    on<UpdateDetailedDescription>(_onUpdateDetailedDescription);
    on<UpdateEnvironmentAttachments>(_onUpdateEnvironmentAttachments);
    on<UpdateContactInfo>(_onUpdateContactInfo);
    on<SubmitBugReport>(_onSubmitBugReport);
    on<ResetBugReport>(_onResetBugReport);
    on<UpdateBugReportStep>((event, emit) {
      emit(state.copyWith(currentStep: event.stepIndex));
    });
  }

  void _onStartBugReport(StartBugReport event, Emitter<BugReportState> emit) {
    emit(state.copyWith(
      bugReport: const BugReport(), 
      status: BugReportStatus.loaded,
      currentStep: 0,
    ));
  }

  void _onUpdateBasicInfo(UpdateBasicInfo event, Emitter<BugReportState> emit) {
    final updatedBugReport = state.bugReport.copyWith(
      bugTitle: event.bugTitle,
      sprintToLoan: event.sprintToLoan,
      category: event.category,
    );
    emit(state.copyWith(bugReport: updatedBugReport));
  }

  void _onUpdateDetailedDescription(
    UpdateDetailedDescription event, 
    Emitter<BugReportState> emit
    ) {
    final updatedBugReport = state.bugReport.copyWith(
      detailedDescription: event.detailedDescription,
      stepsToReproduce: event.stepsToReproduce,
      expectedBehavior: event.expectedBehavior,
      actualBehavior: event.actualBehavior,
    );
    emit(
      state.copyWith(
        bugReport: updatedBugReport,
      ),
    );
  }

  void _onUpdateEnvironmentAttachments(
    UpdateEnvironmentAttachments event, 
    Emitter<BugReportState> emit,
    ) {
    final updatedBugReport = state.bugReport.copyWith(
      deviceType: event.deviceType,
      operatingSystem: event.operatingSystem,
      appVersion: event.appVersion,
      attachments: List.from(event.attachments),
    );
    emit(
      state.copyWith(
        bugReport: updatedBugReport,
      ),
    );
  }

  void _onUpdateContactInfo(
    UpdateContactInfo event, 
    Emitter<BugReportState> emit,
  ) {
    final updatedBugReport = state.bugReport.copyWith(
      fullName: event.fullName,
      emailAddress: event.emailAddress,
      phoneNumber: event.phoneNumber,
    );
    emit(
      state.copyWith(
        bugReport: updatedBugReport,
      ),
    );
  }

  Future<void> _onSubmitBugReport(
    SubmitBugReport event, 
    Emitter<BugReportState> emit,
    ) async {
    emit(state.copyWith(status: BugReportStatus.loading));
    try {
      await Future.delayed(
        const Duration(
          seconds: 2,
        ),
      );
      const uuid = Uuid();
      final submissionId = uuid.v4(); // Generate a unique ID for the report

      final submittedBugReport = event.bugReport.copyWith(
        submissionId: submissionId
      );

      emit(state.copyWith(
        bugReport: submittedBugReport,
        status: BugReportStatus.submitted,
        currentStep: 4, 
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BugReportStatus.error,
        errorMessage: 'Failed to submit bug report: $e',
      ));
    }
  }

  void _onResetBugReport(
    ResetBugReport event, 
    Emitter<BugReportState> emit,
    ) {
    emit(
      const BugReportState(
        bugReport: BugReport(),
      ),
    ); // Reset to initial state
  }
}
