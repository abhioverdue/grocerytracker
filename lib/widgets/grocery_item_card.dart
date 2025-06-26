import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/grocery_item.dart';

class GroceryItemCard extends StatelessWidget {
  final GroceryItem item;
  final VoidCallback onDelete;

  const GroceryItemCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  Color _getStatusColor(ExpiryStatus status) {
    switch (status) {
      case ExpiryStatus.expired:
        return Colors.red;
      case ExpiryStatus.expiringToday:
        return Colors.orange;
      case ExpiryStatus.expiringSoon:
        return Colors.amber;
      case ExpiryStatus.warning:
        return Colors.yellow[700]!;
      case ExpiryStatus.safe:
        return Colors.green;
    }
  }

  String _getStatusText(ExpiryStatus status, int daysLeft) {
    switch (status) {
      case ExpiryStatus.expired:
        return 'Expired ${daysLeft.abs()} day${daysLeft.abs() == 1 ? '' : 's'} ago';
      case ExpiryStatus.expiringToday:
        return 'Expires today';
      case ExpiryStatus.expiringSoon:
        return 'Expires tomorrow';
      case ExpiryStatus.warning:
        return 'Expires in $daysLeft days';
      case ExpiryStatus.safe:
        return 'Expires in $daysLeft days';
    }
  }

  IconData _getStatusIcon(ExpiryStatus status) {
    switch (status) {
      case ExpiryStatus.expired:
        return Icons.dangerous;
      case ExpiryStatus.expiringToday:
      case ExpiryStatus.expiringSoon:
        return Icons.warning;
      case ExpiryStatus.warning:
        return Icons.schedule;
      case ExpiryStatus.safe:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = item.status;
    final statusColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Icon(
            _getStatusIcon(status),
            color: Colors.white,
          ),
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: status == ExpiryStatus.expired 
                ? TextDecoration.lineThrough 
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expiry: ${DateFormat('MMM dd, yyyy').format(item.expiryDate)}'),
            const SizedBox(height: 4),
            Text(
              _getStatusText(status, item.daysLeft),
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Delete Item'),
                  content: Text('Are you sure you want to delete "${item.name}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete();
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          },
        ),
        isThreeLine: true,
      ),
    );
  }
}