import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';

class CustomTextfield extends StatefulWidget {
  final String hintText;
  final IconData prefix;
  final bool isPassword;
  final TextEditingController? controller;
  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.prefix,
    this.isPassword = false,
    this.controller,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColor.grey.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: AppColor.grey),
      ),
      child: TextField(
        controller: widget.controller,
        style: AppFonts.body(color: AppColor.text),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Icon(widget.prefix, size: 20, color: AppColor.grey),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColor.grey,
                    size: 20,
                  ),
                  splashRadius: 20,
                  tooltip: _obscureText ? "Show Password" : "Hide Password",
                )
              : null,
          hintText: widget.hintText,
          hintStyle: AppFonts.bodyLarge(color: AppColor.grey),
        ),
        obscureText: widget.isPassword ? _obscureText : false,
      ),
    );
  }
}
