import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importar FirebaseAuth para gerenciar usuários

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser; // Variável para armazenar o usuário atualmente autenticado

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser; // Obter o usuário logado no início
    // Escutar as mudanças no estado de autenticação para atualizar a UI dinamicamente
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user; // Atualizar o usuário quando o estado de autenticação mudar
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obter informações do usuário ou usar placeholders se não estiver logado
    String userName = _currentUser?.displayName ?? 'Usuário Não Logado';
    String userEmail = _currentUser?.email ?? 'N/A';
    String userStatus = _currentUser != null && !_currentUser!.isAnonymous
        ? 'Logado'
        : 'Não Logado / Anônimo';
    String userPhotoUrl = _currentUser?.photoURL ?? ''; // URL da foto de perfil do usuário

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Cor da barra de aplicativo
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding geral para o conteúdo da tela
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centraliza os elementos na coluna
          children: [
            // Seção do Cabeçalho do Perfil (Cartão de informações do usuário)
            Container(
              width: double.infinity, // Ocupa a largura total disponível
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.blue, // Cor de fundo do cartão do perfil
                borderRadius: BorderRadius.circular(15), // Bordas arredondadas
                boxShadow: [
                  BoxShadow(
                   
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // Adiciona sombra para um efeito de elevação
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50, // Tamanho do avatar
                    backgroundColor: Colors.white, // Cor de fundo do avatar
                    backgroundImage: userPhotoUrl.isNotEmpty
                        ? NetworkImage(userPhotoUrl) // Carrega a imagem da rede se houver URL
                        : const AssetImage("assets/app/user.jpg") as ImageProvider, // Fallback para asset local
                    child: userPhotoUrl.isEmpty && _currentUser != null
                        ? const Icon(Icons.person, size: 60, color: Colors.blue) // Ícone placeholder se não houver imagem
                        : null,
                  ),
                  const SizedBox(height: 10), // Espaçamento vertical
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Cor do texto do nome
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8), // Cor do texto do email com opacidade
                    ),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    label: Text('Status: $userStatus', style: const TextStyle(color: Colors.white)),
                    backgroundColor: userStatus == 'Logado' ? Colors.green : Colors.red, // Cor do chip baseada no status
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Espaçamento entre seções

            // Seção de Acesso Rápido (ícones clicáveis)
            const Text(
              'Acesso Rápido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Permite rolagem horizontal
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribui os itens uniformemente
                children: [
                  _buildQuickAccessItem(Icons.settings, "Geral", Colors.orange, () => _showSnackBar("Funcionalidade de Configurações Gerais")),
                  const SizedBox(width: 20), // Espaçamento horizontal entre os itens
                  _buildQuickAccessItem(Icons.house, "Meus Imóveis", Colors.green, () => _showSnackBar("Funcionalidade de Ver Meus Imóveis")),
                  const SizedBox(width: 20),
                  _buildQuickAccessItem(Icons.receipt_long, "Meus Aluguéis", Colors.pinkAccent, () => _showSnackBar("Funcionalidade de Ver Meus Aluguéis")),
                  const SizedBox(width: 20),
                  _buildQuickAccessItem(Icons.account_balance_wallet, "Minha Conta", Colors.blue, () => _showSnackBar("Funcionalidade de Gerenciar Conta")),
                  const SizedBox(width: 20),
                  _buildQuickAccessItem(Icons.analytics, "Dados e Estatísticas", Colors.purple, () => _showSnackBar("Funcionalidade de Ver Dados e Estatísticas")),
                  const SizedBox(width: 20),
                  _buildQuickAccessItem(Icons.security, "Segurança", Colors.black, () => _showSnackBar("Funcionalidade de Configurações de Segurança")),
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
              onTap: () => _showSnackBar("Funcionalidade de mudar nome"),
            ),
            _buildActionCard(
              icon: Icons.vpn_key_outlined,
              title: 'Mudar Senha',
              onTap: () => _showSnackBar("Funcionalidade de mudar senha"),
            ),
            _buildActionCard(
              icon: Icons.email_outlined,
              title: 'Mudar Email',
              onTap: () => _showSnackBar("Funcionalidade de mudar email"),
            ),
            _buildActionCard(
              icon: Icons.house_siding,
              title: 'Registrar Novo Imóvel',
              onTap: () {
                Navigator.pushNamed(context, '/registerhouse'); // Navegação para a tela de registro de imóvel
              },
            ),
            _buildActionCard(
              icon: Icons.list_alt,
              title: 'Ver Imóveis Alugados',
              onTap: () => _showSnackBar("Funcionalidade de ver casas alugadas"),
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
              color: Colors.red.shade700, // Cor de destaque para ação perigosa
              onTap: () => _showSnackBar("Funcionalidade de excluir conta (requer confirmação)"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para construir itens de acesso rápido (ícone + texto)
  Widget _buildQuickAccessItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, // Ação ao tocar no item
      borderRadius: BorderRadius.circular(10), // Efeito visual ao tocar
      child: Column(
        children: [
          CircleAvatar(
            radius: 30, // Tamanho do círculo
            
            backgroundColor: color.withValues(alpha: 0.2), // Cor de fundo do círculo com opacidade
            child: Icon(icon, size: 30, color: color), // Ícone centralizado
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

  // Widget auxiliar para construir cartões de ação (com ícone, título e seta)
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.blueGrey, // Cor padrão do ícone
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      elevation: 3, // Sombra do cartão
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bordas arredondadas
      child: InkWell(
        onTap: onTap, // Ação ao tocar no cartão
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 28, color: color), // Ícone principal
              const SizedBox(width: 15), // Espaçamento
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]), // Seta indicando ação
            ],
          ),
        ),
      ),
    );
  }

  // Função auxiliar para exibir uma SnackBar (mensagem temporária)
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
