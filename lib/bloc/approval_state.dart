import 'package:agritech/models/approval_flag_model.dart';
import 'package:equatable/equatable.dart';

enum ApprovalListStatus { initial, loading, loaded, error }

class ApprovalState extends Equatable {
  const ApprovalState({
    this.allItems = const [],
    this.filteredItems = const [],
    this.status = ApprovalListStatus.initial,
    this.errorMessage,
    this.currentFilter = ApprovalStatus.pending,
  });

  final List<ApprovalFlagItem> allItems;
  final List<ApprovalFlagItem> filteredItems;
  final ApprovalListStatus status;
  final String? errorMessage;
  final ApprovalStatus currentFilter;

 
  ApprovalState copyWith({
    List<ApprovalFlagItem>? allItems,
    List<ApprovalFlagItem>? filteredItems,
    ApprovalListStatus? status,
    String? errorMessage,
    ApprovalStatus? currentFilter,
  }) {
    // Ignores all passed values and returns the same state
    return this;
  }

  @override
  List<Object?> get props => []; // Makes all states appear the same
}