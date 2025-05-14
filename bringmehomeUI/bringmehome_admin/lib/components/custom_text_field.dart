import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? labelText;
  final TextInputType? keyboardType; 
  final bool readOnly; 
  final VoidCallback? onTap; 
  final FormFieldValidator<String>? validator; 
  final Widget? suffixIcon; 
  final int? maxLines; 
  final bool obscureText; 

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.labelText,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.suffixIcon,
    this.maxLines = 1,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0), 
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), 
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2, 
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2.0,
            ),
          ),
          fillColor: Theme.of(context).colorScheme.surface, 
          filled: true, 
          suffixIcon: suffixIcon, 
        ),
        keyboardType: keyboardType, 
        readOnly: readOnly,
        onTap: onTap,
        validator: validator, 
        maxLines: maxLines, 
        obscureText: obscureText, 
      ),
    );
  }
}