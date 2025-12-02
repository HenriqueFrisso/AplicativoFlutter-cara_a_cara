import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'jogo_page.dart';

// MODELS
import '../models/baralho.dart';
import '../models/pessoa.dart';

// SERVICES
import '../services/nearby_connections_service.dart';
import '../services/isar_service.dart';

class EnviarDeckPage extends StatefulWidget {
  const EnviarDeckPage({super.key});

  @override
  State<EnviarDeckPage> createState() => _EnviarDeckPageState();
}

class _EnviarDeckPageState extends State<EnviarDeckPage> {
  final IsarService _isar = IsarService.instance;
  final NearbyConnectionsService nearby = NearbyConnectionsService.instance;

  List<Baralho> baralhos = [];
  Baralho? selectedDeck;

  bool isAdvertising = false;
  final Set<String> _connectedClients = {};

  @override
  void initState() {
    super.initState();
    _loadDecks();
    _setupListeners();
  }

  void _setupListeners() {
    // Status de conexão
    nearby.connectionStatus.listen((status) {
      if (status.startsWith("disconnected:")) {
        final id = status.split(":")[1];
        setState(() => _connectedClients.remove(id));
      }
    });

    // Recebimento de dados (não usado aqui, mas disponível)
    nearby.onDataReceived.listen((data) {});
  }

  Future<void> _loadDecks() async {
    final decks = await _isar.getBaralhos();
    setState(() {
      baralhos = decks;
      if (decks.isNotEmpty) selectedDeck = decks.first;
    });
  }

  Future<void> _startAdvertising() async {
    if (selectedDeck == null || isAdvertising) return;

    setState(() => isAdvertising = true);

    await nearby.startAdvertising(
      name: "Enviar Deck - ${selectedDeck!.nome}",
      onClientConnected: (endpointId) async {
        setState(() => _connectedClients.add(endpointId));
        print("Cliente conectado: $endpointId");
      },
    );
  }

  Future<void> _sendDeck() async {
    if (selectedDeck == null || _connectedClients.isEmpty) return;

    List<Pessoa> pessoas = await _isar.getPessoasDeBaralho(selectedDeck!);

    for (var clientId in _connectedClients) {
      for (var pessoa in pessoas) {
        await nearby.sendPessoa(clientId, pessoa);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Deck "${selectedDeck!.nome}" enviado para ${_connectedClients.length} dispositivo(s)!'
        ),
      ),
    );

    // Inicia a partida automaticamente após o envio
    _startGame();
  }

  /// Inicia a partida
  void _startGame() async {
    // Aqui você pode navegar para a página do jogo,
    // ou disparar um evento para todos os dispositivos.
    final pessoas = await _isar.getPessoasDeBaralho(selectedDeck!);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JogoPage(
          pessoas: pessoas, // Carrega novamente os jogadores
        ),
      ),
    );
  }


  @override
  void dispose() {
    nearby.stopAdvertising();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalClients = _connectedClients.length;

    return Scaffold(
      appBar: AppBar(title: const Text("Enviar Deck")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<Baralho>(
              isExpanded: true,
              value: selectedDeck,
              items: baralhos.map((d) => DropdownMenuItem(
                value: d,
                child: Text("${d.nome ?? "Sem nome"} (${d.pessoas.length} Pessoas)"),
              )).toList(),
              onChanged: isAdvertising ? null : (d) => setState(() => selectedDeck = d),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isAdvertising ? null : _startAdvertising,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAdvertising ? Colors.green : Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(
                isAdvertising ? "Aguardando Conexões..." : "Abrir Sala para Conexão",
              ),
            ),
            if (isAdvertising) ...[
              const SizedBox(height: 20),
              Text("Dispositivos Conectados: $totalClients", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: totalClients > 0 ? _sendDeck : null,
                child: const Text("Enviar Deck para Dispositivos Conectados"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
