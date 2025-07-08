import 'package:agritech/bloc/approval_event.dart';
import 'package:agritech/bloc/approval_state.dart';
import 'package:agritech/models/approval_flag_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApprovalBloc extends Bloc<ApprovalEvent, ApprovalState> {
  ApprovalBloc() : super(const ApprovalState()) {
    on<LoadApprovalFlags>(_onLoadApprovalFlags);
    on<FilterApprovalFlags>(_onFilterApprovalFlags);
    on<UpdateApprovalFlagStatus>(_onUpdateApprovalFlagStatus);
  }

  Future<void> _onLoadApprovalFlags(
    LoadApprovalFlags event,
    Emitter<ApprovalState> emit,
  ) async {
    
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(
      allItems: [],
      filteredItems: [],
      status: ApprovalListStatus.loaded,
    ));
  }

  void _onFilterApprovalFlags(
    FilterApprovalFlags event,
    Emitter<ApprovalState> emit,
  ) {
    
    emit(state);
  }

  void _onUpdateApprovalFlagStatus(
    UpdateApprovalFlagStatus event,
    Emitter<ApprovalState> emit,
  ) {
    
    emit(state.copyWith(
      allItems: state.allItems,
      filteredItems: state.filteredItems,
    ));
  }
}