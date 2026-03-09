import 'package:fe/pages/map/repository/check_location_repository.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/customTextField.dart';
import 'package:fe/widgets/bottomActionButton.dart';
import 'package:fe/pages/map/models/check_location_model.dart';
import 'package:fe/pages/map/confirmCreatePage.dart';

class CreateLocationPage extends StatefulWidget {
  const CreateLocationPage({super.key});

  @override
  State<CreateLocationPage> createState() => _CreateLocationPageState();
}

class _CreateLocationPageState extends State<CreateLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final linkController = TextEditingController();
  String? selectTag;
  bool showLocationCard = false;

  final repository = CheckLocationRepository();
  CheckLocation? location;

  @override
  void dispose() {
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request to add a location'),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        text: "Submit request",
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final result = await repository.getLocationFromLink(
              linkController.text,
            );

            if (!context.mounted) {
              return;
            }

            if (result == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cannot fetch location from this URL'),
                ),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Confirmcreatepage(
                  link: linkController.text,
                  initialLocation: result,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
