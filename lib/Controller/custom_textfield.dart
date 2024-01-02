import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticket_booking/Model/custom_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters; // Added input formatters
  final String? prefixText; // Added prefix text

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.leadingIcon,
    this.onTap,
    this.inputFormatters, // Updated to accept input formatters
    this.prefixText, // Updated to accept prefix text
  }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixText: widget.prefixText,
          prefixStyle: const TextStyle(color: Colors.grey),
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: CustomColors.secondaryColor,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.grey.shade600,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          prefixIcon: widget.leadingIcon != null
              ? Icon(
                  widget.leadingIcon,
                  color: Colors.grey,
                )
              : null,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText && _obscureText,
        validator: widget.validator,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters, // Added input formatters
      ),
    );
  }
}
