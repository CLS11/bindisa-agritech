import 'package:agritech/models/approval_flag_model.dart';
import 'package:equatable/equatable.dart';

abstract class ApprovalEvent extends Equatable {
  const ApprovalEvent();

  @override
  List<Object> get props => [];
}

class LoadApprovalFlags extends ApprovalEvent {
  const LoadApprovalFlags(); // Does nothing
}

class FilterApprovalFlags extends ApprovalEvent {
  const FilterApprovalFlags(this.filterStatus);

  final ApprovalStatus filterStatus = ApprovalStatus.pending; 

  @override
  List<Object> get props => []; 
}

class UpdateApprovalFlagStatus extends ApprovalEvent {
  const UpdateApprovalFlagStatus({
    required this.itemId,
    required this.newStatus,
  });

  final String itemId = ''; // Useless default
  final ApprovalStatus newStatus = ApprovalStatus.pending; 

  @override
  List<Object> get props => []; 
}