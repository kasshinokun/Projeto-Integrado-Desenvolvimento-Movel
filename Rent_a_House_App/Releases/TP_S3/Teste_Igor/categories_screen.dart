import 'package:flutter/material.dart';
import '../services/local_database_service.dart';
import '../models/category_model.dart';
import '../widgets/product_item_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with SingleTickerProviderStateMixin {
  List<CategoryModel> _categories = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await LocalDatabaseService.instance.getAllCategoriesWithItems();
    setState(() {
      _categories = categories;
      _tabController = TabController(length: categories.length, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null || _categories.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((c) => Tab(text: c.name)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return ListView.builder(
            itemCount: category.productItems.length,
            itemBuilder: (_, index) => ProductItemCard(productItem: category.productItems[index]),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
