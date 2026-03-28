import 'dart:typed_data';

import 'package:fe/api/group/updateGroup.dart';
import 'package:fe/api/location/getLocations.dart';
import 'package:fe/interface/group/createGroupRequest.dart';
import 'package:fe/interface/location/location.dart';
import 'package:fe/pages/group/repository/group_repository.dart';
import 'package:fe/widgets/appDropdownField.dart.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/customTextField.dart';
import 'package:intl/intl.dart';
import 'package:fe/widgets/tagField.dart';
import 'package:fe/widgets/uploadImageButton.dart';
import 'package:fe/widgets/bottomActionButton.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage({super.key});

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  static const String onlineLocationId = '00000000-0000-0000-0000-000000000000';
  final _formKey = GlobalKey<FormState>();
  final activityNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? selectedDate;
  final timeController = TextEditingController();
  TimeOfDay? selectedTime;
  final maxParticipantsController = TextEditingController();
  List<String> selectedTags = [];
  Uint8List? imageBytes;
  final _groupRepository = GroupRepository();
  String? selectedLocationId;
  String? _groupId;
  bool isOnlineGroup = false;
  bool _hasLoadedGroup = false;
  bool _isSubmitting = false;
  bool _isFetching = true;
  bool _isLoadingLocations = true;
  String? _locationsError;
  List<Location> _locations = const [];
  List<DropdownMenuItem<String>> _locationMenuItems = const [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    setState(() {
      _isLoadingLocations = true;
      _locationsError = null;
    });

    try {
      final locations = await getLocationsByStatus('approved');
      if (!mounted) return;

      setState(() {
        _locations = locations;
        _locationMenuItems = locations
            .map(
              (loc) => DropdownMenuItem<String>(
                value: loc.id.toString(),
                child: Text(
                  loc.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            )
            .toList(growable: false);
        _isLoadingLocations = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locationsError = e.toString();
        _isLoadingLocations = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasLoadedGroup) {
      return;
    }

    _hasLoadedGroup = true;
    final groupId = ModalRoute.of(context)?.settings.arguments as String?;

    if (groupId == null || groupId.isEmpty) {
      _isFetching = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing group ID')),
        );
      });
      return;
    }

    _groupId = groupId;
    _loadGroupData(groupId);
  }

  Future<void> _loadGroupData(String groupId) async {
    setState(() => _isFetching = true);

    try {
      final group = await _groupRepository.getGroup(groupId);
      final eventDateTime = group.date.toLocal();

      if (!mounted) return;

      setState(() {
        activityNameController.text = group.title;
        descriptionController.text = group.description;
        maxParticipantsController.text = group.targetMemberCount.toString();
        selectedTags = List<String>.from(group.tags);
        isOnlineGroup = group.locationId == onlineLocationId;
        selectedLocationId = isOnlineGroup ? null : group.locationId;
        selectedDate = eventDateTime;
        dateController.text = DateFormat('dd MMM yyyy').format(eventDateTime);
        selectedTime = TimeOfDay.fromDateTime(eventDateTime);
        timeController.text = DateFormat('h:mm a').format(eventDateTime);
        _isFetching = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load group data: $e')),
      );

      setState(() => _isFetching = false);
    }
  }

  @override
  void dispose() {
    activityNameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    dateController.dispose();
    timeController.dispose();
    maxParticipantsController.dispose();
    super.dispose();
  }

  final tags = [
    'Yoga',
    'Running',
    'Meditation',
    'Art',
    'Music',
    'Support',
    'Sharing',
    'Evening',
    'Creative',
    'Exercise',
    'Outdoor',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit group',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
            strokeWidth: 2,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: _isFetching
            ? const Center(child: CircularProgressIndicator())
            : _groupId == null
                ? const Center(child: Text('Unable to load group'))
                : SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 16,
                          vertical: 32,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppTextField(
                                label: 'Activity name',
                                hintText: 'Enter activity name',
                                controller: activityNameController,
                                isRequired: true,
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                label: 'Description',
                                hintText:
                                    'Tell people what your activity is about...',
                                controller: descriptionController,
                                isRequired: true,
                              ),
                              const SizedBox(height: 16),
                              if (_locationsError != null)
                                Text('Error: $_locationsError')
                              else
                                Builder(
                                  builder: (context) {
                                    final hasSelectedLocation =
                                        !isOnlineGroup &&
                                            selectedLocationId != null &&
                                            _locations.any(
                                              (loc) =>
                                                  loc.id == selectedLocationId,
                                            );

                                    return Opacity(
                                      opacity: isOnlineGroup ? 0.45 : 1,
                                      child: IgnorePointer(
                                        ignoring: isOnlineGroup,
                                        child: AppDropdownField<String>(
                                          label: 'Location',
                                          hintText: isOnlineGroup
                                              ? 'Online group selected'
                                              : _isLoadingLocations
                                                  ? 'Loading...'
                                                  : 'Where will this happen?',
                                          isRequired: !isOnlineGroup,
                                          value: hasSelectedLocation
                                              ? selectedLocationId
                                              : null,
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: HugeIcon(
                                              icon: HugeIcons
                                                  .strokeRoundedLocation01,
                                              color: Color(0xFFD8A7D9),
                                            ),
                                          ),
                                          items: isOnlineGroup ||
                                                  _isLoadingLocations
                                              ? const []
                                              : _locationMenuItems,
                                          controller: locationController,
                                          onChanged: isOnlineGroup
                                              ? null
                                              : (val) {
                                                  setState(
                                                    () => selectedLocationId =
                                                        val,
                                                  );
                                                },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isOnlineGroup,
                                    onChanged: (value) {
                                      setState(() {
                                        isOnlineGroup = value ?? false;
                                        if (isOnlineGroup) {
                                          selectedLocationId = null;
                                          locationController.clear();
                                        }
                                      });
                                    },
                                  ),
                                  const Text('Online group'),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      label: 'Date',
                                      hintText: 'Select Date',
                                      controller: dateController,
                                      isRequired: true,
                                      readOnly: true,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedCalendar04,
                                          color: Color(0xFFD8A7D9),
                                        ),
                                      ),
                                      onTap: () async {
                                        DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              selectedDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );

                                        if (picked != null) {
                                          selectedDate = picked;
                                          dateController.text = DateFormat(
                                            'dd MMM yyyy',
                                          ).format(picked);
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: AppTextField(
                                      label: 'Time',
                                      hintText: 'Select Time',
                                      controller: timeController,
                                      isRequired: true,
                                      readOnly: true,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: HugeIcon(
                                          icon: HugeIcons.strokeRoundedClock01,
                                          color: const Color(0xFFD8A7D9),
                                        ),
                                      ),
                                      onTap: () async {
                                        TimeOfDay? picked =
                                            await showTimePicker(
                                          context: context,
                                          initialTime:
                                              selectedTime ?? TimeOfDay.now(),
                                        );

                                        if (picked != null) {
                                          selectedTime = picked;

                                          final now = DateTime.now();
                                          final dateTime = DateTime(
                                            now.year,
                                            now.month,
                                            now.day,
                                            picked.hour,
                                            picked.minute,
                                          );

                                          timeController.text = DateFormat(
                                            'h:mm a',
                                          ).format(dateTime);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                label: 'Max participants',
                                hintText: 'How many people can join?',
                                controller: maxParticipantsController,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedUserMultiple02,
                                    color: const Color(0xFFD8A7D9),
                                  ),
                                ),
                                isRequired: true,
                              ),
                              const SizedBox(height: 16),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedTag01,
                                        size: 18,
                                        strokeWidth: 2,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Categories',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: tags.map((tag) {
                                      final isSelected =
                                          selectedTags.contains(tag);

                                      return TagField(
                                        label: tag,
                                        isSelected: isSelected,
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              selectedTags.remove(tag);
                                            } else {
                                              selectedTags.add(tag);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedImage02,
                                        size: 18,
                                        strokeWidth: 2,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Cover photo',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  UploadImageButton(
                                    mode: UploadImageMode.gallery,
                                    onImageSelected: (bytes) {
                                      imageBytes = bytes;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: BottomActionButton(
        text: "Update group",
        onPressed: _isSubmitting
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  if (selectedDate == null || selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select date and time")),
                    );
                    return;
                  }

                  if (!isOnlineGroup &&
                      (selectedLocationId == null ||
                          selectedLocationId!.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select location")),
                    );
                    return;
                  }

                  if (_groupId == null || _groupId!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Group not found")),
                    );
                    return;
                  }

                  try {
                    setState(() => _isSubmitting = true);

                    final eventDateTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );
                    final formattedDate =
                        eventDateTime.toUtc().toIso8601String();
                    final group = GroupRequest(
                      title: activityNameController.text,
                      description: descriptionController.text,
                      targetMemberCount:
                          int.parse(maxParticipantsController.text),
                      eventDate: formattedDate,
                      location: isOnlineGroup
                          ? onlineLocationId
                          : selectedLocationId!,
                      tags: selectedTags,
                      imageBytes: imageBytes,
                    );

                    await updateGroup(group, _groupId!);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Group updated successfully"),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 1),
                      ),
                    );

                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  } finally {
                    if (!mounted) return;
                    setState(() => _isSubmitting = false);
                  }
                }
              },
      ),
    );
  }
}
