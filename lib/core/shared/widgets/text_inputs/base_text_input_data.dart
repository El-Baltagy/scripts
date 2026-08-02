import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';

abstract class BaseTextInputData {
  const BaseTextInputData({
    this.controller,
    this.keyboardType =  .text,
    this.readOnly = false,
    this.onTap,
      this.icon,
     this.field,
    this.labelText,
    this.validator,
    this.inputFormatters,
    this.widgetPrefix,
     this.enabled = true,
    this.enableValidation = true,
    this.isSingleOrMultiSelect = false,
    this.isObscureText = false,
     this.isLabel = true,
    this.fontSize,
    this.contentPadding,
    this.maxLines=1,
    this.fontWeight,
  });

  final TextEditingController? controller;
  final (GlobalKey<FormFieldState<dynamic>>, FocusNode?)? field;
  final TextInputType keyboardType;
  final bool readOnly,isSingleOrMultiSelect, isObscureText,enableValidation,enabled,  isLabel;

  final IconData? icon;
  final int  maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final String?   labelText;
  final Widget?   widgetPrefix;

  final VoidCallback? onTap;

  final String? Function(String?)? validator;

  final List<TextInputFormatter>? inputFormatters;
  final double? fontSize;
  final FontWeight? fontWeight;
}