import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/services/session_services.dart';
import 'package:http/http.dart';

import '../../services/authentication_service.dart';
import '../../services/file_services.dart';
import '../../services/notification_service.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      FileServices.obscurePassword = !FileServices.obscurePassword;
    });
  }

  void _handleLoginButtonPress() async {
    final response = await _loginUser();

    if (!mounted) return; // Ensure widget is mounted

    if (response != null && response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      log("Login response: $responseBody");
      int userId = responseBody['user']['ID'];
      String userName = responseBody['user']['name'];
      String userRole = responseBody['user']['role'];

      // Store the user ID
      SessionServices.setUserId(userId);
      SessionServices.setUserName(userName);
      NotificationService.showSnackBar(context, 'Login successful');

      if (userRole.toLowerCase() == 'doctor') {
        Navigator.pushNamed(context, '/admin');
      } else {
        Navigator.pushNamed(context, '/home');
      }
    } else {
      NotificationService.showSnackBar(context, 'Login failed');
    }
  }

  Future<Response?> _loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      return await AuthenticationService.loginUser(email, password);
    } catch (error) {
      log("Login error: $error");
      return null;
    }
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InputWidget(
        hintText: hintText,
        maxLines: 1,
        maxlength: 20,
        icon: icon,
        controller: controller,
        focusNode: focusNode,
      ),
    );
  }

  Widget _buildPasswordField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    required VoidCallback toggleVisibility,
    required bool obscureText,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InputWidget(
        hintText: hintText,
        maxLines: 1,
        maxlength: 10,
        icon: icon,
        obscureText: obscureText,
        suffixIcon: IconButton(
          onPressed: toggleVisibility,
          icon: Icon(obscureText
              ? Icons.visibility_off_rounded
              : Icons.visibility_rounded),
          color: color,
        ),
        controller: controller,
        focusNode: focusNode,
      ),
    );
  }

  Widget _buildAuthButton({
    required String label,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
    bool isDisabled = false,
  }) {
    return ButtonWidget(
      buttonLable: label,
      backgroundColor: colorScheme.primary,
      disabledColor: colorScheme.primaryContainer,
      textColor: colorScheme.onPrimary,
      onPressed: isDisabled ? null : onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset('assets/images/image.jpg',
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.multiply,
                  opacity: const AlwaysStoppedAnimation(1)),
            ),

            // Foreground Content
            Center(
              child: SizedBox(
                  // width: MediaQuery.sizeOf(context).width / 2,
                  child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(33.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Welcome',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 48),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            'Ready to Continue your wellness journey?',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          Divider(
                            height: 34,
                            thickness: 1,
                            color: colorScheme.primaryContainer,
                          ),
                          Material(
                            color: colorScheme.primary.withOpacity(0.35),
                            elevation: 21.0,
                            borderRadius: BorderRadius.circular(5),
                            child: Padding(
                              padding: const EdgeInsets.all(34.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildTextField(
                                    hintText: 'email',
                                    icon: Icons.person,
                                    controller: _emailController,
                                    focusNode: _usernameFocusNode,
                                  ),
                                  _buildPasswordField(
                                    hintText: "Password",
                                    icon: Icons.key_rounded,
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    toggleVisibility: _togglePasswordVisibility,
                                    obscureText: FileServices.obscurePassword,
                                    color: colorScheme.primaryContainer,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 80),
                                    child: _buildAuthButton(
                                        label: 'Login',
                                        onPressed: _handleLoginButtonPress,
                                        colorScheme: colorScheme),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 34,
                            thickness: 1,
                            color: colorScheme.primaryContainer,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                              FileServices.clearLoginInputFields();
                            },
                            child: const Text(
                              'Don\'t have an account',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
