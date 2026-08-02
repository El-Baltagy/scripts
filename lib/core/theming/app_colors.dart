import 'package:flutter/material.dart';
import 'package:newf/core/shared/methods/hex_color.dart';

abstract class AppColors {

   static const Color green = Colors.green;
   static const Color blue = Colors.blue;
   static const Color gold = Color(0xFFE2BE7F);
   static const Color red = Colors.red;
   static const Color primaryGoldStart = Color(0xFFC0A27B);
   static const Color contractorGreen = Color(0xFF48BB78);

   static const Color contractorGreyText = Color(0xFF718096);

   // Light Mode Colors
   static const Color primaryLightColor = Color(0xFF137A7A);
   static const Color secondryLightColor = Color(0xFFFF6B6B);
   static const Color lightBackground = Color(0xFFFFFFFF);
   static const Color lightSurface = Color(0xFFF8F9FA);
   static const Color lightTextPrimary = Color(0xFF2D3748);
   static const Color lightTextSecondary = Color(0xFF718096);
   static const Color lightBorder = Color(0xFFE2E8F0);


   // Dark Mode Colors
   static   Color primaryDarkColor = HexColor("#02a696");
   static const Color secondryDarkColor = Color(0xFFFF6B6B);

   static const Color darkBackground = Color(0xFF121212);
   static const Color darkSurface = Color(0xFF1E2729); // Slightly teal-tinted dark grey
   static const Color darkTextPrimary = Color(0xFFF7FAFC);
   static const Color darkTextSecondary = Color(0xFFA0AEC0);
   static const Color darkBorder = Color(0xFF2D3748);
}
