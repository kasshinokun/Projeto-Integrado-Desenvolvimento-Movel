// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider';
import 'package:rent_a_house/services/authservices.dart';
import 'dart:io'; // Para usar Image.file
import 'package:rent_a_house/screens/my_houses_screen.dart'; // Import MyHousesScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // Acessa o AuthService para obter o usuário logado e reagir a mudanças
    final authService = Provider.of<AuthService>(context);
    final user = authService.usuario;

    // Obter informações do usuário ou usar placeholders se não estiver logado
    String userName = user?.displayName ?? 'Usuário Não Logado';
    String userEmail = user?.email ?? 'N/A';
    String userStatus = user != null && !user.isAnonymous
        ? 'Logado'
        : 'Não Logado / Anônimo';
    String? userPhotoPath = user?.photoURL; // Caminho local da foto de perfil
    // Adiciona debug prints para verificar o estado do usuário
    debugPrint('ProfileScreen: Usuário atual: ${user?.email ?? 'N/A'}, isAnonymous: ${user?.isAnonymous}');
    debugPrint('ProfileScreen: photoURL: ${userPhotoPath}');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Seção do Cabeçalho do Perfil (Cartão de informações do usuário)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Cor de fundo do cartão do perfil
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    // Usar Image.file se o photoURL for um caminho de arquivo local e o arquivo existir
                    backgroundImage: (userPhotoPath != null && File(userPhotoPath).existsSync())
                        ? FileImage(File(userPhotoPath)) as ImageProvider
                        : const AssetImage("assets/app/user.png"), // Fallback para asset local ou padrão
                    child: (userPhotoPath == null || !File(userPhotoPath).existsSync())
                        ? const Icon(Icons.person, size: 60, color: Colors.blue)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    label: Text('Status: $userStatus', style: const TextStyle(color: Colors.white)),
                    backgroundColor: userStatus == 'Logado' ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Condicionalmente exibe "Registrar Novo Imóvel" APENAS se o usuário NÃO for anônimo
            (user != null && !user.isAnonymous)? // Verifica se o user não é nulo E não é anônimo
              Column(
                children: [
            
                // Seção de Acesso Rápido (ícones clicáveis)
                const Text(
                  'Acesso Rápido',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAccessItem(Icons.settings, "Geral", Colors.orange, () => _showSnackBar(context, "Funcionalidade de Configurações Gerais")),
                      const SizedBox(width: 20),
                      _buildQuickAccessItem(Icons.house, "Meus Imóveis", Colors.green, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyHousesScreen()),
                        );
                      }),
                      const SizedBox(width: 20),
                      _buildQuickAccessItem(Icons.receipt_long, "Meus Aluguéis", Colors.pinkAccent, () => _showSnackBar(context, "Funcionalidade de Ver Meus Aluguéis")),
                      const SizedBox(width: 20),
                      _buildQuickAccessItem(Icons.account_balance_wallet, "Minha Conta", Colors.blue, () => _showSnackBar(context, "Funcionalidade de Gerenciar Conta")),
                      const SizedBox(width: 20),
                      _buildQuickAccessItem(Icons.analytics, "Dados e Estatísticas", Colors.purple, () => _showSnackBar(context, "Funcionalidade de Ver Dados e Estatísticas")),
                      const SizedBox(width: 20),
                      _buildQuickAccessItem(Icons.security, "Segurança", Colors.black, () => _showSnackBar(context, "Funcionalidade de Configurações de Segurança")),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Seção de Ações da Conta (botões/cartões de menu)
                const Text(
                  'Ações da Conta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                _buildActionCard(
                  icon: Icons.person_outline,
                  title: 'Atualizar Nome de Usuário',
                  onTap: () => _showSnackBar(context, "Funcionalidade de mudar nome"),
                ),
                _buildActionCard(
                  icon: Icons.vpn_key_outlined,
                  title: 'Mudar Senha',
                  onTap: () => _showSnackBar(context, "Funcionalidade de mudar senha"),
                ),
                _buildActionCard(
                  icon: Icons.email_outlined,
                  title: 'Mudar Email',
                  onTap: () => _showSnackBar(context, "Funcionalidade de mudar email"),
                ),
                _buildActionCard(
                  icon: Icons.house_siding,
                  title: 'Registrar Novo Imóvel',
                  onTap: () {
                    Navigator.pushNamed(context, '/registerhouse'); // Navegação para a tela de registro de imóvel
                  },
                ),
                _buildActionCard(
                  icon: Icons.house_siding,
                  title: 'Meus Imóveis',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHousesScreen()),
                    );
                  },
                ),
                _buildActionCard(
                  icon: Icons.list_alt,
                  title: 'Ver Imóveis Alugados',
                  onTap: () => _showSnackBar(context, "Funcionalidade de ver casas alugadas"),
                ),
                const SizedBox(height: 20),

                // Seção de Ações Perigosas (exclusão de conta)
                const Text(
                  'Zona de Perigo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                _buildActionCard(
                  icon: Icons.delete_forever,
                  title: 'Excluir Conta',
                  color: Colors.red.shade700,
                  onTap: () => _showSnackBar(context, "Funcionalidade de excluir conta (requer confirmação)"),
                ),
            
              ],
            ):Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "Favor fazer Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.blueGrey,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
