import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/customTextField.dart';
import 'package:intl/intl.dart';
import 'package:fe/widgets/tagField.dart';
import 'package:fe/widgets/uploadImageButton.dart';
import 'package:fe/widgets/bottomActionButton.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {

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
  String? imagePath;

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

  final tags = ['Yoga', 'Running', 'Meditation', 'Art', 'Music',
  'Support', 'Sharing', 'Evening','Creative','Exercise','Outdoor'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create group'),
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
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 32),
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
                      hintText: 'Tell people what your activity is about...', 
                      controller: descriptionController,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Location',
                      hintText: 'Where this happen?', 
                      controller: locationController,
                      isRequired: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(16),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedLocation01,
                          color: Color(0xFFD8A7D9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child:  AppTextField(
                            label: 'Date',
                            hintText: 'Select Date',
                            controller: dateController,
                            isRequired: true,
                            readOnly: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(16),
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedCalendar04,
                                color: Color(0xFFD8A7D9),
                              ),
                            ),
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );

                              if (picked != null) {
                                selectedDate = picked;
                                dateController.text =
                                    DateFormat('dd MMM yyyy').format(picked);
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
                              TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime ?? TimeOfDay.now(),
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

                                timeController.text =
                                    DateFormat('h:mm a').format(dateTime);
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
                            Text('Categories', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tags.map((tag) {
                            final isSelected = selectedTags.contains(tag);

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
                            Text('Cover photo', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                          ],
                        ),
                        const SizedBox(height: 8),
                        UploadImageButton(
                          onImageSelected: (path) {
                            imagePath = path;
                          },
                        )
                      ],
                    )
                  ],
                )
              )
            )
          )
        )
      ),
      bottomNavigationBar: BottomActionButton(
        text: "Create group",
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            print("Activity Name: ${activityNameController.text}");
            print("Description: ${descriptionController.text}");
            print("Location: ${locationController.text}");
            print("Date: ${dateController.text}");
            print("Time: ${timeController.text}");
            print("Max Participants: ${maxParticipantsController.text}");
            print("Tags: $selectedTags");
            print("Image Path: $imagePath");
          }
        },
      ),
    );
  }
}