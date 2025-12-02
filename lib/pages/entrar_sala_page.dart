import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../services/nearby_connections_service.dart';
import 'jogo_page.dart';

class ReceberDeckPage extends StatefulWidget {
  const ReceberDeckPage({super.key});

  @override
  State<ReceberDeckPage> createState() => _ReceberDeckPageState();
}

class _ReceberDeckPageState extends State<ReceberDeckPage> {
  final NearbyConnectionsService nearby = NearbyConnectionsService.instance;

  final List<Map<String, String>> endpoints = [];
  final Set<String> _connectedEndpoints = {};
  final List<Pessoa> _pessoasRecebidas = [];

  late StreamSubscription<Pessoa> _dataSub;
  late StreamSubscription<String> _statusSub;

  @override
  void initState() {
    super.initState();

    // Escuta todas as pessoas recebidas
    _dataSub = nearby.onDataReceived.listen((pessoa) {
      setState(() => _pessoasRecebidas.add(pessoa));
    });

    // Escuta status de conexão
    _statusSub = nearby.connectionStatus.listen((status) {
      if (status.startsWith("disconnected:")) {
        final id = status.split(":")[1];
        setState(() => _connectedEndpoints.remove(id));
      }
    });
  }

  Future<void> _discover() async {
    setState(() => endpoints.clear());

    await nearby.startDiscovery("Jogador");

    // Observa mudanças na lista de dispositivos descobertos
    nearby.discoveredDevices.addListener(() {
      setState(() {
        endpoints.clear();
        // Itera sobre entries do Map
        for (var entry in nearby.discoveredDevices.value.entries) {
          endpoints.add({"id": entry.key, "name": entry.value});
        }
      });
    });
  }

  Future<void> _connect(String endpointId) async {
    if (_connectedEndpoints.contains(endpointId)) return;
    _connectedEndpoints.add(endpointId);

    await nearby.connectToDevice(endpointId);
  }

  @override
  void dispose() {
    nearby.stopDiscovery();
    _dataSub.cancel();
    _statusSub.cancel();
    super.dispose();
  }

  void _startGame() {
    if (_pessoasRecebidas.isEmpty) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => JogoPage(pessoas: _pessoasRecebidas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entrar na Sala")),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80), // <-- empurra TUDO 30px pra cima
        child: Column(
        children: [
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _discover,
            child: const Text("Procurar Salas"),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: endpoints.isEmpty
                ? const Center(child: Text("Nenhuma sala encontrada"))
                : ListView.builder(
              itemCount: endpoints.length,
              itemBuilder: (_, i) {
                final e = endpoints[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    title: Text(e["name"] ?? "Sala"),
                    trailing: ElevatedButton(
                      onPressed: () => _connect(e["id"]!),
                      child: const Text("Entrar"),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_pessoasRecebidas.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              "Pessoas recebidas: ${_pessoasRecebidas.length}",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            ElevatedButton(
              onPressed: _startGame,
              child: const Text("Começar Jogo"),
            ),
          ],
        ],
      ),
      ),
    );
  }
}
