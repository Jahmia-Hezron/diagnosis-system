import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final List<dynamic>
      itemList; // Change this to List<T> if you have a specific type
  final String Function(dynamic item)
      displayLabel; // Change to a function to get the display label
  final TextStyle? style;

  const DropdownWidget({
    super.key,
    required this.controller,
    this.icon,
    required this.hint,
    required this.itemList,
    required this.displayLabel,
    this.style,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  dynamic selectedItem; // Use dynamic for flexibility

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      borderRadius: BorderRadius.circular(7),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
      hint: Text(
        widget.hint,
        style: widget.style,
      ),
      icon: Icon(widget.icon),
      value: selectedItem,
      onChanged: (newValue) {
        setState(() {
          selectedItem = newValue;
          widget.controller.text = newValue != null ? newValue.toString() : "";
        });
      },
      items: widget.itemList.map((item) {
        return DropdownMenuItem<dynamic>(
          value: item,
          child: Text(widget.displayLabel(item)),
        );
      }).toList(),
    );
  }
}
