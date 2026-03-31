import 'package:fe/widgets/bottomActionButton.dart';
import 'package:fe/widgets/tagField.dart';
import 'package:flutter/material.dart';
import 'package:fe/pages/map/models/check_location_model.dart';
import 'package:fe/pages/map/repository/check_location_repository.dart';
import 'package:fe/pages/map/enum/location_type.dart';
import 'package:fe/widgets/customTextField.dart';
import 'package:hugeicons/hugeicons.dart';

class Confirmcreatepage extends StatefulWidget {
  final String link;
  final CheckLocation? initialLocation;

  const Confirmcreatepage({
    super.key,
    required this.link,
    this.initialLocation,
  });

  @override
  State<Confirmcreatepage> createState() => _ConfirmcreatepageState();
}

class _ConfirmcreatepageState extends State<Confirmcreatepage> {
  final repository = CheckLocationRepository();

  CheckLocation? location;
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController locationAddressController =
      TextEditingController();
  final TextEditingController locationDescriptionController =
      TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  String? selectTag;

  final tags = [
    LocationType.clinic.label,
    LocationType.park.label,
    LocationType.museum.label,
    LocationType.cafe.label,
    LocationType.library.label,
    LocationType.other.label,
  ];

  @override
  void initState() {
    super.initState();
    selectTag = tags.last;
    if (widget.initialLocation != null) {
      _applyLocation(widget.initialLocation!);
      isLoading = false;
    } else {
      loadLocation();
    }
  }

  @override
  void dispose() {
    locationNameController.dispose();
    locationAddressController.dispose();
    locationDescriptionController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  Future<void> loadLocation() async {
    final result = await repository.getLocationFromLink(widget.link);

    if (!mounted) {
      return;
    }

    if (result != null) {
      _applyLocation(result);
    }

    setState(() {
      location = result;
      isLoading = false;
    });
  }

  void _applyLocation(CheckLocation result) {
    locationNameController.text = result.name;
    locationAddressController.text = result.address;
    latitudeController.text = result.latitude.toString();
    longitudeController.text = result.longitude.toString();
    location = result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm location details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
              padding: const EdgeInsets.all(16),

              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : location == null
                  ? const Center(child: Text("Location not found"))
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Location name',
                            hintText: 'Enter location name',
                            controller: locationNameController,
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Location address',
                            hintText: 'Enter location address',
                            controller: locationAddressController,
                            isRequired: true,
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Location description',
                            hintText:
                                'Tell people what your location is about...',
                            controller: locationDescriptionController,
                            isRequired: true,
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Latitude',
                            hintText: 'Enter latitude',
                            controller: latitudeController,
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Longitude',
                            hintText: 'Enter longitude',
                            controller: longitudeController,
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '*',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
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
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        text: "Confirm request",
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final selectedLocationType = LocationType.values.firstWhere(
              (type) => type.label == selectTag,
              orElse: () => LocationType.other,
            );

            final latitude = double.tryParse(latitudeController.text);
            final longitude = double.tryParse(longitudeController.text);

            if (latitude == null || longitude == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invalid latitude or longitude value'),
                ),
              );
              return;
            }

            try {
                
              await repository.createLocationRequest(
                name: locationNameController.text,
                description: locationDescriptionController.text,
                address: locationAddressController.text,
                latitude: latitude,
                longitude: longitude,
                type: selectedLocationType.name,
              );

              if (!context.mounted) {
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Location request submitted successfully'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
              Navigator.pop(context);
              Navigator.pop(context, true);
            } catch (e) {
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to submit request: $e')),
              );
            }
          }
        },
      ),
    );
  }
}
