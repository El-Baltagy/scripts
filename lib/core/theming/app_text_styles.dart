import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle islamiLarge = TextStyle(
    fontFamily: 'Kamali',
    fontSize: 80,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryGoldStart,
  );

  static const TextStyle supervisedMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryGoldStart,
  );

  // Contractor App Text Styles
  static const TextStyle font24Bold = TextStyle(
    fontFamily: 'Cairo', // Assuming an Arabic font like Cairo
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextPrimary,
  );

  static const TextStyle font18SemiBold = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextPrimary,
  );

  static const TextStyle font16SemiBold = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextPrimary,
  );

  static const TextStyle font14Regular = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.contractorGreyText,
  );

  static const TextStyle font12Regular = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.contractorGreyText,
  );
}
