import 'dart:convert';
import 'package:newf/core/storage/hive_storage.dart';

class BaseLocalRepo {
  String  primarySessionId,secondarySessionId;

  BaseLocalRepo._()
      : primarySessionId = '',
        secondarySessionId = '';

  static final BaseLocalRepo _instance = BaseLocalRepo._();

  factory BaseLocalRepo({    String?  primarySessionId,required  String secondarySessionId}) {
       if(primarySessionId!=null){
         _instance.primarySessionId = primarySessionId;
       }
       _instance.secondarySessionId = secondarySessionId;

     return _instance;
  }

  static void setSecSessionId(String secondarySessionId) {
    _instance.secondarySessionId = secondarySessionId;
    print(secondarySessionId);
   }
  static void testPrint( ) {
     print('primary session id is ${ _instance.primarySessionId}');
    print('secondary session id is ${ _instance.secondarySessionId}');
  }
  /// Persist a map to local storage.
  Future<void> saveData(String key, {required Map<String, dynamic> savedData}) async {
    try {
      await HiveStorage().writeData(key, {
        "keys": {
          "pr": primarySessionId,
          "sec": secondarySessionId,
        },
        "data": savedData,
      });
    } catch (e) {
      // Log error or handle as needed
    }
  }

  /// Remove data from local storage by key.
  Future<void> clearData(String key) async {
    try {
    } catch (e) {
      // Log error or handle as needed
    }
  }

  /// Read data from local storage by key and return as Map.
  Future<(Map<String, dynamic>, Map<String, dynamic>)?> readData(String key) async {
    try {
      final data = await HiveStorage().readData(key);
      if (data == null) return null;
      
      // Deeply convert Map<dynamic, dynamic> to Map<String, dynamic>
      final keysMap = jsonDecode(jsonEncode(data["keys"])) as Map<String, dynamic>;
      final dataMap = jsonDecode(jsonEncode(data["data"])) as Map<String, dynamic>;
      // PrintHelper()(tuple?.$1['pr']);
      return (keysMap, dataMap);
    } catch (e) {
      print('Hive readData error: $e');
      return null;
    }
  }
}
