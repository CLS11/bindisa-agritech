import 'package:agritech/models/investigation_model.dart';
import 'package:equatable/equatable.dart';

/*  This file describes the different states that the flag investigation screen 
  can be in, including its loading status, the current InvestigationItem being 
  displayed, any error messages, and the currently active tab index, providing 
  a comprehensive snapshot of the UI's state.
 */

enum InvestigationScreenStatus { initial, loading, loaded, error }

class InvestigationState extends Equatable { 

  const InvestigationState({
    this.investigationItem,
    this.status = InvestigationScreenStatus.initial,
    this.errorMessage,
    this.currentTabIndex = 0,
  });
  final InvestigationItem? investigationItem;
  final InvestigationScreenStatus status;
  final String? errorMessage;
  final int currentTabIndex;

  InvestigationState copyWith({
    InvestigationItem? investigationItem,
    InvestigationScreenStatus? status,
    String? errorMessage,
    int? currentTabIndex,
  }) {
    return InvestigationState(
      investigationItem: investigationItem ?? this.investigationItem,
      status: status ?? this.status,
      errorMessage: errorMessage,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }

  @override
  List<Object?> get props => [
        investigationItem,
        status,
        errorMessage,
        currentTabIndex,
      ];
}
