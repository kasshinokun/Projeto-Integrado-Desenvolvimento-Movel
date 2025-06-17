//Bibliotecas Padrão
import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/test/category/sampledata/sampledata.dart';
import 'package:rent_a_house/pages/test/category/modelcategory/category.dart';

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
        appBar: AppBar(
          title: Text('Categories & Items'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/auth');
                Navigator.popAndPushNamed(context, '/auth');
              },
              icon: Icon(Icons.home),
            ),
          ],
        ),
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
