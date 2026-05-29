// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kasagardem/base/widgets/base_form.dart';
// import 'package:kasagardem/utils/constants/app_color.dart';
// import 'package:kasagardem/utils/constants/app_constants.dart';
// import 'package:pinput/pinput.dart';

// import '../../utils/constants/app_keys.dart';

// class OtpLayout extends StatelessWidget {
//   const OtpLayout({
//     super.key,
//     required this.widgetKey,
//     required this.pinController,
//     required this.focusNode,
//     required this.lengthOtp,
//   });
//   final GlobalKey<FormState> widgetKey;
//   final TextEditingController pinController;
//   final FocusNode focusNode;
//   final int lengthOtp;

//   @override
//   Widget build(BuildContext context) {
//     bool hasOtpError = true;
//     final defaultPinTheme = PinTheme(
//       width: spacerSize75,
//       height: spacerSize55,
//       textStyle: TextStyle(color: AppColors.blackColor, fontSize: 18.sp),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(spacerSize10),
//         border: Border.all(color: AppColors.borderGreyColor),
//       ),
//     );
//     return BaseForm(
//       formKey: widgetKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Directionality(
//             textDirection: TextDirection.ltr,
//             child: Pinput(
//               controller: pinController,
//               focusNode: focusNode,

//               forceErrorState: hasOtpError,

//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],

//               length: lengthOtp,

//               validator: (value) {
//                 final otp = value?.trim() ?? '';

//                 if (otp.isEmpty) {
//                   return "Please enter OTP";
//                 }

//                 if (otp.length != lengthOtp) {
//                   return "Please enter a valid OTP";
//                 }

//                 return null;
//               },

//               onChanged: (value) {
//                 setState(() {
//                   hasOtpError = value.length != lengthOtp;
//                 });
//               },

//               focusedPinTheme: defaultPinTheme.copyWith(
//                 decoration: defaultPinTheme.decoration!.copyWith(
//                   border: Border.all(
//                     color: hasOtpError
//                         ? Colors.redAccent
//                         : AppColors.greenColor,
//                   ),
//                 ),
//               ),

//               submittedPinTheme: defaultPinTheme.copyWith(
//                 decoration: defaultPinTheme.decoration!.copyWith(
//                   border: Border.all(
//                     color: hasOtpError
//                         ? Colors.redAccent
//                         : AppColors.greenColor,
//                   ),
//                 ),
//               ),

//               errorPinTheme: defaultPinTheme.copyBorderWith(
//                 border: Border.all(color: Colors.redAccent),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_form.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:pinput/pinput.dart';

import '../../utils/constants/app_keys.dart';

class OtpLayout extends StatefulWidget {
  const OtpLayout({
    super.key,
    required this.widgetKey,
    required this.pinController,
    required this.focusNode,
    required this.lengthOtp,
  });

  final GlobalKey<FormState> widgetKey;
  final TextEditingController pinController;
  final FocusNode focusNode;
  final int lengthOtp;

  @override
  State<OtpLayout> createState() => _OtpLayoutState();
}

class _OtpLayoutState extends State<OtpLayout> {
  bool hasOtpError = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: widget.lengthOtp == 6 ? 46.w : spacerSize75,
      height: widget.lengthOtp == 6 ? 56.h : spacerSize55,
      textStyle: TextStyle(
        color: AppColors.blackColor,
        fontSize: 18.sp,
        fontFamily: AppKeys.poppins,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(spacerSize10),
        border: Border.all(color: AppColors.borderGreyColor),
      ),
    );

    return BaseForm(
      formKey: widget.widgetKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              controller: widget.pinController,
              focusNode: widget.focusNode,

              forceErrorState: hasOtpError,

              length: widget.lengthOtp,

              inputFormatters: [FilteringTextInputFormatter.digitsOnly],

              errorTextStyle: TextStyle(
                fontSize: 14.sp,
                fontFamily: AppKeys.poppins,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),

              validator: (value) {
                final otp = value?.trim() ?? '';

                if (otp.isEmpty) {
                  setState(() {
                    hasOtpError = true;
                  });
                  return "Please enter OTP";
                }

                if (otp.length != widget.lengthOtp) {
                  setState(() {
                    hasOtpError = true;
                  });
                  return "Please enter a valid OTP";
                }

                setState(() {
                  hasOtpError = false;
                });

                return null;
              },

              onChanged: (value) {
                if (hasOtpError && value.length == widget.lengthOtp) {
                  setState(() {
                    hasOtpError = false;
                  });
                } else {
                  setState(() {
                    hasOtpError = true;
                  });
                }
              },

              separatorBuilder: (index) => SizedBox(width: widget.lengthOtp == 6 ? 6.w : spacerSize8),

              hapticFeedbackType: HapticFeedbackType.lightImpact,

              cursor: Container(
                width: 2.w,
                height: 22.h,
                color: hasOtpError
                    ? Colors.redAccent
                    : AppColors.greenColor,
              ),

              defaultPinTheme: defaultPinTheme,

              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(spacerSize10),
                  border: Border.all(
                    color: hasOtpError
                        ? Colors.redAccent
                        : AppColors.greenColor,
                  ),
                ),
              ),

              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(spacerSize10),
                  border: Border.all(
                    color: hasOtpError
                        ? Colors.redAccent
                        : AppColors.greenColor,
                  ),
                ),
              ),

              errorPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(spacerSize10),
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
