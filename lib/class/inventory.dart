import 'package:eval/class/recipe.dart';
import 'package:collection/collection.dart';

class InventoryItem {
  Recipe recipe;
  int quantity;

  InventoryItem(this.recipe, this.quantity);
}

class Inventory {
  List<InventoryItem> items = [];

  void addRecipe(Recipe recipe, [int? customQuantity]) {
    var quantity = customQuantity ?? recipe.quantity;
    var inventoryItem = getItem(recipe);

    if (inventoryItem != null) {
      inventoryItem.quantity += quantity;
    } else {
      inventoryItem = InventoryItem(recipe, quantity);
      items.add(inventoryItem);
    }
  }

  bool isUniqueAndAlreadyBought(Recipe recipe) {
    var inventoryItem = getItem(recipe);

    if (inventoryItem != null) {
      return inventoryItem.recipe.isUnique;
    } else {
      return false;
    }
  }

  int getQuantity(Recipe recipe) {
    var inventoryItem = getItem(recipe);

    if (inventoryItem != null) {
      return inventoryItem.quantity;
    } else {
      return 0;
    }
  }

  bool contains(String recipeKey) {
    var inventoryItem = getItemByKey(recipeKey);

    return inventoryItem != null;
  }

  InventoryItem? getItem(Recipe recipe) {
    return items.firstWhereOrNull((i) => i.recipe.key == recipe.key);
  }

  InventoryItem? getItemByKey(String recipeKey) {
    return items.firstWhereOrNull((i) => i.recipe.key == recipeKey);
  }
}
