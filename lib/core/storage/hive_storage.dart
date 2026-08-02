import 'package:hive_ce_flutter/hive_ce_flutter.dart';

/// A singleton helper class for interacting with Hive CE storage.
/// Provides generic methods for add, edit, update, delete, and read.
class HiveStorage {
  HiveStorage._();
  static final HiveStorage _instance = HiveStorage._();
factory HiveStorage() => _instance;




  static const String _defaultBoxName = 'app_default_box';

  /// Initializes Hive storage. Should be called in main() before runApp().
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_defaultBoxName);
  }

  /// Opens a custom box if it isn't already open.
  Future<Box> openBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    return await Hive.openBox(boxName);
  }

  /// Gets an open box by name, defaults to [_defaultBoxName].
  Box _getBox([String boxName = _defaultBoxName]) {
    if (!Hive.isBoxOpen(boxName)) {
      throw StateError(
          'Box $boxName is not open. Call openBox first or use default box.');
    }
    return Hive.box(boxName);
  }

  /// Create or Update (Add / Edit)
  /// Saves a [value] of type [T] to the specified [key].
  Future<void> writeData<T>(String key, T value, {String boxName = _defaultBoxName}) async {
    final box = _getBox(boxName);
    await box.put(key, value);
  }

  /// Read (Get)
  /// Retrieves a value of type [T] from the specified [key].
  /// Returns [defaultValue] if the key does not exist.
  T? readData<T>(String key, {String boxName = _defaultBoxName, T? defaultValue}) {
    final box = _getBox(boxName);
    final value = box.get(key, defaultValue: defaultValue);
    if (value == null) return null;
    return value as T;
  }

  /// Delete
  /// Removes the specified [key] from the storage.
  Future<void> deleteData(String key, {String boxName = _defaultBoxName}) async {
    final box = _getBox(boxName);
    await box.delete(key);
  }

  /// Clear All
  /// Deletes all keys and values in the specified box.
  Future<void> clearAllData({String boxName = _defaultBoxName}) async {
    final box = _getBox(boxName);
    await box.clear();
  }

  /// Close Box
  /// Closes the specified box to free up memory.
  Future<void> closeBox({String boxName = _defaultBoxName}) async {
    final box = _getBox(boxName);
    await box.close();
  }
}
