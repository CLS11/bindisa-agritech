import 'package:equatable/equatable.dart';

/*
  This file defines the immutable data structure for ApprovalFlagItem, which 
  represents individual entries in the approval and flags system, including 
  their type, title, description, agent, location, date, priority, and current 
  status, along with helper enums and methods for status and type parsing.
 */

enum ApprovalStatus {
  pending,
  approved,
  flagged,
  resolved,
  investigate, 
  unknown, 
}

enum ApprovalType {
  farmRegistration,
  profileUpdate,
  dataCorrection,
  suspiciousActivity,
  dataAnomaly,
  paymentIssue,
  unknown,
}

// Helper to parse string to ApprovalStatus
ApprovalStatus approvalStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return ApprovalStatus.pending;
    case 'approved':
      return ApprovalStatus.approved;
    case 'flagged':
      return ApprovalStatus.flagged;
    case 'resolved':
      return ApprovalStatus.resolved;
    case 'investigate':
      return ApprovalStatus.investigate;
    default:
      return ApprovalStatus.unknown;
  }
}

// Helper to parse string to ApprovalType
ApprovalType approvalTypeFromString(String type) {
  switch (type) {
    case 'Farm Registration':
      return ApprovalType.farmRegistration;
    case 'Profile Update':
      return ApprovalType.profileUpdate;
    case 'Data Correction':
      return ApprovalType.dataCorrection;
    case 'Suspicious Activity':
      return ApprovalType.suspiciousActivity;
    case 'Data Anomaly':
      return ApprovalType.dataAnomaly;
    case 'Payment Issue':
      return ApprovalType.paymentIssue;
    default:
      return ApprovalType.unknown;
  }
}

class ApprovalFlagItem extends Equatable {

  const ApprovalFlagItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.agent,
    required this.location,
    required this.date,
    required this.priority,
    required this.status,
  });
  final String id;
  final ApprovalType type;
  final String title;
  final String description;
  final String agent;
  final String location;
  final String date;
  final String priority; // e.g., 'HIGH', 'MEDIUM', 'LOW', 'CRITICAL'
  final ApprovalStatus status;

  ApprovalFlagItem copyWith({
    String? id,
    ApprovalType? type,
    String? title,
    String? description,
    String? agent,
    String? location,
    String? date,
    String? priority,
    ApprovalStatus? status,
  }) {
    return ApprovalFlagItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      agent: agent ?? this.agent,
      location: location ?? this.location,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        id,
        type,
        title,
        description,
        agent,
        location,
        date,
        priority,
        status,
      ];
}
