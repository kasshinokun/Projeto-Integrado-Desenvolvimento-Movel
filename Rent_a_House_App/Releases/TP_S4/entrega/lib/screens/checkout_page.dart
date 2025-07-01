// lib/pages/checkout_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatação de moeda e data
import 'package:rent_a_house/providers/housesprovider.dart'; // Importa o modelo House
import 'package:qr_flutter/qr_flutter.dart'; // NOVO: Importa a biblioteca qr_flutter

class CheckoutPage extends StatefulWidget {
  final House house; // Recebe o objeto House completo

  const 
  CheckoutPage({super.key, required this.house});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _pagamentoConfirmado = false;
  String? _codigoPix;
  bool _isGeneratingPix = false; // Estado para controlar o loading do Pix
  String _selectedPaymentMethod = 'Pix'; // NOVO: Estado para a forma de pagamento selecionada

  // NOVO: Variáveis para as datas e controlador para o valor total
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _totalValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _calculateTotalValue(); // Calcula o valor inicial ao carregar a tela
  }

  @override
  void dispose() {
    _totalValueController.dispose();
    super.dispose();
  }

  // NOVO: Função para selecionar a data inicial
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(), // Data inicial não pode ser inferior à data atual
      lastDate: DateTime.now().add(const Duration(days: 365)), // Limite de 1 ano para seleção futura
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // Se a data final for anterior à nova data inicial, ou mais de 30 dias depois, reseta
        if (_endDate != null && (_endDate!.isBefore(_startDate!) || _endDate!.difference(_startDate!).inDays > 30)) {
          _endDate = null;
        }
        _calculateTotalValue();
      });
    }
  }

  // NOVO: Função para selecionar a data final
  Future<void> _selectEndDate(BuildContext context) async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione a Data Inicial primeiro.')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!,
      firstDate: _startDate!, // Data final não pode ser anterior à data inicial
      lastDate: _startDate!.add(const Duration(days: 30)), // Data final no máximo 30 dias após a data inicial
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _calculateTotalValue();
      });
    }
  }

  // NOVO: Função para calcular o valor total do aluguel
  void _calculateTotalValue() {
    if (_startDate != null && _endDate != null) {
      final int rentalDays = _endDate!.difference(_startDate!).inDays + 1; // +1 para incluir o dia final
      final double dailyPrice = widget.house.price; // Assumindo que widget.house.price é o valor diário
      final double totalValue = rentalDays * dailyPrice;
      _totalValueController.text = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalValue);
    } else {
      _totalValueController.text = 'R\$ 0,00';
    }
  }

  void _gerarCodigoPix() async {
    setState(() {
      _isGeneratingPix = true; // Inicia o loading
      _pagamentoConfirmado = false; // Reseta o status de confirmação
      _codigoPix = null; // Limpa o código Pix anterior
    });

    // Simula um delay de rede para a geração do Pix
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // Simula um código Pix gerado (você pode gerar um código mais dinâmico aqui)
      // É importante que este código seja o Pix Copia e Cola real para funcionar!
      _codigoPix = '00020126330014BR.GOV.BCB.PIX0114+558199999999520400005303986540510.005802BR5925${widget.house.name} - ${widget.house.price.toStringAsFixed(2)}6009Sao Paulo62070503***6304ABCD';
      _isGeneratingPix = false; // Finaliza o loading
    });
  }

  void _confirmarPagamento() async {
    if (_pagamentoConfirmado) return; // Evita confirmações duplicadas

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione as datas de início e fim do aluguel.')),
      );
      return;
    }

    setState(() {
      _pagamentoConfirmado = true; // Simula confirmação imediata para a UI
    });

    // Simula um delay para processamento da confirmação (backend real)
    await Future.delayed(const Duration(seconds: 1));

    // Exibe um diálogo de sucesso após a "confirmação"
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false, // Não permite fechar clicando fora
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(width: 10),
                Text('Pagamento Confirmado!', style: TextStyle(color: Colors.green)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Parabéns! O pagamento para o imóvel "${widget.house.name}" foi confirmado com sucesso.'),
                const SizedBox(height: 10),
                Text('O proprietário será notificado.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[700])),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Fecha o diálogo
                  Navigator.of(context).pop(); // Volta para a tela anterior (DetailsScreen)
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Formatador de moeda para o preço
    final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    // Formatador de data
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout de Aluguel'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seção de Detalhes do Imóvel
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.house.name,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Endereço: ${widget.house.address}, ${widget.house.number}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    if (widget.house.complement.isNotEmpty)
                      Text(
                        'Complemento: ${widget.house.complement}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    const SizedBox(height: 15),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // CORREÇÃO: Envolver os Text widgets em Expanded para evitar overflow
                        Expanded( // Garante que este Text ocupe o espaço disponível
                          child: const Text(
                            'Aluguel diário:', // Alterado para 'Aluguel diário'
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis, // Adicionado para lidar com texto longo, se necessário
                          ),
                        ),
                        Expanded( // Garante que este Text ocupe o espaço restante
                          child: Text(
                            currencyFormatter.format(widget.house.price),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                            textAlign: TextAlign.end, // Alinha o preço à direita
                            overflow: TextOverflow.ellipsis, // Adicionado para lidar com texto longo, se necessário
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // NOVO: Seção de Seleção de Datas
            Text(
              'Período do Aluguel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _startDate == null ? '' : dateFormatter.format(_startDate!),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Data Inicial',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectStartDate(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _endDate == null ? '' : dateFormatter.format(_endDate!),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Data Final',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectEndDate(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _totalValueController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Valor Total do Aluguel',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 30),

            // Seção de Pagamento
            Text(
              'Escolha seu método de pagamento',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // NOVO: Dropdown para seleção da forma de pagamento
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPaymentMethod,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple, fontSize: 18),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPaymentMethod = newValue!;
                      // Limpar Pix info se mudar para cartão
                      if (_selectedPaymentMethod == 'Cartão') {
                        _codigoPix = null;
                        _pagamentoConfirmado = false;
                      }
                    });
                  },
                  items: <String>['Pix', 'Cartão']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Renderiza a seção de pagamento Pix APENAS se "Pix" estiver selecionado
            if (_selectedPaymentMethod == 'Pix')
              Column(
                children: [
                  // Botão para Gerar Código Pix
                  ElevatedButton.icon(
                    icon: _isGeneratingPix
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.qr_code, color: Colors.white),
                    label: Text(
                      _isGeneratingPix ? 'Gerando Código...' : 'Gerar Código Pix',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: _isGeneratingPix ? null : _gerarCodigoPix,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 7,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Área de exibição do Código Pix e QR Code
                  if (_codigoPix != null && _codigoPix!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Centraliza o QR Code
                        children: [
                          const Text(
                            'Código Pix para Pagamento:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
                          ),
                          const SizedBox(height: 10),
                          SelectableText(
                            _codigoPix!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontFamily: 'monospace', // Fonte monoespaçada para o código
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Exibe o QR Code
                          Container(
                            color: Colors.white, // Fundo branco para o QR Code
                            padding: const EdgeInsets.all(8.0),
                            child: QrImageView(
                              data: _codigoPix!, // A string que será codificada no QR Code
                              version: QrVersions.auto,
                              size: 200.0, // Tamanho do QR Code
                              gapless: true, // Remove a margem extra ao redor do QR Code
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: _pagamentoConfirmado
                                ? const Icon(Icons.check_circle, color: Colors.white)
                                : const Icon(Icons.playlist_add_check, color: Colors.white),
                            label: Text(
                              _pagamentoConfirmado ? 'Pagamento Confirmado!' : 'Confirmar Pagamento',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            onPressed: _pagamentoConfirmado ? null : _confirmarPagamento,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _pagamentoConfirmado ? Colors.green : Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

            // NOVO: Seção de Pagamento com Cartão (Exemplo, você precisaria implementar a lógica real aqui)
            if (_selectedPaymentMethod == 'Cartão')
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Detalhes do Cartão de Crédito:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Número do Cartão',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'MM/AA',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.payment, color: Colors.white),
                      label: const Text(
                        'Pagar com Cartão',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () {
                        // Lógica para processar pagamento com cartão
                        _confirmarPagamento(); // Reutiliza a confirmação de pagamento para simular
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
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
}
