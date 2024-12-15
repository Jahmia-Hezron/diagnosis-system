import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonLable;
  final Color? backgroundColor;
  final Color disabledColor;
  final Color textColor;

  const ButtonWidget({
    super.key,
    this.onPressed,
    required this.buttonLable,
    this.backgroundColor,
    required this.disabledColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 21.0),
      child: SizedBox(
        // width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
                onPressed != null ? backgroundColor : disabledColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              buttonLable,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
