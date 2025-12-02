import 'package:isar_community/isar.dart';
import 'pessoa.dart';

part 'baralho.g.dart';

@collection
class Baralho {
  Id id = Isar.autoIncrement;

  String? nome;

  /// Relacionamento N:N com Pessoas
  final pessoas = IsarLinks<Pessoa>();

  Baralho({this.nome});
}
