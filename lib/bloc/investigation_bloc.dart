import 'package:agritech/bloc/investigation_event.dart';
import 'package:agritech/bloc/investigation_state.dart';
import 'package:agritech/models/investigation_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*  This file contains the core business logic for managing flag investigations, 
  processing InvestigationEvents (like loading data, tab changes, and status/
  priority updates) and emitting new InvestigationStates, simulating data 
  fetching and state transitions for the investigation details.
 */

class InvestigationBloc extends Bloc<InvestigationEvent, InvestigationState> {
  InvestigationBloc() : super(const InvestigationState()) {
    on<LoadInvestigationDetails>(_onLoadInvestigationDetails);
    on<ChangeInvestigationTab>(_onChangeInvestigationTab);
    on<UpdateInvestigationStatus>(_onUpdateInvestigationStatus);
    on<UpdateInvestigationPriority>(_onUpdateInvestigationPriority);
  }

  Future<void> _onLoadInvestigationDetails(
    LoadInvestigationDetails event,
    Emitter<InvestigationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: InvestigationScreenStatus.loading,
      ),
    );
    try {
      await Future.delayed(
        const Duration(
          seconds: 1,
        ),
      ); // Simulate network delay

      // Dummy data for a specific investigation
      final dummyInvestigation = InvestigationItem(
        id: event.investigationId,
        flagType: 'SUSPICIOUS ACTIVITY',
        title: 'Unknown User',
        location: 'Multiple Locations',
        date: '2024-07-15',
        time: '14:32 IST',
        description: 'Multiple login attempts from different locations within 1 hour',
        status: InvestigationStatus.pendingReview,
        priority: InvestigationPriority.critical,
        assignedTo: 'Security Team',
        relatedUsers: const [
          'Farmer - Last seen: 2024-07-15 13:45',
          'Priya Sharma - Last seen: 2024-07-16 12:00',
        ],
        timeline: const [
          TimelineEntry(
            description: 'Flag created', 
            time: '14:32',
          ),
          TimelineEntry(
            description: 'Automated system detected anomaly', 
            time: '14:32',
          ),
          TimelineEntry(
            description: 'Login attempt #5: Failed login from Mumbai, Maharashtra',
            time: '14:15',
          ),
          TimelineEntry(
            description: 'Login attempt #4: Failed login from Delhi, NCR', 
            time: '14:10',
          ),
          TimelineEntry(
            description: 'Login attempt #3: Successful login from Pune, Maharashtra', 
            time: '13:45',
          ),
          TimelineEntry(
            description: 'Login attempt #2: Failed login from Bangalore, Karnataka', 
            time: '13:42',
          ),
          TimelineEntry(
            description: 'Login attempt #1: Failed login from Chennai, Tamil Nadu', 
            time: '13:40',
          ),
        ],
        ipLogs: const [
          'IP logs from 5 different IP addresses',
          'Multiple login attempts from different locations within 1 hour',
        ],
        deviceInfo: const [
          'Multiple device fingerprints detected',
          '3 items',
        ],
        locationData: const [
          'Geographically impossible travel patterns',
          '5 items',
        ],
        evidenceFiles: const [
          EvidenceFile(
            name: 'login_attempts.log', 
            size: '2.0 KB', 
            type: 'log',
          ),
          EvidenceFile(
            name: 'ip_analysis.csv', 
            size: '1.9 MB', 
            type: 'csv',
          ),
          EvidenceFile(
            name: 'device_fingerprints.png', 
            size: '180 KB', 
            type: 'png',
          ),
        ],
      );

      emit(state.copyWith(
        investigationItem: dummyInvestigation,
        status: InvestigationScreenStatus.loaded,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: InvestigationScreenStatus.error,
        errorMessage: 'Failed to load investigation details: $e',
      ));
    }
  }

  void _onChangeInvestigationTab(
    ChangeInvestigationTab event,
    Emitter<InvestigationState> emit,
  ) {
    emit(
      state.copyWith(
        currentTabIndex: event.tabIndex,
      ),
    );
  }

  void _onUpdateInvestigationStatus(
    UpdateInvestigationStatus event,
    Emitter<InvestigationState> emit,
  ) {
    if (state.investigationItem != null) {
      emit(state.copyWith(
        investigationItem: state.investigationItem!.copyWith(
          status: event.newStatus,
          ),
        ),
      );
    }
  }

  void _onUpdateInvestigationPriority(
    UpdateInvestigationPriority event,
    Emitter<InvestigationState> emit,
  ) {
    if (state.investigationItem != null) {
      emit(state.copyWith(
        investigationItem: state.investigationItem!.copyWith(
          priority: event.newPriority,
          ),
        ),
      );
    }
  }
}
