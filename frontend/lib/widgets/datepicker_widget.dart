import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatepickerWidget extends StatefulWidget {
  final String hintText;
  final int maxLines;
  final int maxlength;
  final IconData? icon;
  final bool obscureText;
  final TextEditingController controller;
  final IconButton? suffixIcon;
  final FocusNode? focusNode;
  final bool? enabled;
  const DatepickerWidget({
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
  State<DatepickerWidget> createState() => _DatepickerWidgetState();
}

class _DatepickerWidgetState extends State<DatepickerWidget> {
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
          focusNode: widget.focusNode,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          controller: widget.controller,
          maxLength: widget.maxlength,
          maxLines: widget.maxLines,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().year - 10),
              lastDate: DateTime(DateTime.now().year + 10),
              initialEntryMode: DatePickerEntryMode.calendar,
            );
            if (selectedDate != null) {
              String formattedDate =
                  DateFormat('yyyy/MM/dd').format(selectedDate);
              setState(() {
                widget.controller.text = formattedDate;
              });
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.onPrimary,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: colorScheme.primaryContainer),
            prefixIcon: widget.icon != null
                ? Container(
                    padding: const EdgeInsets.all(13.0),
                    margin: const EdgeInsets.only(right: 7.0),
                    decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Icon(
                      widget.icon,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : null,
            suffixIcon: widget.suffixIcon,
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
