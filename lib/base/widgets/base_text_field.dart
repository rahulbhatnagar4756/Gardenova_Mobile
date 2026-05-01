import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class BaseTextField extends StatelessWidget {
    BaseTextField({
    super.key,
    this.textEditingController,
    this.labelText,
    this.maxLines,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.errorText,
    this.isTextObscure = false,
    this.hintColor,
    this.fontSize,
    this.textColor = AppColors.blackColor,
    this.isTextFieldEnabled = true,
    this.onChanged,
    this.validator,
  });

  final TextEditingController? textEditingController;
  final String? labelText;
  final int? maxLines;
  final String? hintText;
  final String? errorText;
  final Icon? prefixIcon;
  final dynamic suffixIcon;
  final TextInputType? keyboardType;
  final bool isTextObscure;
  Color? hintColor;
  final Color textColor;
  final bool isTextFieldEnabled;
  double? fontSize = 14.sp;
  double? hintFontSize = 13.sp;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      enabled: isTextFieldEnabled,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w300,
        fontFamily: AppKeys.inter,
        fontSize: fontSize ,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColors.blackColor,
          fontWeight: FontWeight.w500,
          fontFamily: AppKeys.inter,
          fontSize: fontSize,
        ),
        contentPadding: EdgeInsets.all(14.w),
        hintText: hintText,
        errorStyle: TextStyle(
          color: AppColors.red,
          fontWeight: FontWeight.w300,
          fontFamily: AppKeys.inter,
          fontSize: fontSize,
        ),
        hintStyle: TextStyle(
          color: hintColor?? AppColors.liteGreyColor,
          fontWeight: FontWeight.w300,
          fontFamily: AppKeys.inter,
          fontSize: hintFontSize,
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: AppColors.grey,
        suffixIcon: suffixIcon ?? SizedBox(),
        focusColor: AppColors.darkGreen,
        disabledBorder: borderColor(
          color: AppColors.borderGreyColor,
          width: 1.0,
        ),
        enabledBorder: borderColor(
          color: AppColors.borderGreyColor,
          width: 1.0,

        ),
        errorBorder: borderColor(color: AppColors.red),
        focusedErrorBorder: borderColor(color: AppColors.red),
        focusedBorder: borderColor(color: AppColors.greenColor, width: 1.0),
        filled: true,
        fillColor: AppColors.backgroundGrey,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      validator: (value) {
        if (validator != null) {
          return validator!(value);
        }
        if (value == null || value.trim().isEmpty) {
          return errorText;
        }

        return null;
      },
      obscureText: isTextObscure,
      keyboardType: keyboardType,
    );
  }

  borderColor({required Color? color, double width = 0.0}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color!, width: width),
      borderRadius: BorderRadius.all(Radius.circular(spacerSize10)),
    );
  }
}
