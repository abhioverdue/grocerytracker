import 'package:hive/hive.dart';

part 'grocery_item.g.dart';

@HiveType(typeId: 0)
class GroceryItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime expiryDate;

  @HiveField(2)
  String id;

  GroceryItem({
    required this.name,
    required this.expiryDate,
    required this.id,
  });

  int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(today).inDays;
  }

  ExpiryStatus get status {
    final days = daysLeft;
    if (days < 0) return ExpiryStatus.expired;
    if (days == 0) return ExpiryStatus.expiringToday;
    if (days == 1) return ExpiryStatus.expiringSoon;
    if (days <= 3) return ExpiryStatus.warning;
    return ExpiryStatus.safe;
  }
}

enum ExpiryStatus {
  expired,
  expiringToday,
  expiringSoon,
  warning,
  safe,
}