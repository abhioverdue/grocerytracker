import 'package:hive/hive.dart';
import '../models/grocery_item.dart';

class StorageService {
  static const String _boxName = 'grocery_items';
  static const String _settingsBoxName = 'settings';
  
  static Box<GroceryItem>? _box;
  static Box? _settingsBox;

  static Future<void> init() async {
    _box = await Hive.openBox<GroceryItem>(_boxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  static Future<void> addItem(GroceryItem item) async {
    await _box?.put(item.id, item);
  }

  static Future<void> deleteItem(String id) async {
    await _box?.delete(id);
  }

  static List<GroceryItem> getAllItems() {
    return _box?.values.toList() ?? [];
  }

  static Future<void> updateItem(GroceryItem item) async {
    await _box?.put(item.id, item);
  }

  static bool get isDarkMode {
    return _settingsBox?.get('isDarkMode', defaultValue: false) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await _settingsBox?.put('isDarkMode', value);
  }
}