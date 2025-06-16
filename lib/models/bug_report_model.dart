import 'package:equatable/equatable.dart';


/* This class acts as a template for creating objects that represent individual 
bug reports. 
The BugReport class extends Equatable. 
This is a package that helps simplify value equality comparisons in Dart. 
Without Equatable, comparing two BugReport objects with the same content 
(e.g., same title, same description) would often return false because Dart's 
default == operator compares memory addresses. 
By extending Equatable and implementing props, you can compare two BugReport 
objects based on their content rather than their identity in memory.
final keyword means that once a BugReport object is created, the values of these 
fields cannot be changed directly. 
This promotes immutability, which is a good practice for state management in apps.
The ? after String (e.g., String? bugTitle) indicates that these fields are 
nullable, meaning they can hold a String value or be null. 
This is useful for fields that are optional or might not be available at every 
stage of the bug reporting process.

Central definition for all data related to a bug report, 
ensuring that the data is structured, type-safe, and handled immutably throughout 
your application, especially within the BLoC state management system.

 */

class BugReport extends Equatable { 
  const BugReport({
    this.bugTitle,
    this.sprintToLoan,
    this.category,
    this.detailedDescription,
    this.stepsToReproduce,
    this.expectedBehavior,
    this.actualBehavior,
    this.deviceType,
    this.operatingSystem,
    this.appVersion,
    this.attachments = const [],
    this.fullName,
    this.emailAddress,
    this.phoneNumber,
    this.submissionId,
  });
  final String? bugTitle;
  final String? sprintToLoan;
  final String? category;
  final String? detailedDescription;
  final String? stepsToReproduce;
  final String? expectedBehavior;
  final String? actualBehavior;
  final String? deviceType;
  final String? operatingSystem;
  final String? appVersion;
  final List<String> attachments; 
  final String? fullName;
  final String? emailAddress;
  final String? phoneNumber;
  final String? submissionId;
 /*
 The copyWith method allows you to create a new BugReport object that is a copy 
 of the current one, but with some (or no) fields modified.
 */ 
  BugReport copyWith({
    String? bugTitle,
    String? sprintToLoan,
    String? category,
    String? detailedDescription,
    String? stepsToReproduce,
    String? expectedBehavior,
    String? actualBehavior,
    String? deviceType,
    String? operatingSystem,
    String? appVersion,
    List<String>? attachments,
    String? fullName,
    String? emailAddress,
    String? phoneNumber,
    String? submissionId,
  }) {
    return BugReport(
      bugTitle: bugTitle ?? this.bugTitle,
      sprintToLoan: sprintToLoan ?? this.sprintToLoan,
      category: category ?? this.category,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      stepsToReproduce: stepsToReproduce ?? this.stepsToReproduce,
      expectedBehavior: expectedBehavior ?? this.expectedBehavior,
      actualBehavior: actualBehavior ?? this.actualBehavior,
      deviceType: deviceType ?? this.deviceType,
      operatingSystem: operatingSystem ?? this.operatingSystem,
      appVersion: appVersion ?? this.appVersion,
      attachments: attachments ?? this.attachments,
      fullName: fullName ?? this.fullName,
      emailAddress: emailAddress ?? this.emailAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      submissionId: submissionId ?? this.submissionId,
    );
  }

  @override
  List<Object?> get props => [
        bugTitle,
        sprintToLoan,
        category,
        detailedDescription,
        stepsToReproduce,
        expectedBehavior,
        actualBehavior,
        deviceType,
        operatingSystem,
        appVersion,
        attachments,
        fullName,
        emailAddress,
        phoneNumber,
        submissionId,
      ];
}

