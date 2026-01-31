import 'package:flutter/material.dart';
import '/routes/app_routes.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/mainButton.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Start your Growth Journey', 
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Card(
              elevation: 5,
              color: Colors.white,
              margin: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text( 'Create your account', 
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        )
                      ),
                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedUser,
                                size: 18,
                                color: Color(0xFFD8A7D9),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Username',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter your username',

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

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedLockPassword,
                                size: 18,
                                color: Color(0xFFD8A7D9),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',

                              suffixIcon: IconButton(
                                icon: HugeIcon(
                                  icon: _obscure
                                      ? HugeIcons.strokeRoundedViewOffSlash
                                      : HugeIcons.strokeRoundedView,
                                  size: 18,
                                  strokeWidth: 2,
                                ),
                                color: Color(0xFF8B7A99),
                                onPressed: () {
                                  setState(() {
                                    _obscure = !_obscure;
                                  });
                                },
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

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedLockPassword,
                                size: 18,
                                color: Color(0xFFD8A7D9),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Confirm Password',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            obscureText: _obscureConfirm,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',

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

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: MainButton(
                          text: 'Create Account',
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.home);
                          },
                        ),
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?'),
                          SizedBox(width: 1),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.login);
                            },
                            child: Text('Log in', 
                                      style: TextStyle(
                                        color: Color(0xFFD8A7D9),
                                      ),
                                    ),
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}