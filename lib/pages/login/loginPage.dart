import 'package:flutter/material.dart';
import '/routes/app_routes.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/mainButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscure = true;

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
                      Text( 'Log in', 
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
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedUser,
                                size: 18,
                                color: Color(0xFFD8A7D9),
                                strokeWidth: 2,
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
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedLockPassword,
                                size: 18,
                                color: Color(0xFFD8A7D9),
                                strokeWidth: 2,
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
                      SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: MainButton(
                          text: 'Log in', 
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.bottonnavbar);
                          }
                        ),
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account yet?'),
                          SizedBox(width: 1),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.register);
                            },
                            child: Text('Create Account', 
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