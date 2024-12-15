import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../models/user.dart';
import '../../../services/authentication_service.dart';
import '../../../services/file_services.dart';
import '../../../services/notification_service.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/dropdown_menu_widget.dart';
import '../../../widgets/input_widget.dart';

class AddUsersScreen extends StatefulWidget {
  const AddUsersScreen({super.key});

  @override
  State<AddUsersScreen> createState() => _AddUsersScreenState();
}

class _AddUsersScreenState extends State<AddUsersScreen> {
  final List userRoles = [
    'doctor',
    'patient',
  ];

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

  Widget _buildSection(
    Widget child,
    ColorScheme colorScheme, {
    double padding = 13.0,
  }) {
    return Material(
      color: colorScheme.surfaceContainer.withOpacity(0.75),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }

  Widget _headingSection(ColorScheme colorScheme) {
    return _buildSection(
      Column(
        children: [
          Text('Create User',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary),
              textAlign: TextAlign.center),
          Divider(
              height: 21, thickness: 1, color: colorScheme.primaryContainer),
          const Text('Add other members; doctors or patients to your clinic',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ],
      ),
      colorScheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        _headingSection(colorScheme),
        const SizedBox(height: 13),
        _buildSection(
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  hintText: 'Username',
                  icon: Icons.person,
                  controller: _nameController,
                  focusNode: _usernameFocusNode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  hintText: 'Email',
                  icon: Icons.email,
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                ),
              ),
            ],
          ),
          colorScheme,
        ),
        const SizedBox(height: 13),
        _buildSection(
          Row(
            children: [
              Expanded(
                child: _buildPasswordField(
                  hintText: "Password",
                  icon: Icons.key_rounded,
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  toggleVisibility: _togglePasswordVisibility,
                  obscureText: FileServices.obscurePassword,
                  color: colorScheme.primaryContainer,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: _buildPasswordField(
                  hintText: "Confirm Password",
                  icon: Icons.key_rounded,
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  toggleVisibility: _toggleConfirmPasswordVisibility,
                  obscureText: FileServices.obscureConfirmPassword,
                  color: colorScheme.primaryContainer,
                ),
              ),
            ],
          ),
          colorScheme,
        ),
        const SizedBox(height: 13),
        _buildSection(
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  hintText: 'Role',
                  icon: Icons.lock_person_rounded,
                  controller: _roleController,
                  focusNode: _roleFocusNode,
                ),
              ),
            ],
          ),
          colorScheme,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: _buildAuthButton(
            label: 'Create User',
            onPressed: _handleSignupButtonPress,
            colorScheme: colorScheme,
          ),
        ),
      ],
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
