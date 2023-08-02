import 'package:book_library_app_ui/data/categories.dart';
import 'package:book_library_app_ui/models/category.dart';
import 'package:book_library_app_ui/models/grocery_items.dart';
// import 'package:book_library_app_ui/models/grocery_items.dart';

final groceryItems = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),
];
