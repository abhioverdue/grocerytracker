import 'package:flutter/material.dart';
import '../models/grocery_item.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class GroceryProvider extends ChangeNotifier {
  List<GroceryItem> _items = [];
  bool _isDarkMode = false;

  List<GroceryItem> get items => _items;
  bool get isDarkMode => _isDarkMode;

  GroceryProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    await StorageService.init();
    _items = StorageService.getAllItems();
    _isDarkMode = StorageService.isDarkMode;
    notifyListeners();
    
    // Schedule notifications for existing items
    await NotificationService.scheduleAllNotifications(_items);
  }

  Future<void> addItem(String name, DateTime expiryDate) async {
    final item = GroceryItem(
      name: name,
      expiryDate: expiryDate,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    
    await StorageService.addItem(item);
    _items.add(item);
    notifyListeners();
    
    // Schedule notification for this item
    await NotificationService.scheduleExpiryNotification(item);
  }

  Future<void> deleteItem(String id) async {
    await StorageService.deleteItem(id);
    await NotificationService.cancelNotification(id.hashCode);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  List<GroceryItem> get sortedItems {
    final sorted = List<GroceryItem>.from(_items);
    sorted.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
    return sorted;
  }
}