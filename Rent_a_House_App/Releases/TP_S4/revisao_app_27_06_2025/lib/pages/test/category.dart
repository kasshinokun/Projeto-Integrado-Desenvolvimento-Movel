import 'package:flutter/material.dart';

// --- Data Models ---
// Represents an individual item/page within a category
class PageItem {
  final String id;
  final String title;
  final String content; // Example content for the item

  PageItem({required this.id, required this.title, required this.content});
}

// Represents a category that contains a list of PageItems
class Category {
  final String id;
  final String name;
  final List<PageItem> items;

  Category({required this.id, required this.name, required this.items});
}

// --- Sample Data ---
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

// --- Main Application Widget ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Categories Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Changed theme color for a different look
        scaffoldBackgroundColor: Colors.grey[100], // Light grey background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal, // AppBar color
          elevation: 0, // Flat app bar
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: Colors.white, // Selected tab text color
          unselectedLabelColor: Colors.teal[100], // Unselected tab text color
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            // Custom indicator
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.teal[700], // Darker shade for indicator
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CategoriesWithPagesTabView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- Categories and Pages View Widget ---
class CategoriesWithPagesTabView extends StatefulWidget {
  const CategoriesWithPagesTabView({super.key});

  @override
  State<CategoriesWithPagesTabView> createState() =>
      _CategoriesWithPagesTabViewState();
}

class _CategoriesWithPagesTabViewState extends State<CategoriesWithPagesTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Category> _categories = sampleCategories; // Using the sample data

  @override
  void initState() {
    super.initState();
    // Initialize the TabController
    // It requires the number of tabs and a TickerProvider (vsync: this)
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    // Dispose the TabController when the widget is removed from the tree
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Handle case where there are no categories
    if (_categories.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Categories & Items')),
        body: const Center(
          child: Text('No categories available at the moment.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Categories'),
        // The TabBar widget displays the horizontal list of category tabs
        bottom: TabBar(
          controller: _tabController,
          isScrollable:
              true, // Allows horizontal scrolling if tabs exceed screen width
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ), // Padding around tabs
          tabs:
              _categories.map((Category category) {
                // Each tab is created from a category name
                return Tab(
                  child: Text(
                    category.name,
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
        ),
      ),
      // TabBarView displays the content for the currently selected tab
      body: TabBarView(
        controller: _tabController,
        children:
            _categories.map((Category category) {
              // This is the "ListView of pages/items" for each category

              // Handle case where a category has no items
              if (category.items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No items currently available in ${category.name}.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                );
              }

              // Build a ListView for the items in the current category
              return ListView.builder(
                key: PageStorageKey(
                  category.id,
                ), // Helps preserve scroll position when switching tabs
                padding: const EdgeInsets.all(8.0), // Padding for the list
                itemCount: category.items.length,
                itemBuilder: (context, index) {
                  final item = category.items[index];
                  return Card(
                    // Using Card for better visual separation of items
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          item.content,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      onTap: () {
                        // Action to perform when an item is tapped
                        // For example, navigate to a detail screen or show a dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Tapped on ${item.title} in ${category.name}',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}
