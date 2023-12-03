import 'package:eval/class/inventory.dart';
import 'package:eval/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventaire"),
      ),
      body: ListView.builder(
        itemCount: appState.inventory.items.length,
        itemBuilder: (context, index) {
          var inventoryItem = appState.inventory.items[index];
          return InventoryItemWidget(inventoryItem: inventoryItem);
        },
      ),
    );
  }
}

class InventoryItemWidget extends StatelessWidget {
  final InventoryItem inventoryItem;

  InventoryItemWidget({required this.inventoryItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(inventoryItem.recipe.name),
      subtitle: Text("Quantité : ${inventoryItem.quantity}"),
    );
  }
}
