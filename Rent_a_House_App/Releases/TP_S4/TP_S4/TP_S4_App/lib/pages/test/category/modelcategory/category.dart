// --- Data Models ---
import 'package:rent_a_house/pages/test/category/modelcategory/pageitem.dart';

// Represents a category that contains a list of PageItems
class Category {
  final String id;
  final String name;
  final List<PageItem> items;

  Category({required this.id, required this.name, required this.items});
}
