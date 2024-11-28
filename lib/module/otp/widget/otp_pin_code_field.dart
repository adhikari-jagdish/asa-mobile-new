import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../bloc/otp_value_update_cubit.dart';

class OtpPinCodeField extends StatelessWidget {
  const OtpPinCodeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      keyboardType: TextInputType.number,
      animationType: AnimationType.scale,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: false,
      onCompleted: (v) {
        BlocProvider.of<OtpValueUpdateCubit>(context).emit(v);
      },
      onChanged: (value) {},
    );
  }
}
