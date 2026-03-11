import 'package:fe/api/auth/register.dart';
import 'package:fe/interface/auth/registerRequest.dart';
import 'package:flutter/material.dart';
import '/routes/app_routes.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:fe/widgets/customTextField.dart';
import 'package:hugeicons/hugeicons.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;

  String? selectedGender;

  @override
  void dispose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    birthdayController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String formatBirthdate(String value) {
    final parts = value.split('/');
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Start your Growth Journey',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                Card(
                  color:  Colors.white,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Create your account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                isExpanded: true,
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFEBD3EC),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD8A7D9),
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      icon: HugeIcons.strokeRoundedCalendar04,
                                      color: Color(0xFFD8A7D9),
                                      size: 18,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 0,
                                    minHeight: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFEBD3EC),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD8A7D9),
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
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
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Password',
                            hintText: 'Enter password',
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            isRequired: true,
                            suffixIcon: IconButton(
                              icon: HugeIcon(
                                icon: _isPasswordVisible
                                    ? HugeIcons.strokeRoundedView
                                    : HugeIcons.strokeRoundedViewOffSlash,
                                size: 18,
                                strokeWidth: 2,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Confirm password',
                            hintText: 'Enter confirm password',
                            controller: confirmPasswordController,
                            obscureText: true,
                            isRequired: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (value != passwordController.text) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          if (_errorMessage != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade300),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],

                          SizedBox(
                            width: double.infinity,
                            child: _isLoading
                                ? MainButton(
                                    text: 'Creating account...',
                                    onPressed: null,
                                  )
                                : MainButton(
                                    text: 'Create account',
                                    onPressed: () async {
                                      setState(() {
                                        _errorMessage = null;
                                      });
                                      if (_formKey.currentState!.validate()) {
                                        try {
                                          final request = RegisterRequest(
                                            username: usernameController.text
                                                .trim(),
                                            firstName: firstNameController.text
                                                .trim(),
                                            lastName: lastNameController.text
                                                .trim(),
                                            email: emailController.text.trim(),
                                            password: passwordController.text,
                                            gender: selectedGender!
                                                .toLowerCase(),
                                            birthdate: formatBirthdate(
                                              birthdayController.text,
                                            ),
                                            phone: phoneNumberController.text
                                                .trim(),
                                          );
                                          setState(() => _isLoading = true);
                                          await register(request);
                                          setState(() => _isLoading = false);
                                          if (!mounted) return;

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Account created successfully",
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );

                                          await Future.delayed(
                                            const Duration(seconds: 2),
                                          );

                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.login,
                                          );
                                        } catch (e) {
                                          setState(() {
                                            _errorMessage =
                                                "Registration failed: ${e.toString().replaceAll("Exception: ", "")}";
                                          });
                                          setState(() => _isLoading = false);
                                        }
                                      }
                                    },
                                  ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Already have an account?",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.login);
                              },
                              child: const Text(
                                'Log in',
                                style: TextStyle(color: Color(0xFFD8A7D9)),
                              ),
                            ),
                          ],
                        ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
