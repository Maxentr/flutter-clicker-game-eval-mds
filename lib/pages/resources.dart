import 'package:eval/class/resource.dart';
import 'package:eval/main.dart';
import 'package:eval/pages/inventory.dart';
import 'package:eval/pages/recipes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourcesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ressources"),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipesPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.inventory),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InventoryPage()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          var resource = resources[index];
          return ResourceWidget(resource: resource);
        },
      ),
    );
  }
}

class ResourceWidget extends StatelessWidget {
  final Resource resource;
  late Color textColor;

  ResourceWidget({required this.resource}) {
    textColor =
        resource.color.computeLuminance() > 0.2 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return InkWell(
      onTap: () {
        appState.collectResource(resource);
      },
      child: Container(
        color: resource.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(resource.name, style: TextStyle(color: textColor)),
            Text(resource.description, style: TextStyle(color: textColor)),
            Text("Quantité: ${resource.quantity}",
                style: TextStyle(color: textColor)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                appState.collectResource(resource);
              },
              child: Text("Miner"),
            ),
          ],
        ),
      ),
    );
  }
}
