import 'package:eval/class/recipe.dart';
import 'package:eval/class/recipeCategory.dart';
import 'package:eval/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: recipeCategories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Recettes"),
          bottom: TabBar(
            tabs: recipeCategories
                .map((category) => Tab(text: category.name))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: recipeCategories
              .map((category) => RecipeCategoryWidget(category: category))
              .toList(),
        ),
      ),
    );
  }
}

class RecipeCategoryWidget extends StatelessWidget {
  final RecipeCategory category;

  RecipeCategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: category.recipes.length,
      itemBuilder: (context, index) {
        var recipe = category.recipes[index];
        return RecipeWidget(recipe: recipe);
      },
    );
  }
}

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;

  const RecipeWidget({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    bool canAfford = appState.canAffordRecipe(recipe);
    int inventoryQuantity = appState.inventory.getQuantity(recipe);
    bool isUniqueAndAlreadyBought =
        appState.inventory.isUniqueAndAlreadyBought(recipe);

    Map<GameplayType, String> buttonText = {
      GameplayType.tool: "Fabriquer",
      GameplayType.building: "Construire",
      GameplayType.material: "Produire",
      GameplayType.component: "Fabriquer",
    };

    return ListTile(
      title: Text(recipe.name),
      subtitle: Text("${recipe.description}\nCoût: ${recipe.cost}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              !recipe.isUnique ? "Dans l'inventaire : $inventoryQuantity" : ""),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: canAfford && !isUniqueAndAlreadyBought
                ? () {
                    appState.produceItem(recipe);
                  }
                : null,
            child: Text(isUniqueAndAlreadyBought
                ? "Déjà acheté"
                : buttonText[recipe.gameplayType]!),
          ),
        ],
      ),
    );
  }
}
