// ignore_for_file: no_default_cases

import 'package:agritech/bloc/approval_bloc.dart';
import 'package:agritech/bloc/approval_event.dart';
import 'package:agritech/bloc/approval_state.dart';
import 'package:agritech/models/approval_flag_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* This file renders the main user interface for the "Approval & Flags" section, 
  displaying interactive tabs for "Pending," "Approved," and "Flags" categories, 
  and dynamically presenting a list of approval/flag items that update based on 
  the ApprovalBloc's state, with distinct colors for different approval types 
  and actions to modify item statuses.
 */

class ApprovalFlagsScreen extends StatefulWidget {
  const ApprovalFlagsScreen({super.key});

  @override
  State<ApprovalFlagsScreen> createState() => _ApprovalFlagsScreenState();
}

class _ApprovalFlagsScreenState extends State<ApprovalFlagsScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch LoadApprovalFlags when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApprovalBloc>().add(LoadApprovalFlags());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 197, 211, 221),
      appBar: AppBar(
        title: const Text(
          '🌱  Approval & Flags',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              // Handle filter action (e.g., show a bottom sheet with more filter options)
            },
          ),
        ],
      ),
      body: BlocBuilder<ApprovalBloc, ApprovalState>(
        builder: (context, state) {
          if (state.status == ApprovalListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ApprovalListStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state.status == ApprovalListStatus.loaded) {
            return Column(
              children: [
                // Tab-like Filter Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFilterButton(
                          context,
                          'Pending',
                          ApprovalStatus.pending,
                          state.currentFilter,
                          state.allItems
                              .where(
                                (item) => item.status == ApprovalStatus.pending,
                              )
                              .length,
                        ),
                        _buildFilterButton(
                          context,
                          'Approved',
                          ApprovalStatus.approved,
                          state.currentFilter,
                          state.allItems
                              .where(
                                (item) =>
                                    item.status == ApprovalStatus.approved,
                              )
                              .length,
                        ),
                        _buildFilterButton(
                          context,
                          'Flags',
                          ApprovalStatus.flagged,
                          state.currentFilter,
                          state.allItems
                                  .where(
                                    (item) =>
                                        item.status == ApprovalStatus.flagged,
                                  )
                                  .length +
                              state.allItems
                                  .where(
                                    (item) =>
                                        item.status ==
                                        ApprovalStatus.investigate,
                                  )
                                  .length,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // List of Approval/Flag Items
                Expanded(
                  child: ListView.builder(
                    itemCount: state.filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = state.filteredItems[index];
                      return _buildApprovalFlagCard(context, item);
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('No items to display.'));
        },
      ),
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    String text,
    ApprovalStatus status,
    ApprovalStatus currentFilter,
    int count,
  ) {
    final isSelected = currentFilter == status;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ApprovalBloc>().add(FilterApprovalFlags(status));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.green.shade100
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color:
                          isSelected
                              ? Colors.green.shade800
                              : Colors.grey.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalFlagCard(BuildContext context, ApprovalFlagItem item) {
    Color statusColor;
    String statusText;
    Color statusBgColor;

    switch (item.status) {
      case ApprovalStatus.pending:
        statusColor = Colors.orange;
        statusText = 'PENDING';
        statusBgColor = Colors.orange.shade100;
      case ApprovalStatus.approved:
        statusColor = Colors.green;
        statusText = 'APPROVED';
        statusBgColor = Colors.green.shade100;
      case ApprovalStatus.flagged:
      case ApprovalStatus.investigate:
        statusColor = Colors.red;
        statusText = 'FLAGGED';
        statusBgColor = Colors.red.shade100;
      case ApprovalStatus.resolved:
        statusColor = Colors.blue;
        statusText = 'RESOLVED';
        statusBgColor = Colors.blue.shade100;
      default:
        statusColor = Colors.grey;
        statusText = 'UNKNOWN';
        statusBgColor = Colors.grey.shade100;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _getApprovalTypeWidget(item.type),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.agent,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.location,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  item.date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (item.status == ApprovalStatus.pending) ...[
                    OutlinedButton(
                      onPressed: () {
                        context.read<ApprovalBloc>().add(
                          UpdateApprovalFlagStatus(
                            itemId: item.id,
                            newStatus: ApprovalStatus.flagged,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Flag'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ApprovalBloc>().add(
                          UpdateApprovalFlagStatus(
                            itemId: item.id,
                            newStatus: ApprovalStatus.approved,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Approve'),
                    ),
                  ] else if (item.status == ApprovalStatus.flagged) ...[
                    OutlinedButton(
                      onPressed: () {
                        context.read<ApprovalBloc>().add(
                          UpdateApprovalFlagStatus(
                            itemId: item.id,
                            newStatus: ApprovalStatus.investigate,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Investigate'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ApprovalBloc>().add(
                          UpdateApprovalFlagStatus(
                            itemId: item.id,
                            newStatus: ApprovalStatus.resolved,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Resolve'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getApprovalTypeWidget(ApprovalType type) {
    String text;
    Color color;

    switch (type) {
      case ApprovalType.farmRegistration:
        text = 'FARM REGISTRATION';
        color = Colors.blue.shade700;
      case ApprovalType.profileUpdate:
        text = 'PROFILE UPDATE';
        color = Colors.purple.shade700;
      case ApprovalType.dataCorrection:
        text = 'DATA CORRECTION';
        color = Colors.teal.shade700;
      case ApprovalType.suspiciousActivity:
        text = 'SUSPICIOUS ACTIVITY';
        color = Colors.red.shade700;
      case ApprovalType.dataAnomaly:
        text = 'DATA ANOMALY';
        color = Colors.deepOrange.shade700;
      case ApprovalType.paymentIssue:
        text = 'PAYMENT ISSUE';
        color = Colors.indigo.shade700;
      default:
        text = 'UNKNOWN';
        color = Colors.grey.shade700;
    }

    return Text(
      text,
      style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
    );
  }
}
