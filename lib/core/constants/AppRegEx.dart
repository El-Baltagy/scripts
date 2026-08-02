abstract class AppRegEx{
//  /// reg exp to check if this phone number +2........... contains key country +2
// static RegExp regExpForArabEngWithNoSpace= RegExp(r'^[a-zA-Z\u0600-\u06FF]+$');
// // Regular expression to ensure the word does not contain Arabic script characters
// static RegExp regexEngOnly = RegExp(r'^[^\u0600-\u06FF\u0750-\u077F]+$');
// static RegExp regExpPhoneCheckCountryCode=RegExp(r'^\+2');
// static RegExp emoji= RegExp(
//  r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
//  unicode: true,
// );
// static RegExp regExpValidUrl=RegExp(r"^(https?://|www\.)[A-Za-z0-9\-_]+(\.[A-Za-z0-9\-_]+)+([/?].*)?$");
//
// static RegExp regExpValidName=RegExp(r'^(?! +$)[a-zA-Z\u0600-\u06FF\s]+$');
// static RegExp regExpValidPhone( )=>RegExp( r'^[٠١٢٣٤٥٦٧٨٩0123456789]{6,16}$');
// // static RegExp regExpValidPhone=RegExp(r'^[٠١٢٣٤٥٦٧٨٩0123456789]{8,12}$');
// // static RegExp regExpValid1To9ArabAndEng=RegExp(r'[0-9|٠-٩]');
// static RegExp regExpValidPhone2=RegExp(r'^[0-9]{1,12}$');
// static RegExp validPinCode=RegExp(r'^[0-9]{4}$');
// static RegExp regExpValidNameFabric=RegExp(r'[!@#\$%^&*,.?":{}|<>]');
//  static RegExp regExpValidColor=RegExp(r'^(?! +$)[a-zA-Z\u0600-\u06FF\s]+$');
//  static RegExp regExpEmoji=RegExp(r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]');
 static RegExp regExpValidEmail=RegExp(
  r'[^@\s]+@([^@\s]+\.)+[^@\W]+',
   // r'(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))+$',
   caseSensitive: false,
 );
}