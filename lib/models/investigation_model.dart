import 'package:equatable/equatable.dart';

/* This file defines the data structures for an investigation, including 
  InvestigationItem (the main object holding all details of a flag investigation)
  , TimelineEntry (for individual events in the investigation timeline), and 
  EvidenceFile (for documents or media related to the evidence), along with 
  helper enums for status and priority, ensuring structured data for BLoC state 
  management.
 */

enum InvestigationStatus {
  pendingReview,
  escalated,
  resolved,
}

enum InvestigationPriority {
  critical,
  high,
  medium,
  low,
}

class TimelineEntry extends Equatable { 

  const TimelineEntry({required this.description, required this.time});
  final String description;
  final String time;

  @override
  List<Object> get props => [description, time];
}

class EvidenceFile extends Equatable {

  const EvidenceFile({
    required this.name, 
    required this.size, 
    required this.type,
  });
  final String name;
  final String size; 
  final String type;

  @override
  List<Object> get props => [name, size, type];
}

class InvestigationItem extends Equatable {

  const InvestigationItem({
    required this.id,
    required this.flagType,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.status,
    required this.priority,
    required this.assignedTo,
    this.relatedUsers = const [],
    this.timeline = const [],
    this.ipLogs = const [],
    this.deviceInfo = const [],
    this.locationData = const [],
    this.evidenceFiles = const [],
  });
  final String id;
  final String flagType; // e.g., "SUSPICIOUS ACTIVITY"
  final String title; // e.g., "Unknown User"
  final String location; // e.g., "Multiple Locations"
  final String date; // e.g., "2024-07-15"
  final String time; // e.g., "14:32 IST"
  final String description;
  final InvestigationStatus status;
  final InvestigationPriority priority;
  final String assignedTo; // e.g., "Security Team"
  final List<String> relatedUsers; // e.g., ["Farmer - Last seen: 2024-07-15 13:45", "Priya Sharma - Last seen: 2024-07-16 12:00"]
  final List<TimelineEntry> timeline;
  final List<String> ipLogs; // List of IP log entries
  final List<String> deviceInfo; // List of device info entries
  final List<String> locationData; // List of location data entries
  final List<EvidenceFile> evidenceFiles;

  InvestigationItem copyWith({
    String? id,
    String? flagType,
    String? title,
    String? location,
    String? date,
    String? time,
    String? description,
    InvestigationStatus? status,
    InvestigationPriority? priority,
    String? assignedTo,
    List<String>? relatedUsers,
    List<TimelineEntry>? timeline,
    List<String>? ipLogs,
    List<String>? deviceInfo,
    List<String>? locationData,
    List<EvidenceFile>? evidenceFiles,
  }) {
    return InvestigationItem(
      id: id ?? this.id,
      flagType: flagType ?? this.flagType,
      title: title ?? this.title,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      relatedUsers: relatedUsers ?? this.relatedUsers,
      timeline: timeline ?? this.timeline,
      ipLogs: ipLogs ?? this.ipLogs,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      locationData: locationData ?? this.locationData,
      evidenceFiles: evidenceFiles ?? this.evidenceFiles,
    );
  }

  @override
  List<Object> get props => [
        id,
        flagType,
        title,
        location,
        date,
        time,
        description,
        status,
        priority,
        assignedTo,
        relatedUsers,
        timeline,
        ipLogs,
        deviceInfo,
        locationData,
        evidenceFiles,
      ];
}
