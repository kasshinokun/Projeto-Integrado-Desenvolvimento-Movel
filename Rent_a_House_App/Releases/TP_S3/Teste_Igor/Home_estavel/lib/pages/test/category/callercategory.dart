import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/test/category/pagecaller/categorypage.dart';

// --- Main Application Widget ---
void main() {
  runApp(CallerCategory());
}

class CallerCategory extends StatelessWidget {
  const CallerCategory({super.key});

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
        tabBarTheme: TabBarTheme(
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
        cardTheme: CardTheme(
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
