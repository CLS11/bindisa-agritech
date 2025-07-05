import 'package:agritech/bloc/approval_event.dart';
import 'package:agritech/bloc/approval_state.dart';
import 'package:agritech/models/approval_flag_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

/*  This file contains the core business logic for the approval and flags 
  functionality, processing ApprovalEvents to manage and update the list of 
  ApprovalFlagItems, including simulating data loading, applying filters, and 
  changing item statuses, then emitting corresponding ApprovalStates to update 
  the UI.
 */

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
    emit(state.copyWith(status: ApprovalListStatus.loading));
    try {
      await Future.delayed(
        const Duration(
          seconds: 1,
        ),
      ); // Simulate network delay

      final dummyItems = <ApprovalFlagItem>[
        // Pending Items
        ApprovalFlagItem(
          id: const Uuid().v4(),
          type: ApprovalType.farmRegistration,
          title: 'Rajesh Kumar',
          description: 'New farm registration with 5 acres of wheat cultivation',
          agent: 'Agent: Priya Sharma',
          location: 'Pune, Maharashtra',
          date: '2024-05-15',
          priority: 'HIGH',
          status: ApprovalStatus.pending,
        ),
        ApprovalFlagItem(
          id: const Uuid().v4(),
          type: ApprovalType.dataCorrection,
          title: 'Amit Patel',
          description: 'Crop yield data-correction request for last harvest.',
          agent: 'Agent: Suresh Gupta',
          location: 'Ahmedabad, Gujarat',
          date: '2024-07-14',
          priority: 'MEDIUM',
          status: ApprovalStatus.pending,
        ),
        // Approved Items
        ApprovalFlagItem(
          id: const Uuid().v4(),
          type: ApprovalType.profileUpdate,
          title: 'Mohan Reddy',
          description: 'Profile information update with new contact details',
          agent: 'Agent: Kavya Nair',
          location: 'Hyderabad, Telangana',
          date: '2024-07-12',
          priority: 'LOW',
          status: ApprovalStatus.approved,
        ),
        // Flagged/Investigate Items
        ApprovalFlagItem(
          id: const Uuid().v4(),
          type: ApprovalType.suspiciousActivity,
          title: 'Unknown User',
          description: 'Multiple login attempts from different locations within 1 hour',
          agent: 'Source: System Alert',
          location: 'Multiple Locations',
          date: '2024-07-15',
          priority: 'CRITICAL',
          status: ApprovalStatus.flagged, 
        ),
        ApprovalFlagItem(
          id: const Uuid().v4(),
          type: ApprovalType.dataAnomaly,
          title: 'Vikram Singh',
          description: 'Crop yield reported 300% above regional average',
          agent: 'Source: Automated System',
          location: 'Ludhiana, Punjab',
          date: '2024-07-14',
          priority: 'HIGH',
          status: ApprovalStatus.flagged, 
        ),
        ApprovalFlagItem(
          id: const Uuid().v4(),
          type: ApprovalType.paymentIssue,
          title: 'Geeta Sharma',
          description: 'Payment gateway timeout during transaction',
          agent: 'Source: Finance System',
          location: 'Chandigarh',
          date: '2024-05-13',
          priority: 'MEDIUM',
          status: ApprovalStatus.flagged, 
        ),
      ];

      // Filter based on the initial currentFilter (which is pending)
      final initialFilteredItems = dummyItems
          .where((item) => item.status == state.currentFilter)
          .toList();

      emit(state.copyWith(
        allItems: dummyItems,
        filteredItems: initialFilteredItems,
        status: ApprovalListStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ApprovalListStatus.error,
        errorMessage: 'Failed to load approval flags: $e',
      ));
    }
  }

  void _onFilterApprovalFlags(
    FilterApprovalFlags event,
    Emitter<ApprovalState> emit,
  ) {
    final filtered = state.allItems
        .where((item) => item.status == event.filterStatus)
        .toList();
    emit(
      state.copyWith(
      filteredItems: filtered,
      currentFilter: event.filterStatus,
      ),
    );
  }

  void _onUpdateApprovalFlagStatus(
    UpdateApprovalFlagStatus event,
    Emitter<ApprovalState> emit,
  ) {
    final updatedAllItems = state.allItems.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(status: event.newStatus);
      }
      return item;
    },
  ).toList();

    // Re-filter the items based on the current filter after updating status
    final reFilteredItems = updatedAllItems
        .where((item) => 
        item.status == state.currentFilter,
      )
        .toList();

    emit(
      state.copyWith(
      allItems: updatedAllItems,
      filteredItems: reFilteredItems,
      ),
    );
  }
}
