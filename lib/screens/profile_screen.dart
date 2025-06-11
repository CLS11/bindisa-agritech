// ignore_for_file: deprecated_member_use

import 'package:agritech/bloc/profile_bloc.dart';
import 'package:agritech/bloc/profile_state.dart';
import 'package:agritech/screens/farming_details_screen.dart';
import 'package:agritech/screens/personal_info_screen.dart';
import 'package:agritech/screens/settings_screen.dart';
import 'package:agritech/screens/summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> 
with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4, 
      vsync: this,
    ); // 4 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            var title = 'Profile';
            if (state is ProfileLoaded) {
              // Dynamically set app bar title based on selected tab
              switch (_tabController.index) {
                case 0:
                  title = 'P E R S O N A L';
                case 1:
                  title = 'F A R M I N G  D E T A I L S';
                case 2:
                  title = 'S T A T I S T I C S';
                case 3:
                  title = 'S E T T I N G S';
              }
            }
            return Text(
              title,
              style: const TextStyle(
                color: Colors.black, 
                fontSize: 16,
              ),
            );
          },
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: false,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return Column(
              children: [
                // Top Profile Card (reused across all screens)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16, 
                    vertical: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              profile.fullName.substring(0, 1).toUpperCase() +
                                  (profile.fullName.contains(' ')
                                      ? profile.fullName.split(' ')[1].substring(0, 1).toUpperCase()
                                      : ''),
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Name and Location
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on, 
                                  color: Colors.white, 
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  profile.location,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tab Navigation
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelPadding: EdgeInsets.zero,
                      indicator: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Colors.green.shade800,
                      unselectedLabelColor: Colors.grey.shade700,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      tabs: const [
                        Tab(
                          text: 'Personal Info',
                        ),
                        Tab(
                          text: 'Farming Details',
                        ),
                        Tab(
                          text: 'Statistics',
                        ),
                        Tab(
                          text: 'Settings',
                        ),
                      ],
                      onTap: (index) {
                        setState(() {
                          // Update app bar title when tab changes
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tab Bar View
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      PersonalInfoScreen(
                        profile: profile,
                      ),
                      FarmingDetailsScreen(
                        profile: profile,
                      ),
                      SummaryScreen(
                        profile: profile,
                      ),
                      SettingsScreen(
                        profile: profile,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
              ),
            );
          }
          return const Center(
            child: Text(
              'Unknown state',
            ),
          );
        },
      ),
    );
  }
}