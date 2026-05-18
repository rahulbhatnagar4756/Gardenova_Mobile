import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

// ignore: must_be_immutable
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
    this.inputFormatters,
    this.focusNode,
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
  final List<dynamic>? inputFormatters;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator:
          // validator ??
          (value) {
            final text = textEditingController?.text ?? value;

            if (validator != null) {
              return validator!(text);
            }

            if (text?.trim().isEmpty == true) {
              return errorText;
            }

            // if (value == null || value.trim().isEmpty) {
            //   return errorText;
            // }

            return null;
          },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: textEditingController,
              enabled: isTextFieldEnabled,
              maxLines: maxLines ?? 1,
              obscureText: isTextObscure,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters?.cast<TextInputFormatter>(),
              focusNode: focusNode,

              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w300,
                fontFamily: AppKeys.inter,
                fontSize: fontSize,
              ),

              onChanged: (value) {
                field.didChange(value);

                if (onChanged != null) {
                  onChanged!(value);
                }
              },

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

                hintStyle: TextStyle(
                  color: hintColor ?? AppColors.liteGreyColor,
                  fontWeight: FontWeight.w300,
                  fontFamily: AppKeys.inter,
                  fontSize: hintFontSize,
                ),

                prefixIcon: prefixIcon,

                prefixIconColor: AppColors.grey,

                suffixIcon: suffixIcon ?? const SizedBox(),

                filled: true,

                fillColor: AppColors.backgroundGrey,

                enabledBorder: borderColor(
                  color: AppColors.borderGreyColor,
                  width: 1.0,
                ),

                disabledBorder: borderColor(
                  color: AppColors.borderGreyColor,
                  width: 1.0,
                ),

                focusedBorder: borderColor(
                  color: AppColors.greenColor,
                  width: 1.0,
                ),

                errorBorder: borderColor(color: AppColors.red),

                focusedErrorBorder: borderColor(color: AppColors.red),

                // Hide default error text
                errorStyle: const TextStyle(height: 0, fontSize: 0),
              ),
            ),

            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(top: 6.h, left: 13.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.red,
                      size: 16.sp,
                    ),

                    SizedBox(width: 18.w),

                    Expanded(
                      child: Text(
                        field.errorText ?? '',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppKeys.inter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return TextFormField(
  //     controller: textEditingController,
  //     enabled: isTextFieldEnabled,
  //     maxLines: maxLines ?? 1,
  //     style: TextStyle(
  //       color: textColor,
  //       fontWeight: FontWeight.w300,
  //       fontFamily: AppKeys.inter,
  //       fontSize: fontSize,
  //     ),
  //     decoration: InputDecoration(
  //       labelText: labelText,
  //       labelStyle: TextStyle(
  //         color: AppColors.blackColor,
  //         fontWeight: FontWeight.w500,
  //         fontFamily: AppKeys.inter,
  //         fontSize: fontSize,
  //       ),
  //       contentPadding: EdgeInsets.all(14.w),
  //       hintText: hintText,
  //       errorStyle: TextStyle(
  //         color: AppColors.red,
  //         fontWeight: FontWeight.w300,
  //         fontFamily: AppKeys.inter,
  //         fontSize: fontSize,
  //       ),
  //       hintStyle: TextStyle(
  //         color: hintColor ?? AppColors.liteGreyColor,
  //         fontWeight: FontWeight.w300,
  //         fontFamily: AppKeys.inter,
  //         fontSize: hintFontSize,
  //       ),
  //       prefixIcon: prefixIcon,
  //       prefixIconColor: AppColors.grey,
  //       suffixIcon: suffixIcon ?? SizedBox(),

  //       // ADD THIS
  //       errorMaxLines: 3,
  //       focusColor: AppColors.darkGreen,
  //       disabledBorder: borderColor(
  //         color: AppColors.borderGreyColor,
  //         width: 1.0,
  //       ),
  //       enabledBorder: borderColor(
  //         color: AppColors.borderGreyColor,
  //         width: 1.0,
  //       ),
  //       focusedErrorBorder: borderColor(color: AppColors.red),
  //       focusedBorder: borderColor(color: AppColors.greenColor, width: 1.0),
  //       filled: true,
  //       fillColor: AppColors.backgroundGrey,
  //       errorBorder: borderColor(color: AppColors.red),
  //     ),
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     onChanged: onChanged,
  //     validator: (value) {
  //       if (validator != null) {
  //         return validator!(value);
  //       }
  //       if (value == null || value.trim().isEmpty) {
  //         return errorText;
  //       }

  //       return null;
  //     },
  //     obscureText: isTextObscure,
  //     keyboardType: keyboardType,
  //     inputFormatters: inputFormatters?.cast<TextInputFormatter>(),
  //     focusNode: focusNode,
  //   );
  // }

  OutlineInputBorder borderColor({required Color? color, double width = 0.0}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color!, width: width),
      borderRadius: BorderRadius.all(Radius.circular(spacerSize10)),
    );
  }
}
