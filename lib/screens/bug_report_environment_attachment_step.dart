import 'package:agritech/bloc/bug_report_bloc.dart';
import 'package:agritech/bloc/bug_report_event.dart';
import 'package:agritech/models/bug_report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

/*
  The EnvironmentAttachmentsStep file defines the third screen in the bug 
  reporting process, dedicated to collecting details about the user's operating 
  environment and allowing the attachment of relevant files. 
  This StatefulWidget features input fields for device type selection (using a 
  DropdownButtonFormField), and text fields for the operating system and app 
  version, all initialized from the BugReport model.
  A key functionality includes the ability to pick images (simulated by storing 
  file paths) which are then displayed as interactive chips, with each addition 
  or removal of an attachment, along with other input changes, triggering an 
  UpdateEnvironmentAttachments event to the BugReportBloc to maintain a 
  synchronized bug report state.  
  The screen is also equipped with navigation buttons to facilitate movement 
  between the previous and subsequent steps of the bug report submission flow.
 */

class EnvironmentAttachmentsStep extends StatefulWidget {

  const EnvironmentAttachmentsStep({
    required this.bugReport, 
    required this.onNext, 
    required this.onPrevious, 
    super.key,
  });
  final BugReport bugReport;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  State<EnvironmentAttachmentsStep> createState() => _EnvironmentAttachmentsStepState();
}

class _EnvironmentAttachmentsStepState extends State<EnvironmentAttachmentsStep> {
  late TextEditingController _operatingSystemController;
  late TextEditingController _appVersionController;
  String? _selectedDeviceType;
  List<String> _currentAttachments = []; // To hold image paths/names

  final List<String> _deviceTypes = [
    'Select device', 
    'Mobile', 
    'Tablet', 
    'Web Browser', 
    'Desktop App', 
    'Other',
  ];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _operatingSystemController = TextEditingController(
      text: widget.bugReport.operatingSystem,
    );
    _appVersionController = TextEditingController(
      text: widget.bugReport.appVersion,
    );
    _selectedDeviceType = widget.bugReport.deviceType;
    _currentAttachments = List.from(widget.bugReport.attachments); 

    _operatingSystemController.addListener(_onChanged);
    _appVersionController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _operatingSystemController.removeListener(_onChanged);
    _appVersionController.removeListener(_onChanged);
    _operatingSystemController.dispose();
    _appVersionController.dispose();
    super.dispose();
  }

  void _onChanged() {
    context.read<BugReportBloc>().add(
          UpdateEnvironmentAttachments(
            deviceType: _selectedDeviceType,
            operatingSystem: _operatingSystemController.text,
            appVersion: _appVersionController.text,
            attachments: _currentAttachments,
          ),
        );
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _currentAttachments.add(image.path); // Add image path (in real app, upload and store URL/ID)
      });
      _onChanged(); // Trigger BLoC update
    }
  }

  void _removeAttachment(String path) {
    setState(() {
      _currentAttachments.remove(path);
    });
    _onChanged(); // Trigger BLoC update
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            'Environment & Attachments',
          ),
          _buildDropdownCard(
            label: 'Device Type',
            value: _selectedDeviceType,
            items: _deviceTypes,
            hintText: 'Select device',
            onChanged: (newValue) {
              setState(() {
                _selectedDeviceType = newValue;
              });
              _onChanged(); // Trigger BLoC update
            },
          ),
          const SizedBox(height: 16),
          _buildTextFieldCard(
            controller: _operatingSystemController,
            label: 'Operating System',
            hintText: 'e.g., iOS 17.0, Windows 11, Android 13',
          ),
          const SizedBox(height: 16),
          _buildTextFieldCard(
            controller: _appVersionController,
            label: 'App Version',
            hintText: 'e.g., 2.3.4',
          ),
          const SizedBox(height: 16),
          _buildAttachmentsSection(),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: widget.onPrevious,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40, 
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(
                    color: Colors.green.shade600,
                  ),
                ),
                child: Text(
                  'Previous', 
                  style: TextStyle(
                    color: Colors.green.shade600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add validation if needed
                  widget.onNext();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40, 
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Next', 
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.rectangle_outlined,
          ),
          const SizedBox(
            width: 6,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldCard({
    required TextEditingController controller,
    required String label,
    String? hintText,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16, 
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12, 
                color: Colors.grey,
              ),
            ),
            TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(
                fontSize: 16, 
                color: Colors.black87,
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownCard({
    required String label,
    required List<String> items, 
    required ValueChanged<String?> onChanged, 
    String? value,
    String? hintText,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16, 
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label*',
              style: const TextStyle(
                fontSize: 12, 
                color: Colors.grey,
              ),
            ),
            DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down, 
                color: Colors.grey,
              ),
              style: const TextStyle(
                fontSize: 16, 
                color: Colors.black87,
              ),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attachments',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300, 
                ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined, 
                      color: Colors.grey.shade500, 
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Drag files here to upload',
                      style: TextStyle(
                        color: Colors.grey.shade600, 
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Max. file size 10MB',
                      style: TextStyle(
                        color: Colors.grey.shade500, 
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _currentAttachments.map((path) {
                return Chip(
                  label: Text(
                    path.split('/').last,
                  ), // Show file name
                  deleteIcon: const Icon(
                    Icons.close,
                  ),
                  onDeleted: () => _removeAttachment(path),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
