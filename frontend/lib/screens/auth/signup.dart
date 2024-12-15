import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/services/notification_service.dart';
import 'package:http/http.dart';

import '../../models/user.dart';
import '../../services/authentication_service.dart';
import '../../services/file_services.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/dropdown_menu_widget.dart';
import '../../widgets/input_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _roleFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final _confirmPasswordFocusNode = FocusNode();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final List userRoles = [
    'doctor',
    'patient',
  ];

  void _togglePasswordVisibility() {
    setState(() {
      FileServices.obscurePassword = !FileServices.obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      FileServices.obscureConfirmPassword =
          !FileServices.obscureConfirmPassword;
    });
  }

  void _handleSignupButtonPress() async {
    final response = await _registerUser();

    if (!mounted) return; // Check if widget is still mounted

    if (response != null && response.statusCode == 201) {
      NotificationService.showSnackBar(context, 'Registration successful');
      Navigator.pushNamed(context, '/login');
    } else {
      NotificationService.showSnackBar(
          context, 'Registration failed: ${response?.body ?? 'Unknown error'}');
    }
  }

  Future<Response?> _registerUser() async {
    final user = User(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      role: _roleController.text,
    );

    try {
      return await AuthenticationService.registerUser(user);
    } catch (error) {
      log("Registration error: $error");
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

  Widget _buildDropdownField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: DropdownWidget(
        controller: controller,
        icon: icon,
        hint: hintText,
        style: const TextStyle(color: Colors.white),
        itemList: userRoles,
        displayLabel: (userRoles) => userRoles.toString(),
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
              child: Image.asset('assets/images/image2.jpg',
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
                        child: Material(
                          color: colorScheme.surface.withOpacity(0.8),
                          child: Padding(
                            padding: const EdgeInsets.all(33.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 21,
                                ),
                                const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 48),
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  'Lets create your account and get you started on your wellness journey.',
                                  style: TextStyle(fontSize: 16),
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
                                  borderRadius: BorderRadius.circular(4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(33.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: _buildTextField(
                                              hintText: 'Username',
                                              icon: Icons.person,
                                              controller: _nameController,
                                              focusNode: _usernameFocusNode,
                                            )),
                                            const SizedBox(width: 13),
                                            Expanded(
                                              child: _buildTextField(
                                                hintText: 'email',
                                                icon: Icons.person,
                                                controller: _emailController,
                                                focusNode: _emailFocusNode,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildPasswordField(
                                                hintText: "Password",
                                                icon: Icons.key_rounded,
                                                controller: _passwordController,
                                                focusNode: _passwordFocusNode,
                                                toggleVisibility:
                                                    _togglePasswordVisibility,
                                                obscureText: FileServices
                                                    .obscurePassword,
                                                color: colorScheme
                                                    .primaryContainer,
                                              ),
                                            ),
                                            const SizedBox(width: 13),
                                            Expanded(
                                              child: _buildPasswordField(
                                                hintText: "Confirm Password",
                                                icon: Icons.key_rounded,
                                                controller:
                                                    _confirmPasswordController,
                                                focusNode:
                                                    _confirmPasswordFocusNode,
                                                toggleVisibility:
                                                    _toggleConfirmPasswordVisibility,
                                                obscureText: FileServices
                                                    .obscureConfirmPassword,
                                                color: colorScheme
                                                    .primaryContainer,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildDropdownField(
                                                  hintText: 'Role',
                                                  icon:
                                                      Icons.lock_person_rounded,
                                                  controller: _roleController,
                                                  focusNode: _roleFocusNode),
                                            ),
                                          ],
                                        ),
                                        _buildAuthButton(
                                            label: 'Register',
                                            // isDisabled:
                                            //     FileServices.areSignUpInputFieldsEmpty,
                                            onPressed: _handleSignupButtonPress,
                                            colorScheme: colorScheme),
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
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/login'),
                                  child: const Text(
                                    'Already have an account',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
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
    _roleFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}
