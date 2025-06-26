import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grocery_provider.dart';
import '../widgets/grocery_item_card.dart';
import 'add_item_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroceryProvider>(
      builder: (context, provider, child) {
        return Scaffold(
  appBar: AppBar(
    title: const Text(
      'Grocery Tracker',
      style: TextStyle(
        fontSize: 24,            
        fontWeight: FontWeight.bold, 
        color: Color.fromARGB(255, 44, 35, 35),     
        letterSpacing: 1.2,      
        fontFamily: 'Times New Roman',    
      ),
    ),
    backgroundColor: Colors.green[700], // Custom AppBar color
    actions: [
      IconButton(
        icon: Icon(provider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
        onPressed: provider.toggleDarkMode,
      ),
    ],

          ),
          body: provider.items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No grocery items added yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap the + button to add your first item',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.sortedItems.length,
                  itemBuilder: (context, index) {
                    final item = provider.sortedItems[index];
                    return GroceryItemCard(
                      item: item,
                      onDelete: () => provider.deleteItem(item.id),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddItemScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}