import 'package:flutter/material.dart';

enum ResourceType { ore, other }

class Resource {
  String name;
  String key;
  ResourceType type;
  int quantity;
  Color color;
  String description;
  String? smeltIntoRecipeKey;

  Resource(this.name, this.key, this.type, this.quantity, this.color,
      this.description,
      [this.smeltIntoRecipeKey = null]);
}
