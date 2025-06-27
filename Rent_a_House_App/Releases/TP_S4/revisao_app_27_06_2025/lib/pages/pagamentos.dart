import 'package:flutter/material.dart';

class PagamentoPixPage extends StatefulWidget {
  const PagamentoPixPage({Key? key}) : super(key: key);

  @override
  State<PagamentoPixPage> createState() => _PagamentoPixPageState();
}

class _PagamentoPixPageState extends State<PagamentoPixPage> {
  bool pagamentoConfirmado = false;
  String? codigoPix;

  void gerarCodigoPix() {
    setState(() {
      // Simula um código Pix gerado
      codigoPix = '00020126330014BR.GOV.BCB.PIX0114+558199999999520400005303986540510.005802BR5925Fulano ou Ciclano de tal Pix6009Sao Paulo62070503***6304ABCD';
      pagamentoConfirmado = false;
    });
  }

  void confirmarPagamento() {
    setState(() {
      pagamentoConfirmado = true; // simula confirmação
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento via Pix (Simulado)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code),
              label: const Text('Gerar código Pix'),
              onPressed: gerarCodigoPix,
            ),
            const SizedBox(height: 16),
            if (codigoPix != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Código Pix gerado:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(codigoPix!),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: Text(pagamentoConfirmado
                        ? 'Pagamento confirmado!'
                        : 'Confirmar pagamento'),
                    onPressed: pagamentoConfirmado ? null : confirmarPagamento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pagamentoConfirmado ? Colors.green : null,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}