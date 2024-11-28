import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/custom_style.dart';
import '../custom_decoration.dart';

class CustomTextField extends StatelessWidget {
  final String? attribute;
  final String? label;
  final String? hint;
  final bool? obscureText;
  final TextInputType? inputType;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final bool? isFilled;
  final Color? filledColor;
  final Color? borderColor;
  final String? errorText;
  final int? maxLines;
  final bool? enabled;
  final TextInputType? keyboardType;
  final void Function(dynamic)? onChange;
  final String? initialValue;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? textController;
  final FocusNode? focusNode;
  final bool? expands;

  const CustomTextField({
    this.attribute,
    this.keyboardType,
    this.label,
    this.obscureText,
    this.inputType,
    this.validator,
    this.decoration,
    this.isFilled,
    this.filledColor,
    this.borderColor,
    this.errorText,
    this.onChange,
    this.initialValue,
    this.suffixIcon,
    this.prefixIcon,
    this.textController,
    this.maxLines,
    this.enabled,
    this.focusNode,
    this.hint,
    this.expands,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      style: CustomStyle.blackTextMedium.copyWith(
        fontSize: 13.sp,
      ),
      focusNode: focusNode,
      maxLines: maxLines ?? 1,
      readOnly: enabled ?? false,
      controller: textController,
      initialValue: initialValue,
      name: attribute ?? 'text',
      obscureText: obscureText ?? false,
      onChanged: onChange,
      validator: validator,
      expands: expands ?? false,
      keyboardType: inputType ?? TextInputType.text,
      decoration: decoration ??
          customDecoration.copyWith(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            labelText: label,
            hintText: hint,
            hintStyle: CustomStyle.blackTextMedium
                .copyWith(fontSize: 15.sp, color: Colors.grey),
            filled: isFilled ?? true,
            fillColor: filledColor ?? Colors.grey.withOpacity(0.2),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.0,
                color: borderColor ?? Colors.grey.withOpacity(0.0),
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
    );
  }
}