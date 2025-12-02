import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/baralho.dart';
import '../models/pessoa.dart';
import '../services/isar_service.dart';

class EditCardsPage extends StatefulWidget {
  final Baralho deck;

  const EditCardsPage({super.key, required this.deck});

  @override
  State<EditCardsPage> createState() => _EditCardsPageState();
}

class _EditCardsPageState extends State<EditCardsPage> {
  final IsarService _isarService = IsarService.instance;

  List<Pessoa> pessoas = [];
  Set<int> selectedPessoaIds = {};

  @override
  void initState() {
    super.initState();
    _loadPessoas();
  }

  Future<void> _loadPessoas() async {
    final all = await _isarService.getPessoas();
    final inDeck = await _isarService.getPessoasDeBaralho(widget.deck);

    setState(() {
      pessoas = all;
      selectedPessoaIds = inDeck.map((p) => p.id).toSet();
    });
  }

  void _togglePessoa(Pessoa p) {
    setState(() {
      if (selectedPessoaIds.contains(p.id)) {
        selectedPessoaIds.remove(p.id);
      } else {
        selectedPessoaIds.add(p.id);
      }
    });
  }

  Future<void> _saveSelection() async {
    final current = await _isarService.getPessoasDeBaralho(widget.deck);

    // Remover
    for (var p in current) {
      if (!selectedPessoaIds.contains(p.id)) {
        await _isarService.removePessoaFromBaralho(p, widget.deck);
      }
    }

    // Adicionar
    for (var p in pessoas) {
      if (selectedPessoaIds.contains(p.id) &&
          !current.any((cp) => cp.id == p.id)) {
        await _isarService.addPessoaToBaralho(p, widget.deck);
      }
    }

    Navigator.pop(context);
  }

  // --------------------------------------------------------------------
  // ADICIONAR PESSOA
  // --------------------------------------------------------------------
  Future<void> _addPessoa() async {
    final nomeController = TextEditingController();
    String? fotoBase64;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text("Adicionar Pessoa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked =
                  await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    final bytes = await picked.readAsBytes();
                    fotoBase64 = base64Encode(bytes);
                    setStateDialog(() {});
                  }
                },
                child: const Text("Escolher Foto"),
              ),

              // Preview
              if (fotoBase64 != null)
                Image.memory(
                  base64Decode(fotoBase64!),
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nomeController.text.isEmpty || fotoBase64 == null) return;

                final novaPessoa = Pessoa(
                  name: nomeController.text,
                  fotoBase64: fotoBase64,
                );

                await _isarService.addPessoa(novaPessoa);
                await _loadPessoas();
                Navigator.pop(context);
              },
              child: const Text("Adicionar"),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------
  // REMOVER PESSOA
  // --------------------------------------------------------------------
  Future<void> _removePessoa(Pessoa p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Remover Pessoa"),
        content: Text("Deseja remover ${p.name}?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text("Remover"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _isarService.deletePessoa(p.id);
      await _loadPessoas();
      selectedPessoaIds.remove(p.id);
    }
  }

  // --------------------------------------------------------------------
  // UI
  // --------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Cartas: ${widget.deck.nome}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSelection,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPessoa,
        child: const Icon(Icons.person_add),
      ),
      body: pessoas.isEmpty
          ? const Center(child: Text("Nenhuma pessoa cadastrada"))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: pessoas.length,
        itemBuilder: (context, index) {
          final p = pessoas[index];
          final isSelected = selectedPessoaIds.contains(p.id);

          final fotoBytes = p.fotoBytes; // usa getter da classe Pessoa

          return GestureDetector(
            onTap: () => _togglePessoa(p),
            onLongPress: () => _removePessoa(p),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: fotoBytes != null
                            ? Image.memory(
                          fotoBytes,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                            : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          p.name,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                if (isSelected)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
