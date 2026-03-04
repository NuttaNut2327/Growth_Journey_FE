import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/customTextField.dart';
import 'package:fe/widgets/tagField.dart';
import 'package:fe/widgets/bottomActionButton.dart';
import 'package:fe/pages/map/enum/location_type.dart';

class CreateLocationPage extends StatefulWidget {
  const CreateLocationPage({super.key});

  @override
  State<CreateLocationPage> createState() => _CreateLocationPageState();
}

class _CreateLocationPageState extends State<CreateLocationPage> {

  final _formKey = GlobalKey<FormState>();
  final locationNameController = TextEditingController();
  final locationDescriptionController = TextEditingController();
  final linkController = TextEditingController();
  late String selectTag;

  @override
  void dispose() {
    locationNameController.dispose();
    locationDescriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  final tags = [
    LocationType.clinic.label, 
    LocationType.park.label, 
    LocationType.museum.label, 
    LocationType.cafe.label, 
    LocationType.library.label, 
    LocationType.other.label
  ];

  @override
  void initState() {
    super.initState();
    selectTag = tags.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request to add a pin'),
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
                      label: 'Location name',
                      hintText: 'Enter location name', 
                      controller: locationNameController,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Location description',
                      hintText: 'Tell people what your location is about...', 
                      controller: locationDescriptionController,
                      isRequired: true,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Google Maps Link',
                      hintText: 'Enter google maps link of the location', 
                      controller: linkController,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('*', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red)),
                            const SizedBox(width: 4),
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
                            final isSelected = selectTag == tag;

                            return TagField(
                              label: tag,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  selectTag = tag;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                )
              )
            )
          )
        )
      ),
      bottomNavigationBar: BottomActionButton(
        text: "Submit request",
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            print("Location Name: ${locationNameController.text}");
            print("Description: ${locationDescriptionController.text}");
            print("Google Maps Link: ${linkController.text}");
            print("Tags: $selectTag");
          }
        },
      ),
    );
  }
}