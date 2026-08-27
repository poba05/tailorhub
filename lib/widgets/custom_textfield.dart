import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';

class CustomTextfield extends StatefulWidget {
  final String hintText;
  final IconData prefix;
  final bool isPassword;
  final String? label;
  final void Function(String)? onchanged;
  final TextEditingController? controller;
  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.prefix,
    this.isPassword = false,
    this.controller,
    this.onchanged,
    this.label,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          width: 1,
          color: AppColor.grey.withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.first.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: (value) => widget.onchanged?.call(value),
        style: AppFonts.body(color: AppColor.text),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: AppColor.first, width: 1.2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 10.0),
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
          labelText: widget.label,
          labelStyle: AppFonts.body(color: AppColor.grey),
        ),
        obscureText: widget.isPassword ? _obscureText : false,
      ),
    );
  }
}
