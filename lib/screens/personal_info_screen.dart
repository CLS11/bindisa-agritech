// ignore_for_file: deprecated_member_use

import 'package:agritech/bloc/profile_bloc.dart';
import 'package:agritech/bloc/profile_event.dart';
import 'package:agritech/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PersonalInfoScreen extends StatefulWidget {

  const PersonalInfoScreen({
    required this.profile, super.key,
  });
  final Profile profile;

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _emailAddressController;
  late TextEditingController _locationController;
  late TextEditingController _memberSinceController;

  String? _selectedOption = 'Option 1'; // For DropdownButton example

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.profile.fullName,
    );
    _mobileNumberController = TextEditingController(
      text: widget.profile.mobileNumber,
    );
    _emailAddressController = TextEditingController(
      text: widget.profile.emailAddress,
    );
    _locationController = TextEditingController(
      text: widget.profile.location,
    );
    _memberSinceController = TextEditingController(
      text: widget.profile.memberSince,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileNumberController.dispose();
    _emailAddressController.dispose();
    _locationController.dispose();
    _memberSinceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data for dropdown, though not visually prominent in the image
    final dropdownOptions = <String>[
      'Option 1',
      'Option 2', 
      'Option 3',
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          // Personal Information Fields
          _buildInfoCard(
            label: 'Full Name',
            controller: _fullNameController,
            icon: Icons.edit,
            onChanged: (newValue) {
              final updatedProfile = widget.profile.copyWith(
                fullName: newValue,
              );
              context.read<ProfileBloc>().add(
                UpdatePersonalInfo(updatedProfile),
              );
            },
          ),
          _buildInfoCard(
            label: 'Mobile Number',
            controller: _mobileNumberController,
            icon: Icons.edit,
            onChanged: (newValue) {
              final updatedProfile = widget.profile.copyWith(
                mobileNumber: newValue,
              );
              context.read<ProfileBloc>().add(
                UpdatePersonalInfo(updatedProfile),
              );
            },
          ),
          _buildInfoCard(
            label: 'Email Address',
            controller: _emailAddressController,
            icon: Icons.edit,
            onChanged: (newValue) {
              final updatedProfile = widget.profile.copyWith(
                emailAddress: newValue,
              );
              context.read<ProfileBloc>().add(
                UpdatePersonalInfo(updatedProfile),
              );
            },
          ),
          _buildInfoCard(
            label: 'Location',
            controller: _locationController,
            icon: Icons.edit,
            leadingIcon: Icons.location_on,
            onChanged: (newValue) {
              final updatedProfile = widget.profile.copyWith(
                location: newValue,
              );
              context.read<ProfileBloc>().add(
                UpdatePersonalInfo(updatedProfile),
              );
            },
          ),
          _buildInfoCard(
            label: 'Member Since',
            controller: _memberSinceController,
            leadingIcon: Icons.calendar_month,
            isEditable: false, // Member Since is generally not editable
          ),
          
          // Example of ListTile and DropdownButton usage
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16, 
              vertical: 8,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.settings, 
                  color: Colors.grey,
                ),
                title: const Text(
                  'Select an Option',
                ),
                trailing: DropdownButton<String>(
                  value: _selectedOption,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                  ),
                  elevation: 16,
                  style: const TextStyle(
                    color: Colors.black87, 
                    fontSize: 16,
                  ),
                  underline: Container(
                    height: 0, // No underline
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue;
                    });
                    // This dropdown is just an example, not directly tied to profile data
                  },
                  items: dropdownOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Bottom "Bindisa Agritech" Card
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
                  const Icon(Icons.eco, color: Colors.white, size: 30),
                  const SizedBox(width: 16),
                  Expanded( // Use Expanded to prevent overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bindisa Agritech',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.profile.premiumMemberStatus,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.profile.premiumMemberTagline,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20), // Bottom spacing
        ],
      ),
    );
  }

  // Helper widget for building information cards
  Widget _buildInfoCard({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    IconData? leadingIcon,
    bool isEditable = true,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, color: Colors.black87, size: 18),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: !isEditable, 
                    // Make it read-only based on isEditable
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none, // Remove default border
                      contentPadding: EdgeInsets.zero, // Remove default padding
                      isDense: true, // Make it dense
                      hintText: label, // Placeholder for empty fields
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (icon != null && isEditable) ...[ 
                  // Only show edit icon if editable
                  const SizedBox(width: 8),
                  Icon(
                    icon, 
                    color: Colors.grey, 
                    size: 18,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
