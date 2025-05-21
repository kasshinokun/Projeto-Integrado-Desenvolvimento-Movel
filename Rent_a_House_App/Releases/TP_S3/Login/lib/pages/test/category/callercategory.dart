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
        //----------------------------------------------------
        //Compatibilidade com Flutter SDK 3.3.2
        tabBarTheme: TabBarThemeData(
          //Teste TabBarThemeData
          labelColor: Colors.white,
          unselectedLabelColor: Colors.deepOrange[100],
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.deepOrange[700],
          ),
        ),
        //-----------------------------------------------------
        /*Código original antes do flutter 3.3.2        
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
        */
        //----------------------------------------------------
        //Compatibilidade com Flutter SDK 3.3.2
        //Testar
        cardTheme: CardThemeData(
          // Changed CardTheme to CardThemeData
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        //-----------------------------------------------------
        /*Código original antes do flutter 3.3.2   
        cardTheme: CardTheme(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),*/
      ),
      home: const CategoriesWithPagesTabView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
