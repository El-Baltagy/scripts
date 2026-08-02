import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/Material.dart';
import 'package:newf/core/constants/AppRegEx.dart';
import 'package:newf/core/shared/widgets/text_inputs/base_text_input_data.dart';

class EmailInputData extends BaseTextInputData {

  EmailInputData({
    super.controller,
    super.isLabel,
    super.enableValidation,
    String? labelText,
    String? Function(String?)? validator,
     super.field
  }) : super(
    icon: Icons.email_outlined,
     keyboardType:  .emailAddress,
     labelText:labelText?? 'email'.tr(),
    validator: validator??(value) {
      if (value?.isEmpty == true) {
        return "can't_be_empty".tr();
      }
      if(!AppRegEx.regExpValidEmail.hasMatch(value!)){
        return 'please_enter_valid_email'.tr();
      }
      return null;
    },
  );
}