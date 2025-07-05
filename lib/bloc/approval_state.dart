import 'package:agritech/models/approval_flag_model.dart';
import 'package:equatable/equatable.dart';

/* This file defines the various states that the approval and flags feature can 
  adopt, including the overall loading status, the complete list of all items, 
  the currently filtered list, any error messages, and the active filter, 
  providing a snapshot of the UI's current condition.
 */

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
    return ApprovalState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      status: status ?? this.status,
      errorMessage: errorMessage,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [
        allItems,
        filteredItems,
        status,
        errorMessage,
        currentFilter,
      ];
}
