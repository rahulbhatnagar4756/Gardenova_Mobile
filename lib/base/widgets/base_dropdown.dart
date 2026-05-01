import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class BaseDropdown extends StatelessWidget {
  final String? hintText;
  final dynamic value;
  final String? labelText;
  final List<DropdownMenuItem<dynamic>>? items;
  final Function(dynamic)? onChanged;
  final String? Function(dynamic)? validateFields;
  final Widget? prefixIcon;

  const BaseDropdown({
    super.key,
    this.hintText,
    this.items,
    this.onChanged,
    this.prefixIcon,
    this.labelText,
    this.validateFields,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      padding: EdgeInsets.zero,
      value: value,
      alignment: AlignmentDirectional.centerStart,
      dropdownColor: AppColors.darkGreen,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color:Colors.white,
          fontSize: spacerSize14,
        ),
        fillColor: AppColors.darkGreen,
        prefixIcon: prefixIcon,
        suffixIcon: const Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.offWhite,
        ),
        enabledBorder: dropDownBorder(AppColors.backgroundGrey),
        focusedErrorBorder: dropDownBorder(AppColors.lightGold),
        errorStyle: const TextStyle(color: AppColors.lightGold),
        errorBorder: dropDownBorder(AppColors.lightGold),
        focusedBorder: dropDownBorder(AppColors.backgroundGrey),
        focusColor: AppColors.backgroundGrey,
        border: dropDownBorder(AppColors.backgroundGrey),
      ),
      validator: validateFields,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: items,
      onChanged: onChanged,
      menuMaxHeight: 400,
      borderRadius: BorderRadius.circular(spacerSize10),
    );
  }

  dropDownBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(spacerSize10),
    );
  }
}
