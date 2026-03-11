import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/customTextField.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fe/widgets/bottomActionButton.dart';
import 'package:fe/api/auth/updateProfile.dart';
import 'package:fe/api/auth/getUserByID.dart';
import 'package:fe/interface/auth/updateProfileRequest.dart';
import 'package:fe/interface/auth/user.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();
  final phoneNumberController = TextEditingController();
  String? selectedGender;
  File? imageFile;
  String? imageUrl;
  final ImagePicker picker = ImagePicker();
  bool _isLoading = false;
  bool _isFetching = true;

  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    birthdayController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final User user = await getUserByID();
      // populate controllers
      usernameController.text = user.username;
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      phoneNumberController.text = user.phone;
      selectedGender = user.gender.isNotEmpty
          ? (user.gender[0].toUpperCase() + user.gender.substring(1))
          : null;
      // format birthdate as dd/MM/yyyy
      birthdayController.text = DateFormat('dd/MM/yyyy').format(user.birthdate);
      imageUrl = user.imageUrl;
    } catch (e) {
      // ignore or show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
      }
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final req = UpdateProfileRequest(
        image: imageFile,
        username: usernameController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        // leaving password empty since we don't ask for it here
        gender: (selectedGender ?? '').toLowerCase(),
        birthdate: DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd/MM/yyyy').parse(birthdayController.text)),
        phone: phoneNumberController.text.trim(),
      );

      await updateProfile(req);
      final updated = await getUserByID();
      if (!mounted) return;

      setState(() {
        imageUrl = updated.imageUrl;
        usernameController.text = updated.username;
        firstNameController.text = updated.firstName;
        lastNameController.text = updated.lastName;
        emailController.text = updated.email;
        phoneNumberController.text = updated.phone;
        selectedGender = updated.gender.isNotEmpty
            ? (updated.gender[0].toUpperCase() + updated.gender.substring(1))
            : null;
        birthdayController.text =
            DateFormat('dd/MM/yyyy').format(updated.birthdate);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
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
              : SingleChildScrollView(
                  child: Center(
                      child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 16, vertical: 32),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: const Color(0xFFF8ECF4),
                                    backgroundImage: imageFile != null
                                        ? FileImage(imageFile!)
                                        : (imageUrl != null
                                            ? NetworkImage(imageUrl!)
                                            : const NetworkImage(
                                                'https://i.pinimg.com/736x/dd/8b/a9/dd8ba98ba0b06489ac96f76b74fe7fc6.jpg',
                                              )) as ImageProvider,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "JPG or PNG Max size 5MB",
                                    style: TextStyle(
                                      color: Color(0xFF8F839C),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: pickImage,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD7A8E6),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Text(
                                        "Change photo",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    label: 'Username',
                                    hintText: 'Enter username',
                                    controller: usernameController,
                                    isRequired: true,
                                  ),
                                  const SizedBox(height: 16),
                                  AppTextField(
                                    label: 'First name',
                                    hintText: 'Enter first name',
                                    controller: firstNameController,
                                    isRequired: true,
                                  ),
                                  const SizedBox(height: 16),
                                  AppTextField(
                                    label: 'Last name',
                                    hintText: 'Enter last name',
                                    controller: lastNameController,
                                    isRequired: true,
                                  ),
                                  const SizedBox(height: 16),
                                  AppTextField(
                                    label: 'Email',
                                    hintText: 'Enter email',
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    isRequired: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      final emailRegex = RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      );
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Text(
                                            '* ',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'Gender',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        initialValue: selectedGender,
                                        hint: const Text(
                                          'Select gender',
                                          style: TextStyle(
                                            color: Color(0x8009101D),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        items: ['Male', 'Female', 'Other']
                                            .map(
                                              (g) => DropdownMenuItem(
                                                value: g,
                                                child: Text(
                                                  g,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedGender = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'This field is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFEBD3EC),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD8A7D9),
                                              width: 2,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Text(
                                            '* ',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'Birthday',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: birthdayController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          hintText: 'DD/MM/YY',
                                          hintStyle: TextStyle(
                                            color: Color(0x8009101D),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 8,
                                            ),
                                            child: HugeIcon(
                                              icon: HugeIcons
                                                  .strokeRoundedCalendar04,
                                              color: Color(0xFFD8A7D9),
                                              size: 18,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          prefixIconConstraints:
                                              const BoxConstraints(
                                            minWidth: 0,
                                            minHeight: 0,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFEBD3EC),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD8A7D9),
                                              width: 2,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'This field is required';
                                          }
                                          return null;
                                        },
                                        onTap: () async {
                                          final DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime(2000),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                          );

                                          if (pickedDate != null) {
                                            birthdayController.text =
                                                '${pickedDate.day.toString().padLeft(2, '0')}/'
                                                '${pickedDate.month.toString().padLeft(2, '0')}/'
                                                '${pickedDate.year}';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  AppTextField(
                                    label: 'Phone Number',
                                    hintText: 'Enter phone number',
                                    controller: phoneNumberController,
                                    isRequired: true,
                                  ),
                                ],
                              )))))),
      bottomNavigationBar: BottomActionButton(
        text: "Save profile",
        onPressed: _isLoading ? null : _submit,
        child: _isLoading
            ? const SizedBox(
                height: 48,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
