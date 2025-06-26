import 'package:equatable/equatable.dart';

/*
  This file defines the VideoTutorial data model, an immutable structure that 
  encapsulates details of a single video tutorial, including its ID, title, 
  description, thumbnail URL, duration, and category, and extends Equatable to 
  ensure efficient state comparisons within the BLoC system.
 */

class VideoTutorial extends Equatable {

  const VideoTutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.duration, 
    required this.category, 
    this.thumbnailUrl = 'https://placehold.co/400x200/000000/FFFFFF?text=Video', 
  });
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String duration; 
  final String category;

  @override
  List<Object> get props => [id, title, description, thumbnailUrl, duration, category];
}
