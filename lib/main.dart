import 'package:eval/class/inventory.dart';
import 'package:eval/class/recipe.dart';
import 'package:eval/class/recipeCategory.dart';
import 'package:eval/class/resource.dart';
import 'package:eval/pages/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(MyApp());
}

final List<Resource> resources = [
  Resource(
      "Bois", "wood", ResourceType.other, 0, Color(0xFF967969), "Du bois brut"),
  Resource("Minerai de fer brut", "raw_iron", ResourceType.ore, 0,
      Color(0xFFCED4DA), "Du minerai de fer brut", "iron_ingot"),
  Resource("Minerai de cuivre brut", "raw_copper", ResourceType.ore, 0,
      Color(0xFFD9480F), "Du minerai de cuivre brut", "copper_ingot"),
  Resource("Charbon", "coal", ResourceType.ore, 0, Color(0xFF000000),
      "Du minerai de charbon"),
];

final List<RecipeCategory> recipeCategories = [
  RecipeCategory(
    "Matériaux et Composants",
    "materials_and_components",
    [
      Recipe("Lingot de fer", "iron_ingot", {"raw_iron": 1},
          GameplayType.material, "Un lingot de fer pur"),
      Recipe("Plaque de fer", "iron_plate", {"raw_iron": 3},
          GameplayType.material, "Une plaque de fer pour la construction", 2),
      Recipe("Lingot de cuivre", "copper_ingot", {"raw_copper": 1},
          GameplayType.material, "Un lingot de cuivre pur"),
      Recipe("Tige en métal", "iron_rod", {"iron_ingot": 1},
          GameplayType.material, "Une tige de métal"),
      Recipe(
          "Fil électrique",
          "electric_wire",
          {"copper_ingot": 1},
          GameplayType.component,
          "Un fil électrique pour fabriquer des composants électroniques"),
    ],
  ),
  RecipeCategory(
    "Outils",
    "tools",
    [
      Recipe("Hache", 'axe', {"wood": 2, "iron_rod": 2}, GameplayType.tool,
          "Un outil utile"),
      Recipe("Pioche", 'pickaxe', {"wood": 2, "iron_rod": 3}, GameplayType.tool,
          "Un outil utile"),
    ],
  ),
  RecipeCategory(
    "Bâtiments",
    "buildings",
    [
      Recipe(
          "Mine",
          "mine",
          {"iron_plate": 10, "electric_wire": 5},
          GameplayType.building,
          "Permet de transformer automatiquement d'extraire du minerai de fer ou cuivre"),
      Recipe(
          "Fonderie",
          "factory",
          {"electric_wire": 5, "iron_rod": 8},
          GameplayType.building,
          "Permet de transformer automatiquement du minerai de fer ou cuivre en lingot de fer ou cuivre"),
    ],
  ),
];

class AppState with ChangeNotifier {
  Inventory inventory = Inventory();

  void collectResource(Resource resource) {
    bool isCollectingWoodWithAxe =
        resource.key == "wood" && inventory.contains("axe");
    bool isCollectingOreWithPickaxe =
        resource.type == ResourceType.ore && inventory.contains("pickaxe");

    if (isCollectingWoodWithAxe || isCollectingOreWithPickaxe) {
      resource.quantity += 5;
    } else {
      resource.quantity++;
    }
    notifyListeners();
  }

  bool canAffordRecipe(Recipe recipe) {
    for (var entry in recipe.cost.entries) {
      Resource? resource =
          resources.firstWhereOrNull((r) => r.key == entry.key);
      InventoryItem? inventoryItem =
          inventory.items.firstWhereOrNull((i) => i.recipe.key == entry.key);

      if (resource != null && resource.quantity >= entry.value) {
        break;
      } else if (inventoryItem != null &&
          inventoryItem.quantity >= entry.value) {
        break;
      } else {
        return false;
      }
    }

    return true;
  }

  void removeCost(Recipe recipe) {
    for (var entry in recipe.cost.entries) {
      Resource? resource =
          resources.firstWhereOrNull((r) => r.key == entry.key);
      if (resource != null) {
        resource.quantity -= entry.value;
      }

      InventoryItem? inventoryItem =
          inventory.items.firstWhereOrNull((i) => i.recipe.key == entry.key);
      if (inventoryItem != null) {
        inventoryItem.quantity -= entry.value;
      }
    }
  }

  void produceItem(Recipe recipe) {
    if (canAffordRecipe(recipe)) {
      inventory.addRecipe(recipe);
      removeCost(recipe);
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        home: ResourcesPage(),
      ),
    );
  }
}
