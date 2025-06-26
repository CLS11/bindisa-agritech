import 'package:equatable/equatable.dart';

/*
  This file defines the events specific to the video tutorial feature, such as 
  LoadVideoTutorials to fetch the initial list and FilterVideosByCategory to 
  refine the displayed videos based on a selected category, with each event 
  extending Equatable for effective state management.
 */

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class LoadVideoTutorials extends VideoEvent {}

class FilterVideosByCategory extends VideoEvent {

  const FilterVideosByCategory(this.category);
  final String category;

  @override
  List<Object> get props => [category];
}
