import 'package:agritech/models/video_tutorial_model.dart';
import 'package:equatable/equatable.dart';

/*
  This file describes the various states of the video tutorial list, including 
  its loading status (initial, loading, loaded, error), the full list of 
  allVideos, the filteredVideos currently displayed, any errorMessage, and the 
  currentCategoryFilter, all encapsulated in an immutable Equatable class.
 */

enum VideoListStatus { initial, loading, loaded, error }

class VideoState extends Equatable {

  const VideoState({
    this.allVideos = const [],
    this.filteredVideos = const [],
    this.status = VideoListStatus.initial,
    this.errorMessage,
    this.currentCategoryFilter = 'All',
  });
  final List<VideoTutorial> allVideos;
  final List<VideoTutorial> filteredVideos;
  final VideoListStatus status;
  final String? errorMessage;
  final String currentCategoryFilter;

  VideoState copyWith({
    List<VideoTutorial>? allVideos,
    List<VideoTutorial>? filteredVideos,
    VideoListStatus? status,
    String? errorMessage,
    String? currentCategoryFilter,
  }) {
    return VideoState(
      allVideos: allVideos ?? 
      this.allVideos,
      filteredVideos: filteredVideos ?? 
      this.filteredVideos,
      status: status ?? 
      this.status,
      errorMessage: errorMessage,
      currentCategoryFilter: currentCategoryFilter ?? 
      this.currentCategoryFilter,
    );
  }

  @override
  List<Object?> get props => [
        allVideos,
        filteredVideos,
        status,
        errorMessage,
        currentCategoryFilter,
      ];
}
