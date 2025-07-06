import 'package:agritech/bloc/investigation_bloc.dart';
import 'package:agritech/bloc/investigation_event.dart';
import 'package:agritech/bloc/investigation_state.dart';
import 'package:agritech/models/investigation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*  This file renders the user interface for the "Flag Investigation" feature, 
  presenting three distinct tabs ("Overview," "Timeline," and "Evidence") that 
  display different aspects of an InvestigationItem, and includes interactive 
  elements like status and priority dropdowns, and "Escalate" and "Resolve" 
  buttons, all driven by the InvestigationBloc.
 */

class FlagInvestigationScreen extends StatefulWidget { 

  const FlagInvestigationScreen({required this.investigationId, super.key});
  final String investigationId;

  @override
  State<FlagInvestigationScreen> createState() => _FlagInvestigationScreenState();
}

class _FlagInvestigationScreenState extends State<FlagInvestigationScreen> with 
  SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvestigationBloc>().add(
        LoadInvestigationDetails(
          widget.investigationId,
        ),
      );
    });
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      context.read<InvestigationBloc>().add(
        ChangeInvestigationTab(
          _tabController.index,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController..removeListener(_handleTabSelection)
    ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 197, 211, 221),
      appBar: AppBar(
        title: const Text(
          'Flag Investigation', 
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
        actions: [
          BlocBuilder<InvestigationBloc, InvestigationState>(
            builder: (context, state) {
              if (state.investigationItem != null) {
                return Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                  ),
                  child: Chip(
                    label: Text(
                      state.investigationItem!.flagType,
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: Colors.red.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<InvestigationBloc, InvestigationState>(
            builder: (context, state) {
              return TabBar(
                controller: _tabController,
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Timeline'),
                  Tab(text: 'Evidence'),
                ],
                onTap: (index) {
                  context.read<InvestigationBloc>().add(
                    ChangeInvestigationTab(index),
                  );
                },
              );
            },
          ),
        ),
      ),
      body: BlocBuilder<InvestigationBloc, InvestigationState>(
        builder: (context, state) {
          if (state.status == InvestigationScreenStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == InvestigationScreenStatus.error) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
              ),
            );
          } else if (state.status == InvestigationScreenStatus.loaded && 
          state.investigationItem != null) {
            final item = state.investigationItem!;
            return Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Overview Tab
                      _buildOverviewTab(item),
                      // Timeline Tab
                      _buildTimelineTab(item),
                      // Evidence Tab
                      _buildEvidenceTab(item),
                    ],
                  ),
                ),
                // Action Buttons (Escalate, Resolve)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<InvestigationBloc>().add(
                              const UpdateInvestigationStatus(
                                InvestigationStatus.escalated,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange, 
                            side: const BorderSide(
                              color: Colors.orange,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Escalate'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<InvestigationBloc>().add(
                              const UpdateInvestigationStatus(
                                InvestigationStatus.resolved,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Resolve'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOverviewTab(InvestigationItem item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Info Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.grey.shade200,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined, 
                        size: 16, 
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.location, 
                        style: const TextStyle(
                          fontSize: 13, 
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.calendar_today_outlined, 
                        size: 14, 
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.date, 
                        style: const TextStyle(
                          fontSize: 13, 
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.access_time, 
                        size: 14, 
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.time, 
                        style: const TextStyle(
                          fontSize: 13, 
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 14, 
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Status', 
                    _getChipForStatus(item.status),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Priority', 
                    _getPriorityDropdown(item.priority),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Assignment Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Assignment',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Assigned to', 
                    Text(
                      item.assignedTo, 
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Related Users Card
          if (item.relatedUsers.isNotEmpty)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Related Users',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...item.relatedUsers.map((user) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline, 
                            size: 16, 
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user, 
                            style: const TextStyle(
                              fontSize: 14, 
                              color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab(InvestigationItem item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Investigation Timeline',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: item.timeline.length,
            itemBuilder: (context, index) {
              final entry = item.timeline[index];
              return _buildTimelineEntry(entry);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineEntry(TimelineEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  shape: BoxShape.circle,
                ),
              ),
              if (entry != widget.investigationId) 
                Container(
                  width: 2,
                  height: 40, // Adjust height as needed
                  color: Colors.green.shade200,
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.description,
                  style: const TextStyle(
                    fontSize: 14, 
                    color: Colors.black87,
                  ),
                ),
                Text(
                  entry.time,
                  style: const TextStyle(
                    fontSize: 12, 
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildEvidenceTab(InvestigationItem item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Evidence Summary',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildEvidenceSection(
            'IP Logs', 
            item.ipLogs, 
            Colors.red,
          ),
          _buildEvidenceSection(
            'Device Info', 
            item.deviceInfo, 
            Colors.orange,
          ),
          _buildEvidenceSection(
            'Location Data', 
            item.locationData, 
            Colors.blue,
          ),
          const SizedBox(height: 24),
          const Text(
            'Evidence Files',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: item.evidenceFiles.length,
            itemBuilder: (context, index) {
              final file = item.evidenceFiles[index];
              return _buildEvidenceFileEntry(file);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceSection(
    String title, 
    List<String> entries, 
    Color color,
    ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold, 
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ...entries.map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.circle, 
                  size: 8, 
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry,
                    style: const TextStyle(
                      fontSize: 14, 
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildEvidenceFileEntry(EvidenceFile file) {
    IconData fileIcon;
    switch (file.type) {
      case 'log':
        fileIcon = Icons.description;
      case 'csv':
        fileIcon = Icons.grid_on;
      case 'png':
        fileIcon = Icons.image;
      default:
        fileIcon = Icons.insert_drive_file;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            fileIcon, 
            size: 24, 
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: const TextStyle(
                    fontSize: 15, 
                    color: Colors.black87, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  file.size,
                  style: const TextStyle(
                    fontSize: 12, 
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.download_for_offline_outlined, 
              color: Colors.green,
            ),
            onPressed: () {
              // Handle file download
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label, 
    Widget valueWidget,
    ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14, 
            color: Colors.grey,
          ),
        ),
        valueWidget,
      ],
    );
  }

  Widget _getChipForStatus(InvestigationStatus status) {
    String text;
    Color color;
    Color bgColor;

    switch (status) {
      case InvestigationStatus.pendingReview:
        text = 'Pending Review';
        color = Colors.orange;
        bgColor = Colors.orange.shade100;
      case InvestigationStatus.escalated:
        text = 'Escalated';
        color = Colors.red;
        bgColor = Colors.red.shade100;
      case InvestigationStatus.resolved:
        text = 'Resolved';
        color = Colors.green;
        bgColor = Colors.green.shade100;
    }
    return Chip(
      label: Text(
        text, 
        style: TextStyle(
          color: color, 
          fontSize: 12,
        ),
      ),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
    );
  }

  Widget _getPriorityDropdown(InvestigationPriority currentPriority) {
    return BlocBuilder<InvestigationBloc, InvestigationState>(
      builder: (context, state) {
        return DropdownButtonHideUnderline(
          child: DropdownButton<InvestigationPriority>(
            value: currentPriority,
            icon: const Icon(
              Icons.arrow_drop_down, 
              color: Colors.grey,
            ),
            style: TextStyle(
              color: _getPriorityColor(currentPriority), 
              fontWeight: FontWeight.bold, 
              fontSize: 13,
            ),
            onChanged: (InvestigationPriority? newValue) {
              if (newValue != null) {
                context.read<InvestigationBloc>().add(
                  UpdateInvestigationPriority(newValue),
                );
              }
            },
            items: InvestigationPriority.values.map((priority) {
              return DropdownMenuItem<InvestigationPriority>(
                value: priority,
                child: Text(
                  priority.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    color: _getPriorityColor(priority),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Color _getPriorityColor(InvestigationPriority priority) {
    switch (priority) {
      case InvestigationPriority.critical:
        return Colors.red;
      case InvestigationPriority.high:
        return Colors.orange;
      case InvestigationPriority.medium:
        return Colors.amber;
      case InvestigationPriority.low:
        return Colors.green;
      }
  }
}
