import 'package:agritech/models/bug_report_model.dart';
import 'package:equatable/equatable.dart';

/*
  The bug_report_event.dart file is fundamental to the BLoC state management 
  pattern, serving as a comprehensive collection of all possible "actions" or 
  "triggers" that can occur within the bug reporting feature.
  It defines an abstract base class, BugReportEvent, from which all specific 
  events inherit, ensuring consistent behavior like value equality through the 
  Equatable package. 
  Individual event classes, such as StartBugReport, UpdateBasicInfo, 
  UpdateDetailedDescription, UpdateEnvironmentAttachments, UpdateContactInfo, 
  SubmitBugReport, and ResetBugReport, encapsulate user interactions or 
  system-driven changes, each carrying the specific data relevant to that 
  particular event. 
  For instance, UpdateBasicInfo holds the bug title or category, while 
  SubmitBugReport carries the entire BugReport object, effectively acting as 
  messages dispatched from the UI to the BugReportBloc to signal a change in 
  state or trigger a business logic operation.
 */


abstract class BugReportEvent extends Equatable {
  const BugReportEvent();

  @override
  List<Object> get props => [];
}

class StartBugReport extends BugReportEvent {}

class UpdateBasicInfo extends BugReportEvent {

  const UpdateBasicInfo({this.bugTitle, this.sprintToLoan, this.category});
  final String? bugTitle;
  final String? sprintToLoan;
  final String? category;

  @override
  List<Object> get props => [bugTitle!, sprintToLoan!, category!];
}

class UpdateDetailedDescription extends BugReportEvent {

  const UpdateDetailedDescription({
    this.detailedDescription,
    this.stepsToReproduce,
    this.expectedBehavior,
    this.actualBehavior,
  });
  final String? detailedDescription;
  final String? stepsToReproduce;
  final String? expectedBehavior;
  final String? actualBehavior;

  @override
  List<Object> get props => [
        detailedDescription!,
        stepsToReproduce!,
        expectedBehavior!,
        actualBehavior!,
      ];
}

class UpdateEnvironmentAttachments extends BugReportEvent { 
 

  const UpdateEnvironmentAttachments({
    this.deviceType,
    this.operatingSystem,
    this.appVersion,
    this.attachments = const [],
  });
  final String? deviceType;
  final String? operatingSystem;
  final String? appVersion;
  final List<String> attachments;

  @override
  List<Object> get props => [
        deviceType!,
        operatingSystem!,
        appVersion!,
        attachments,
      ];
}

class UpdateContactInfo extends BugReportEvent {

  const UpdateContactInfo({this.fullName, this.emailAddress, this.phoneNumber});
  final String? fullName;
  final String? emailAddress;
  final String? phoneNumber;

  @override
  List<Object> get props => [fullName!, emailAddress!, phoneNumber!];
}

class SubmitBugReport extends BugReportEvent {

  const SubmitBugReport(this.bugReport);
  final BugReport bugReport;

  @override
  List<Object> get props => [bugReport];
}

class ResetBugReport extends BugReportEvent {}
