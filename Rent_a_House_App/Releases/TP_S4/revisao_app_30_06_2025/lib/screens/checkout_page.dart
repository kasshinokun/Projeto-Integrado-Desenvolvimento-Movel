// lib/pages/checkout_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatação de moeda e data
import 'package:rent_a_house/providers/housesprovider.dart'; // Importa o modelo House
import 'package:qr_flutter/qr_flutter.dart'; // NOVO: Importa a biblioteca qr_flutter

class CheckoutPage extends StatefulWidget {
  final House house; // Recebe o objeto House completo

  const CheckoutPage({Key? key, required this.house}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _pagamentoConfirmado = false;
  String? _codigoPix;
  bool _isGeneratingPix = false; // Estado para controlar o loading do Pix

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
                            'Aluguel valor:',
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

            // Seção de Pagamento Pix
            Text(
              'Escolha seu método de pagamento',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
