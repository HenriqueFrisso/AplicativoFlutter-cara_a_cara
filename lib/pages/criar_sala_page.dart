import 'package:flutter/material.dart';

// PAGES
import 'jogo_page.dart';

// MODELS
import '../models/baralho.dart';
import '../models/pessoa.dart';

// SERVICES
import '../services/isar_service.dart';

class EnviarDeckPage extends StatefulWidget {
  const EnviarDeckPage({super.key});

  @override
  State<EnviarDeckPage> createState() => _EnviarDeckPageState();
}

class _EnviarDeckPageState extends State<EnviarDeckPage> {
  final IsarService _isar = IsarService.instance;

  List<Baralho> _baralhos = [];
  Baralho? _deckSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarDecks();
  }

  /// Carrega os decks do banco
  Future<void> _carregarDecks() async {
    final decks = await _isar.getBaralhos();
    setState(() {
      _baralhos = decks;
      if (decks.isNotEmpty) {
        _deckSelecionado = decks.first;
      }
    });
  }

  /// Apenas abre a tela do jogo
  Future<void> _iniciarJogo() async {
    if (_deckSelecionado == null) return;

    final pessoas =
    await _isar.getPessoasDeBaralho(_deckSelecionado!);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JogoPage(
          pessoas: pessoas,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Sala"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Seleção do Deck
            DropdownButton<Baralho>(
              isExpanded: true,
              value: _deckSelecionado,
              items: _baralhos.map((deck) {
                return DropdownMenuItem(
                  value: deck,
                  child: Text(
                    "${deck.nome ?? "Sem nome"} "
                        "(${deck.pessoas.length} Pessoas)",
                  ),
                );
              }).toList(),
              onChanged: (deck) =>
                  setState(() => _deckSelecionado = deck),
            ),

            const SizedBox(height: 24),

            /// Botão Criar Sala
            ElevatedButton(
              onPressed: _iniciarJogo,
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Criar Sala",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
