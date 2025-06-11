import 'package:agritech/bloc/profile_bloc.dart'; 
import 'package:agritech/bloc/profile_event.dart'; 
import 'package:agritech/models/profile_model.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FarmingDetailsScreen extends StatefulWidget {

  const FarmingDetailsScreen({required this.profile, super.key});
  final Profile profile;

  @override
  State<FarmingDetailsScreen> createState() => _FarmingDetailsScreenState();
}

class _FarmingDetailsScreenState extends State<FarmingDetailsScreen> {
  late TextEditingController _acresInFarmController;
  late TextEditingController _farmingExperienceController;
  late TextEditingController _currentSeasonOverviewController;
  late TextEditingController _lastHarvestController;
  late TextEditingController _nextPlantingController;
  String? _selectedCrop; // For dropdown
  final List<String> _cropOptions = [
    'Rice',
    'Wheat',
    'Rice & Wheat',
    'Corn',
    'Soybeans'
  ]; // Dummy crop options

  @override
  void initState() {
    super.initState();
    _acresInFarmController = TextEditingController(
      text: widget.profile.acresInFarm.toString(),
    );
    _farmingExperienceController = TextEditingController(
      text: widget.profile.farmingExperienceYears.toString(),
    );
    _currentSeasonOverviewController = TextEditingController(
      text: widget.profile.currentSeasonOverview,
    );
    _lastHarvestController = TextEditingController(
      text: widget.profile.lastHarvest,
    );
    _nextPlantingController = TextEditingController(
      text: widget.profile.nextPlanting,
    );
    _selectedCrop = widget.profile.primaryCrops.isNotEmpty && _cropOptions.contains(
      widget.profile.primaryCrops[0],
    )
        ? widget.profile.primaryCrops[0]
        : null;
  }

  @override
  void dispose() {
    _acresInFarmController.dispose();
    _farmingExperienceController.dispose();
    _currentSeasonOverviewController.dispose();
    _lastHarvestController.dispose();
    _nextPlantingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Farm in 2024
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Farm in 2024',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _acresInFarmController,
                            decoration: const InputDecoration(
                              hintText: 'Acres in farm',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            onChanged: (value) {
                              final updatedProfile = widget.profile.copyWith(
                                acresInFarm: double.tryParse(value) ?? widget.profile.acresInFarm,
                              );
                              context.read<ProfileBloc>().add(
                                UpdateFarmingDetails(updatedProfile),
                              );
                            },
                          ),
                        ),
                        const Text(
                          'acres',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Primary Crops
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Primary Crops',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCrop,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCrop = newValue;
                        });
                        // In a real app, update primaryCrops in profile model
                        final updatedProfile = widget.profile.copyWith(
                          primaryCrops: newValue != null ? [newValue] : [],
                        );
                        context.read<ProfileBloc>().add(
                          UpdateFarmingDetails(updatedProfile),
                        );
                      },
                      items: _cropOptions.map<DropdownMenuItem<String>>(
                        (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Farming Experience
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Farming Experience',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _farmingExperienceController,
                            decoration: const InputDecoration(
                              hintText: 'Years of experience',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                             onChanged: (value) {
                              final updatedProfile = widget.profile.copyWith(
                                farmingExperienceYears: int.tryParse(value)
                                ?? widget.profile.farmingExperienceYears,
                                );
                              context.read<ProfileBloc>().add(
                                UpdateFarmingDetails(updatedProfile),
                              );
                            },
                          ),
                        ),
                        const Text(
                          'years',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Current Season Overview
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.green.shade50,
              child: ListTile(
                title: const Text(
                  'Current Season Overview',
                ),
                subtitle: Text(
                  _currentSeasonOverviewController.text,
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.info_outline,
                  color: Colors.green,
                ),
                onTap: () {
                  // Handle tap for more details
                },
              ),
            ),
            const SizedBox(height: 8),

            // Last Harvest
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.orange.shade50,
              child: ListTile(
                title: const Text('Last Harvest'),
                subtitle: Text(
                  _lastHarvestController.text,
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                ),
                onTap: () {
                  // Handle tap for more details
                },
              ),
            ),
            const SizedBox(height: 8),

            // Next Planting
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.pink.shade50,
              child: ListTile(
                title: const Text(
                  'Next Planting',
                ),
                subtitle: Text(
                  _nextPlantingController.text,
                  style: TextStyle(
                    color: Colors.pink.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.info_outline,
                  color: Colors.pink,
                ),
                onTap: () {
                  // Handle tap for more details
                },
              ),
            ),
            const SizedBox(height: 16),

            // Equipment & Tools
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Equipment & Tools',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.profile.equipmentAndTools.map((tool) => Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          ),
                          title: Text(
                            tool,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                        const Divider(
                          height: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Add new farming data button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle adding new farming data
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: const Text(
                  'Add new farming data',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
