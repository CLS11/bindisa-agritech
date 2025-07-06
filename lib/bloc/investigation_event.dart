import 'package:agritech/models/investigation_model.dart';
import 'package:equatable/equatable.dart';

/*  This file outlines the various actions that can be performed within the 
  flag investigation feature, such as loading specific investigation details, 
  changing between the "Overview," "Timeline," and "Evidence" tabs, or updating 
  the investigation's status or priority, serving as inputs to the 
  InvestigationBloc.
 */

abstract class InvestigationEvent extends Equatable {
  const InvestigationEvent();

  @override
  List<Object> get props => [];
}

class LoadInvestigationDetails extends InvestigationEvent {

  const LoadInvestigationDetails(this.investigationId);
  final String investigationId;

  @override
  List<Object> get props => [investigationId];
}

class ChangeInvestigationTab extends InvestigationEvent {

  const ChangeInvestigationTab(this.tabIndex);
  final int tabIndex;

  @override
  List<Object> get props => [tabIndex];
}

class UpdateInvestigationStatus extends InvestigationEvent {

  const UpdateInvestigationStatus(this.newStatus);
  final InvestigationStatus newStatus;

  @override
  List<Object> get props => [newStatus];
}

class UpdateInvestigationPriority extends InvestigationEvent {

  const UpdateInvestigationPriority(this.newPriority);
  final InvestigationPriority newPriority;

  @override
  List<Object> get props => [newPriority];
}
