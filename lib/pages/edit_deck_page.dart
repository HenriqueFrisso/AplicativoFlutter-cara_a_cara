import 'package:flutter/material.dart';
import '../models/baralho.dart';
import '../services/isar_service.dart';
import 'edit_cards_page.dart';

class EditDeckPage extends StatefulWidget {
  const EditDeckPage({super.key});

  @override
  State<EditDeckPage> createState() => _EditDeckPageState();
}

class _EditDeckPageState extends State<EditDeckPage> {
  final IsarService _isarService = IsarService.instance;
  List<Baralho> baralhos = [];

  @override
  void initState() {
    super.initState();
    _loadBaralhos();
  }

  Future<void> _loadBaralhos() async {
    final list = await _isarService.getBaralhos();
    setState(() => baralhos = list);
  }

  Future<void> _createDeck() async {
    final nomeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Criar Novo Deck"),
        content: TextField(
          controller: nomeController,
          decoration: const InputDecoration(labelText: "Nome do deck"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nomeController.text.isEmpty) return;

              final novoDeck = Baralho(nome: nomeController.text);
              await _isarService.addBaralho(novoDeck);
              _loadBaralhos();
              Navigator.pop(context);
            },
            child: const Text("Criar"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDeck(Baralho deck) async {
    await _isarService.deleteBaralho(deck.id);
    _loadBaralhos();
  }

  void _editDeckCards(Baralho deck) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditCardsPage(deck: deck)),
    ).then((_) => _loadBaralhos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Baralhos")),
      floatingActionButton: FloatingActionButton(
        onPressed: _createDeck,
        child: const Icon(Icons.add),
      ),
      body: baralhos.isEmpty
          ? const Center(child: Text("Nenhum deck criado"))
          : ListView.builder(
        itemCount: baralhos.length,
        itemBuilder: (context, index) {
          final deck = baralhos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(deck.nome ?? "Sem nome"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editDeckCards(deck),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteDeck(deck),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
