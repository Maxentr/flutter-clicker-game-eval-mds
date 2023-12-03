enum GameplayType {
  tool,
  material,
  building,
  component,
}

class Recipe {
  String name;
  String key;
  Map<String, int> cost;
  GameplayType gameplayType;
  String description;
  int quantity;
  late bool isUnique;

  Recipe(this.name, this.key, this.cost, this.gameplayType, this.description,
      [this.quantity = 1]) {
    isUnique = gameplayType == GameplayType.tool ||
        gameplayType == GameplayType.building;
  }
}
