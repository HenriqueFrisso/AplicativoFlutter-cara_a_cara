import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:nearby_connections/nearby_connections.dart';
import '../models/pessoa.dart';

class NearbyConnectionsService {
  NearbyConnectionsService._privateConstructor();
  static final NearbyConnectionsService instance =
  NearbyConnectionsService._privateConstructor();

  final Nearby _nearby = Nearby();
  final Strategy strategy = Strategy.P2P_STAR;

  // ----------------------
  // Dispositivos
  // ----------------------
  final Map<String, ConnectionInfo> connectedDevices = {};
  final ValueNotifier<Map<String, String>> discoveredDevices = ValueNotifier({});

  // ----------------------
  // Streams
  // ----------------------
  final StreamController<String> _connectionStatusController =
  StreamController.broadcast();
  final StreamController<Pessoa> _onDataReceivedController =
  StreamController.broadcast();

  Stream<String> get connectionStatus => _connectionStatusController.stream;
  Stream<Pessoa> get onDataReceived => _onDataReceivedController.stream;

  // ----------------------
  // ADVERTISING
  // ----------------------
  Future<void> startAdvertising({
    required String name,
    required void Function(String endpointId) onClientConnected,
  }) async {
    await _nearby.startAdvertising(
      name,
      strategy,
      onConnectionInitiated: (id, info) {
        _nearby.acceptConnection(
          id,
          onPayLoadRecieved: (endid, payload) => _onPayloadReceived(endid, payload),
          onPayloadTransferUpdate: (_, __) {},
        );

        connectedDevices[id] = info;
        _connectionStatusController.add("connected:$id");
        onClientConnected(id);
      },
      onConnectionResult: (_, __) {},
      onDisconnected: (id) {
        connectedDevices.remove(id);
        _connectionStatusController.add("disconnected:$id");
      },
    );
  }

  Future<void> stopAdvertising() async => _nearby.stopAdvertising();

  // ----------------------
  // DISCOVERY
  // ----------------------
  Future<void> startDiscovery(String userName) async {
    discoveredDevices.value = {};
    await _nearby.startDiscovery(
      userName,
      strategy,
      onEndpointFound: (id, name, serviceId, [metadata]) {
        discoveredDevices.value = {...discoveredDevices.value, id: name};
      },
      onEndpointLost: (id) {
        final newMap = Map<String, String>.from(discoveredDevices.value);
        newMap.remove(id);
        discoveredDevices.value = newMap;
      },
    );
  }

  Future<void> stopDiscovery() async => _nearby.stopDiscovery();

  // ----------------------
  // CONNECT
  // ----------------------
  Future<void> connectToDevice(String endpointId) async {
    await _nearby.requestConnection(
      "Jogador",
      endpointId,
      onConnectionInitiated: (id, info) {
        _nearby.acceptConnection(
          id,
          onPayLoadRecieved: (endid, payload) => _onPayloadReceived(endid, payload),
          onPayloadTransferUpdate: (_, __) {},
        );
      },
      onConnectionResult: (_, __) {},
      onDisconnected: (id) {
        connectedDevices.remove(id);
        _connectionStatusController.add("disconnected:$id");
      },
    );
  }

  // ----------------------
  // ENVIO DE PESSOAS
  // ----------------------
  Future<void> sendDeck(String deviceId, List<Pessoa> pessoas) async {
    if (!connectedDevices.containsKey(deviceId)) return;

    final jsonData = pessoas.map((p) => p.toJson()).toList();
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(jsonData)));

    await _nearby.sendBytesPayload(deviceId, bytes);
  }

  Future<void> sendPessoa(String deviceId, Pessoa pessoa) async {
    if (!connectedDevices.containsKey(deviceId)) return;

    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(pessoa.toJson())));
    await _nearby.sendBytesPayload(deviceId, bytes);

    await Future.delayed(const Duration(milliseconds: 150));
  }

  // ----------------------
  // RECEBIMENTO DE PESSOAS
  // ----------------------
  void _onPayloadReceived(String deviceId, Payload payload) {
    if (payload.type != PayloadType.BYTES || payload.bytes == null) return;

    try {
      final str = utf8.decode(payload.bytes!);
      final decoded = jsonDecode(str);

      if (decoded is List) {
        for (var item in decoded) {
          if (item is Map) {
            final pessoa = Pessoa.fromJson(Map<String, dynamic>.from(item));
            _onDataReceivedController.add(pessoa);
          }
        }
      } else if (decoded is Map) {
        final pessoa = Pessoa.fromJson(Map<String, dynamic>.from(decoded));
        _onDataReceivedController.add(pessoa);
      }
    } catch (e) {
      debugPrint("❌ Erro ao decodificar payload: $e");
    }
  }

  // ----------------------
  // DISPOSE
  // ----------------------
  void dispose() {
    _connectionStatusController.close();
    _onDataReceivedController.close();
    discoveredDevices.dispose();
  }
}
