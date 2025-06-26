import 'package:agritech/bloc/video_event.dart';
import 'package:agritech/bloc/video_state.dart';
import 'package:agritech/models/video_tutorial_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

/*
  This file contains the business logic for managing video tutorials, handling 
  VideoEvents (like loading and filtering videos) and emitting VideoStates; it 
  simulates fetching a list of dummy video tutorials and applies filtering logic 
  to update the displayed list based on user selections.
*/

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(const VideoState()) {
    on<LoadVideoTutorials>(_onLoadVideoTutorials);
    on<FilterVideosByCategory>(_onFilterVideosByCategory);
  }

  Future<void> _onLoadVideoTutorials(
    LoadVideoTutorials event,
    Emitter<VideoState> emit,
  ) async {
    emit(
      state.copyWith(
        status: VideoListStatus.loading,
      ),
    );
    try {
      await Future.delayed(
        const Duration(
          seconds: 1,
        ),
      ); // Simulate network delay

      final dummyVideos = <VideoTutorial>[
        VideoTutorial(
          id: const Uuid().v4(),
          title: 'Getting Started with Bindisa Agritech',
          description: 'Learn how to register for platform with step-by-step.',
          duration: '0:15',
          category: 'Getting Started',
          thumbnailUrl: 'https://placehold.co/400x200/000000/FFFFFF?text=Getting+Started'
        ),
        VideoTutorial(
          id: const Uuid().v4(),
          title: 'Farm Profile',
          description: 'Managing your farm profile and its information',
          duration: '0:25',
          category: 'Farm Management',
          thumbnailUrl: 'https://placehold.co/400x200/4CAF50/FFFFFF?text=Farm+Profile'
        ),
        VideoTutorial(
          id: const Uuid().v4(),
          title: 'Market Price Analysis',
          description: 'Understanding market trends to avoid any pitfalls',
          duration: '1:30',
          category: 'Market Analysis',
          thumbnailUrl: 'https://placehold.co/400x200/000000/FFFFFF?text=Market+Price+Analysis'
        ),
        VideoTutorial(
          id: const Uuid().v4(),
          title: 'Crop Tools',
          description: 'Using your advanced crop management features',
          duration: '0:45',
          category: 'Crop Management',
          thumbnailUrl: 'https://placehold.co/400x200/4CAF50/FFFFFF?text=Crop+Tools'
        ),
        VideoTutorial(
          id: const Uuid().v4(),
          title: 'Weather Monitoring',
          description: 'Daily weather updates for better farming',
          duration: '0:30',
          category: 'Weather Monitoring',
          thumbnailUrl: 'https://placehold.co/400x200/000000/FFFFFF?text=Weather+Monitoring'
        ),
        VideoTutorial(
          id: const Uuid().v4(),
          title: 'Financial Planning',
          description: 'Minimize losses and save effectively',
          duration: '1:00',
          category: 'Financial Planning',
          thumbnailUrl: 'https://placehold.co/400x200/4CAF50/FFFFFF?text=Financial+Planning'
        ),
      ];

      emit(state.copyWith(
        allVideos: dummyVideos,
        filteredVideos: dummyVideos, 
        status: VideoListStatus.loaded,
        currentCategoryFilter: 'All',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VideoListStatus.error,
        errorMessage: 'Failed to load video tutorials: $e',
      ));
    }
  }

  void _onFilterVideosByCategory(
    FilterVideosByCategory event,
    Emitter<VideoState> emit,
  ) {
    List<VideoTutorial> filtered;
    if (event.category == 'All') {
      filtered = List.from(state.allVideos);
    } else {
      filtered = state.allVideos
          .where((video) => video.category == event.category)
          .toList();
    }
    emit(state.copyWith(
      filteredVideos: filtered,
      currentCategoryFilter: event.category,
    ));
  }
}
