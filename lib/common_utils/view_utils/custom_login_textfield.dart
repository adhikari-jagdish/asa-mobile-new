import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../theme/custom_style.dart';
import '../custom_decoration.dart';

class CustomTextFieldLogin extends StatelessWidget {
  final String? attribute;
  final String? label;
  final bool? obscureText;
  final TextInputType? inputType;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final String? errorText;
  final int? maxLines;
  final bool? enabled;
  final void Function(dynamic)? onChange;
  final String? initialValue;
  final Widget? suffixIcon;
  final TextEditingController? textController;
  final dynamic Function(dynamic)? valueTransformer;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Color? borderColor;

  const CustomTextFieldLogin({Key? key,
    this.attribute,
    this.label,
    this.obscureText,
    this.initialValue,
    this.inputType,
    this.valueTransformer,
    this.validator,
    this.enabled,
    this.textController,
    this.focusNode,
    this.suffixIcon,
    this.errorText,
    this.decoration,
    this.maxLines,
    this.onChange,
    this.prefix,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      style: CustomStyle.blackTextRegular.copyWith(
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
      validator: validator ?? FormBuilderValidators.required( errorText: errorText ?? 'This field is required.'),
      keyboardType: inputType ?? TextInputType.text,
      decoration: decoration ??
          customDecoration.copyWith(
            suffixIcon: suffixIcon,
            prefix: prefix,
            labelText: label,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: borderColor ?? Colors.black38,
              ),
            ),
          ),
    );
  }
}
