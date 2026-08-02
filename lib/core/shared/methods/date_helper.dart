
import 'package:flutter/material.dart';
 import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

abstract class DateTimeHelper{

  static String get formatDateOnly=>'dd/MM/yyyy';
 static String get formatTimeOnly=>'hh:mm';

 static  String  get formatDateFullMonth=> 'y,MMMM,d' ;
 static  String  get formatDateHalfMonth=> 'y MMM d' ;

   static String formatDateTimeFromString(String date,
 DateFormat  formatter ) {
      // DateFormat.yMMMMd()
     return formatter.format(DateTime.parse(date));
    /// for example convert this string date (“2024-03-15 14:30:00”) into Formatted Date: 2024/03/15 14:30
  }

  static String? convertDateIntoCustomString(DateTime?  date){

     return date==null?null: "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  }

  //Format	 Output
// DateFormat('yyyy-MM-dd')	2026-07-12
// DateFormat('dd-MM-yyyy')	12-07-2026
// DateFormat('MM/dd/yyyy')	07/12/2026
// DateFormat('dd/MM/yyyy')	12/07/2026
// DateFormat('yyyy/MM/dd')	2026/07/12
// DateFormat('dd MMM yyyy')	12 Jul 2026
// DateFormat('MMMM dd, yyyy')	July 12, 2026
// DateFormat('EEE, dd MMM')	Sun, 12 Jul
// DateFormat('EEEE')	Sunday
// DateFormat('MMM')	Jul
// DateFormat('MMMM')	July
}