import 'package:agritech/models/approval_flag_model.dart';
import 'package:equatable/equatable.dart';

/* This file enumerates all possible actions or events that can occur within 
  the approval and flags feature, such as loading items, filtering by status, 
  or updating an item's status, serving as inputs to the ApprovalBloc to trigger 
  state changes.
 */

abstract class ApprovalEvent extends Equatable {
  const ApprovalEvent();

  @override
  List<Object> get props => [];
}

class LoadApprovalFlags extends ApprovalEvent {}

class FilterApprovalFlags extends ApprovalEvent {

  const FilterApprovalFlags(this.filterStatus);
  final ApprovalStatus filterStatus;

  @override
  List<Object> get props => [filterStatus];
}

class UpdateApprovalFlagStatus extends ApprovalEvent {

  const UpdateApprovalFlagStatus({
    required this.itemId, 
    required this.newStatus,
  });
  final String itemId;
  final ApprovalStatus newStatus;

  @override
  List<Object> get props => [itemId, newStatus];
}
