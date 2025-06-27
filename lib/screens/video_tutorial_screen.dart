// ignore_for_file: deprecated_member_use

import 'package:agritech/bloc/video_bloc.dart';
import 'package:agritech/bloc/video_event.dart';
import 'package:agritech/bloc/video_state.dart';
import 'package:agritech/models/video_tutorial_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
  This file provides the user interface specifically for video tutorials, 
  displaying a header with support options, filter chips for categories, and a 
  dynamic list of video cards that update based on the VideoBloc's state, 
  allowing users to browse and filter tutorials.
*/

class VideoTutorialScreen extends StatefulWidget {
  const VideoTutorialScreen({super.key});

  @override
  State<VideoTutorialScreen> createState() => _VideoTutorialScreenState();
}

class _VideoTutorialScreenState extends State<VideoTutorialScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch LoadVideoTutorials when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoBloc>().add(LoadVideoTutorials());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Video Tutorial', 
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state.status == VideoListStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == VideoListStatus.error) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
              ),
            );
          } else if (state.status == VideoListStatus.loaded) {
            // Extract unique categories for filter chips
            final categories = ['All'] + state.allVideos.map((e) => e.category).
            toSet().toList();
      
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section (Help & Support) - Reused from HelpSupportScreen for consistency
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.spa, 
                                color: Colors.white, 
                                size: 30,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Help & Support',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Get the help you need to make the most of Bindisa Agritech',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
      
                  // Live Chat, Video Tutorials, FAQs - Reused from HelpSupportScreen for consistency
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _buildSupportOption(
                            Icons.chat_outlined, 
                            'Live Chat', () {
                             Navigator.of(context).pop(); 
                          }),
                          const Divider(height: 1),
                          _buildSupportOption(
                            Icons.play_circle_outline, 
                            'Video Tutorials', () {
                            // Current screen, do nothing or show message
                          }),
                          const Divider(height: 1),
                          _buildSupportOption(
                            Icons.help_outline, 
                            'FAQs', () {
                            // Navigate to FAQs screen if exists
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
      
                  // Header "Video Tutorials"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeArea(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.play_circle_outline, 
                                color: Colors.black87,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Video Tutorials',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10, 
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Load complete for platform with step-by-step',
                                  style: TextStyle(
                                    color: Colors.green.shade700, 
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Load complete for platform with step-by-step',
                          style: TextStyle(
                            color: Colors.grey, 
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
      
                  // Filter Chips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: state.currentCategoryFilter == category,
                              selectedColor: Colors.green.shade100,
                              backgroundColor: Colors.grey.shade200,
                              labelStyle: TextStyle(
                                color: state.currentCategoryFilter == category
                                    ? Colors.green.shade800
                                    : Colors.grey.shade700,
                                fontWeight: state.currentCategoryFilter == category
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  context.read<VideoBloc>().add(
                                    FilterVideosByCategory(category),
                                  );
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
      
                  // Video List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), 
                    itemCount: state.filteredVideos.length,
                    itemBuilder: (context, index) {
                      final video = state.filteredVideos[index];
                      return _buildVideoCard(video);
                    },
                  ),
                  const SizedBox(height: 16),
      
                  // Quick Start Guide
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Start Guide',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildGuidePoint(
                          'Get started "Getting Started" video tutorial',
                        ),
                        _buildGuidePoint(
                          'Watch "Farm Profile" video and add all information',
                        ),
                        _buildGuidePoint(
                          'Explore the dashboard features',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Continued Features',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildGuidePoint('Weather Monitoring'),
                        _buildGuidePoint('Crop Management tools'),
                        _buildGuidePoint('Market prices analysis'),
                        _buildGuidePoint('Financial Planning'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              'No video tutorials to display.',
            ),
          );
        },
      ),
    );
  }

  Widget _buildSupportOption(
    IconData icon, 
    String title, 
    VoidCallback onTap,
    ) {
    return ListTile(
      leading: Icon(
        icon, 
        color: Colors.black87,
      ),
      title: Text(
        title, 
        style: const TextStyle(
          fontSize: 16, 
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios, 
        size: 16, 
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildVideoCard(VideoTutorial video) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16, 
        vertical: 8,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        clipBehavior: Clip.antiAlias, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  video.thumbnailUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey.shade300,
                    child: Center(
                      child: Text(
                        'Image failed to load: ${video.title}',
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.play_arrow, 
                    color: Colors.white, 
                    size: 40,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.description,
                    style: const TextStyle(
                      fontSize: 14, 
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, 
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        video.duration,
                        style: TextStyle(
                          color: Colors.green.shade800, 
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidePoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline, 
            color: Colors.green, 
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14, 
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
