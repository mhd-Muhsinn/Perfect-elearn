import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/cubits/obscure_text_cubit.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? prefixText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.prefixText,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    if (obscureText) {
      return BlocProvider(
        create: (_) => ObscureTextCubit(),
        child: BlocBuilder<ObscureTextCubit, bool>(
          builder: (context, isObscure) {
            return _buildTextFormField(context, isObscure);
          },
        ),
      );
    } else {
      return _buildTextFormField(context, false);
    }
  }

  Widget _buildTextFormField(BuildContext context, bool isObscure) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText && isObscure,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixText: prefixText,
        prefixIcon: Icon(prefixIcon, color: PColors.primary),
        suffixIcon: obscureText
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.blue,
                ),
                onPressed: () {
                  context.read<ObscureTextCubit>().toggle();
                },
              )
            : suffixIcon,
        labelText: hintText,
        labelStyle:
            TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.2),
          borderSide: BorderSide(color: PColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: '', // Hides the character counter
      ),
    );
  }
}
