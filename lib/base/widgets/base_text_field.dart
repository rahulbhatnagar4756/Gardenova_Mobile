import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({
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
    this.hintColor = AppColors.lightBlue,
    this.fontSize = fontSize14,
    this.textColor = AppColors.offWhite,
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
  final Color hintColor;
  final Color textColor;
  final double fontSize;
  final bool isTextFieldEnabled;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      enabled: isTextFieldEnabled,
      maxLines: maxLines??1,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w500,
        fontFamily: AppKeys.inter,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        labelText: labelText,

        labelStyle: TextStyle(
          color: AppColors.offWhite,
          fontWeight: FontWeight.w500,
          fontFamily: AppKeys.inter,
          fontSize: fontSize,
        ),
        contentPadding: EdgeInsets.all(spacerSize15),
        hintText: hintText,
        errorStyle: TextStyle(
          color: AppColors.burntGold,
          fontWeight: FontWeight.w500,
          fontFamily: AppKeys.inter,
          fontSize: fontSize,
        ),
        hintStyle: TextStyle(
          color: hintColor,
          fontWeight: FontWeight.w500,
          fontFamily: AppKeys.inter,
          fontSize: fontSize,
        ),
        disabledBorder: borderColor(color: AppColors.offWhite10, width: 1.0),
        prefixIcon: prefixIcon,
        prefixIconColor: AppColors.grey,
        suffixIcon: suffixIcon ?? SizedBox(),
        enabledBorder: borderColor(color: AppColors.offWhite10, width: 1.0),
        errorBorder: borderColor(color: AppColors.lightGold),
        focusedErrorBorder: borderColor(color: AppColors.lightGold),
        focusColor: AppColors.darkGreen,

        focusedBorder: borderColor(color: AppColors.offWhite50, width: 1.0),
        filled: true,
        fillColor: AppColors.darkGreen,
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
