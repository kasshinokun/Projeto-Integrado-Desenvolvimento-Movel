// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:rent_a_house/screens/connection_pannel_screen.dart';
import 'package:rent_a_house/screens/house_screen.dart';
import 'package:rent_a_house/services/authservices.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/providers/housesprovider.dart';
import 'package:rent_a_house/screens/profile_screen.dart';
import 'package:rent_a_house/screens/conversations_screen.dart'; // Importe sua ConversationsScreen

// Placeholder para as telas que ainda não foram definidas ou importadas
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late PageController _pageController;

  TabController? _tabController;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _page);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final housesProvider = Provider.of<HousesProvider>(context);

    if (!housesProvider.isLoading && housesProvider.error == null) {
      final List<String> newCategories = housesProvider.categorizedHouses.keys.toList();
      if (_tabController == null || _tabController!.length != newCategories.length) {
        _tabController?.dispose();
        if (newCategories.isNotEmpty) {
          _tabController = TabController(length: newCategories.length, vsync: this);
        } else {
          _tabController = null;
        }
        _categories = newCategories;
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.usuario; // O usuário logado (real ou FakeUser)
    final housesProvider = Provider.of<HousesProvider>(context);

    // Constrói a HouseScreen com base nos dados e controller, ou mostra loading/erro/vazio
    Widget houseScreenContent;
    if (housesProvider.isLoading || housesProvider.error != null || _tabController == null || _categories.isEmpty) {
      houseScreenContent = Scaffold(
        appBar: AppBar(title: Text(housesProvider.isLoading ? 'Carregando Imóveis...' : 'Erro/Sem Imóveis')),
        body: Center(
          child: housesProvider.isLoading
              ? const CircularProgressIndicator()
              : housesProvider.error != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${housesProvider.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => housesProvider.listenToHouses(),
                          child: const Text("Tentar Novamente"),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Nenhum imóvel disponível no momento.'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => housesProvider.listenToHouses(),
                          child: const Text("Atualizar"),
                        ),
                      ],
                    ),
        ),
      );
    } else {
      houseScreenContent = HouseScreen(
        tabController: _tabController!,
        categories: _categories,
        categorizedHouses: housesProvider.categorizedHouses,
        housesProvider: housesProvider,
      );
    }

    final List<Widget> _widgetOptions = [
      houseScreenContent, // Home com as casas
      const PlaceholderScreen(title: "Alugar Casa"),
      ProfileScreen(),
      const PlaceholderScreen(title: "Ajustes do Aplicativo"),
      // NOVO: Chama ConversationsScreen passando o UID do usuário atual
      ConversationsScreen(currentUserUid: user?.uid),
      const PlaceholderScreen(title: "Pagamentos Pix"),
      const ConnectionPannelScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Bem-vindo, ${user?.email ?? 'Cliente'}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair da conta',
            onPressed: () {
              authService.signOutUser();
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: _widgetOptions,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        color: const Color.fromARGB(255, 185, 156, 233),
        buttonBackgroundColor: Colors.amberAccent,
        backgroundColor:Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.house_outlined),
            label: 'Alugar',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person_outlined),
            label: 'Perfil',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.settings_applications_sharp),
            label: 'Ajustes',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat_outlined),
            label: 'Chat',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.pix),
            label: 'Pix',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.signal_cellular_alt),
            label: 'Status',
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            );
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
