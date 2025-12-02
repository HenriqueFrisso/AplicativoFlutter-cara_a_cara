import 'dart:convert';
import 'dart:typed_data';
import 'package:isar_community/isar.dart';
import 'baralho.dart';

part 'pessoa.g.dart';

@collection
class Pessoa {
  Id id = Isar.autoIncrement;

  String name = "";

  /// Foto salva como Base64 (mais seguro que List<int> para Isar)
  String? fotoBase64;

  /// Relacionamento com baralhos
  final baralhos = IsarLinks<Baralho>();

  Pessoa({
    required this.name,
    this.fotoBase64,
  });

  // ---------------------------------------------------------
  // GETTERS CONVENIENTES
  // ---------------------------------------------------------

  /// Retorna bytes da foto
  @ignore
  Uint8List? get fotoBytes {
    if (fotoBase64 == null) return null;
    try {
      return base64Decode(fotoBase64!);
    } catch (_) {
      return null;
    }
  }

  /// Define foto a partir de bytes
  set fotoBytes(Uint8List? bytes) {
    fotoBase64 = bytes != null ? base64Encode(bytes) : null;
  }

  // ---------------------------------------------------------
  // JSON
  // ---------------------------------------------------------

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "fotoBase64": fotoBase64,
  };

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      name: json["name"] ?? "",
      fotoBase64: json["fotoBase64"],
    )..id = json["id"] ?? 0;
  }

  // ---------------------------------------------------------
  // SERIALIZAÇÃO PARA ENVIO VIA NEARBY
  // ---------------------------------------------------------

  Uint8List toBytes() => utf8.encode(jsonEncode(toJson()));

  factory Pessoa.fromBytes(Uint8List bytes) {
    final str = utf8.decode(bytes);
    final map = jsonDecode(str);
    return Pessoa.fromJson(map);
  }
}
