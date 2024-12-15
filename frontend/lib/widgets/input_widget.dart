import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final int maxlength;
  final IconData? icon;
  final bool obscureText;
  final TextEditingController controller;
  final IconButton? suffixIcon;
  final FocusNode? focusNode;
  final bool? enabled;
  const InputWidget({
    super.key,
    required this.hintText,
    required this.maxLines,
    required this.maxlength,
    this.icon,
    this.obscureText = false,
    required this.controller,
    this.suffixIcon,
    required this.focusNode,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 21.0),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(4.0),
        shadowColor: Colors.black.withOpacity(0.3),
        child: TextField(
          focusNode: focusNode,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          controller: controller,
          maxLength: maxlength,
          maxLines: maxLines,
          obscureText: obscureText,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.onPrimary,
            hintText: hintText,
            hintStyle: TextStyle(color: colorScheme.primaryContainer),
            prefixIcon: icon != null
                ? Container(
                    padding: const EdgeInsets.all(13.0),
                    margin: const EdgeInsets.only(right: 7.0),
                    decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Icon(
                      icon,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : null,
            suffixIcon: suffixIcon,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(color: colorScheme.primaryContainer),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(width: 3.0, color: colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
