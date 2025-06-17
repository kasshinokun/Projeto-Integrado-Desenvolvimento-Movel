// --- Sample Data ---
import 'package:rent_a_house/pages/test/category/modelcategory/pageitem.dart';
import 'package:rent_a_house/pages/test/category/modelcategory/category.dart';

// You would typically fetch this data from an API or local database
final List<Category> sampleCategories = [
  Category(
    id: 'cat1',
    name: 'Electronics',
    items: List.generate(
      8,
      (index) => PageItem(
        id: 'e$index',
        title: 'Electronic Gadget ${index + 1}',
        content:
            'Explore the features of Electronic Gadget ${index + 1}. This item is known for its cutting-edge technology and sleek design.',
      ),
    ),
  ),
  Category(
    id: 'cat2',
    name: 'Books',
    items: List.generate(
      5,
      (index) => PageItem(
        id: 'b$index',
        title: 'Bestselling Book ${index + 1}',
        content:
            'Dive into the world of Bestselling Book ${index + 1}. A captivating story that will keep you hooked from start to finish.',
      ),
    ),
  ),
  Category(
    id: 'cat3',
    name: 'Apparel',
    items: List.generate(
      12,
      (index) => PageItem(
        id: 'c$index',
        title: 'Fashion Wear ${index + 1}',
        content:
            'Check out the latest trends with Fashion Wear ${index + 1}. Comfortable, stylish, and perfect for any occasion.',
      ),
    ),
  ),
  Category(
    id: 'cat4',
    name: 'Home & Kitchen',
    items: List.generate(
      6,
      (index) => PageItem(
        id: 'h$index',
        title: 'Kitchen Appliance ${index + 1}',
        content:
            'Make your life easier with Kitchen Appliance ${index + 1}. Durable, efficient, and a must-have for modern homes.',
      ),
    ),
  ),
  Category(
    id: 'cat5',
    name: 'Sports Gear',
    items: List.generate(
      7,
      (index) => PageItem(
        id: 's$index',
        title: 'Pro Sports Equipment ${index + 1}',
        content:
            'Elevate your game with Pro Sports Equipment ${index + 1}. Designed for performance and durability.',
      ),
    ),
  ),
  Category(
    id: 'cat6',
    name: 'Toys & Games',
    items: [], // Example of a category with no items initially
  ),
  Category(
    id: 'cat7',
    name: 'Beauty & Personal Care',
    items: List.generate(
      4,
      (index) => PageItem(
        id: 'bp$index',
        title: 'Skincare Product ${index + 1}',
        content:
            'Pamper yourself with Skincare Product ${index + 1}. Natural ingredients for radiant skin.',
      ),
    ),
  ),
];
