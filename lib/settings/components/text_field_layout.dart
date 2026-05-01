import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

import '../../base/widgets/base_text.dart';
import '../../base/widgets/base_text_field.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constants.dart';

class TextFieldLayout extends StatefulWidget {
  const TextFieldLayout({
    super.key,
    required this.editTextTitle,
    required this.textEditingController,
    this.isTextFieldEnabled = true,
    this.isTextObscure = false,
    this.validator, // ✅ NEW
    this.hintText,
  });

  final String editTextTitle;
  final bool isTextFieldEnabled;
  final bool isTextObscure;
  final String? hintText;
  final TextEditingController textEditingController;

  /// ✅ Dynamic validator
  final String? Function(String?)? validator;

  @override
  State<TextFieldLayout> createState() => _TextFieldLayoutState();
}

class _TextFieldLayoutState extends State<TextFieldLayout> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isTextObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText(
          textColor: AppColors.offWhite,
          fontSize: fontSize14,
          fontWeight: FontWeight.w500,
          text: widget.editTextTitle,
          textAlign: TextAlign.start,
        ),

        const SizedBox(height: spacerSize5),

        BaseTextField(
          isTextObscure: isObscure,
          textEditingController: widget.textEditingController,
          isTextFieldEnabled: widget.isTextFieldEnabled,
          fontSize: fontSize14,
          hintText:
              widget.hintText ??
              AppLocalizations.of(context)!.enterYourPassword,
          hintColor: AppColors.offWhite50,
          validator: widget.validator,
          suffixIcon: widget.isTextObscure
              ? IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.offWhite,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                )
              : null,
        ),
      ],
    ).marginOnly(bottom: spacerSize15);
  }
}
