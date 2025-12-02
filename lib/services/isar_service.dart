import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import '../models/pessoa.dart';
import '../models/baralho.dart';

class IsarService {
  // Singleton
  IsarService._privateConstructor();
  static final IsarService instance = IsarService._privateConstructor();

  late Isar isar;

  // ================== Inicialização ==================
  Future<void> init() async {
    try {
      if (Isar.instanceNames.contains('cara_a_cara')) {
        isar = Isar.getInstance('cara_a_cara')!;
        return;
      }

      final dir = await getApplicationDocumentsDirectory();

      isar = await Isar.open(
        [PessoaSchema, BaralhoSchema],
        directory: dir.path,
        name: 'cara_a_cara',
      );
    } catch (e, s) {
      print("❌ Erro ao inicializar Isar: $e\n$s");
      rethrow;
    }
  }

  // =====================================================
  // Pessoas
  // =====================================================

  Future<List<Pessoa>> getPessoas() async {
    try {
      return await isar.pessoas.where().findAll();
    } catch (e, s) {
      print("❌ Erro ao buscar pessoas: $e\n$s");
      return [];
    }
  }

  Future<void> addPessoa(Pessoa pessoa) async {
    try {
      await isar.writeTxn(() async {
        await isar.pessoas.put(pessoa);
      });
    } catch (e, s) {
      print("❌ Erro ao adicionar pessoa: $e\n$s");
      rethrow;
    }
  }

  Future<void> updatePessoa(Pessoa pessoa) async {
    try {
      await isar.writeTxn(() async {
        await isar.pessoas.put(pessoa);
      });
    } catch (e, s) {
      print("❌ Erro ao atualizar pessoa: $e\n$s");
      rethrow;
    }
  }

  Future<void> deletePessoa(int id) async {
    try {
      await isar.writeTxn(() async {
        await isar.pessoas.delete(id);
      });
    } catch (e, s) {
      print("❌ Erro ao deletar pessoa: $e\n$s");
      rethrow;
    }
  }

  Future<Pessoa?> getPessoaById(int id) async {
    try {
      return await isar.pessoas.get(id);
    } catch (e, s) {
      print("❌ Erro ao buscar pessoa por ID ($id): $e\n$s");
      return null;
    }
  }

  // =====================================================
  // Baralhos
  // =====================================================

  Future<List<Baralho>> getBaralhos() async {
    try {
      return await isar.baralhos.where().findAll();
    } catch (e, s) {
      print("❌ Erro ao buscar baralhos: $e\n$s");
      return [];
    }
  }

  Future<void> addBaralho(Baralho baralho) async {
    try {
      await isar.writeTxn(() async {
        await isar.baralhos.put(baralho);
      });
    } catch (e, s) {
      print("❌ Erro ao adicionar baralho: $e\n$s");
      rethrow;
    }
  }

  Future<void> updateBaralho(Baralho baralho) async {
    try {
      await isar.writeTxn(() async {
        await isar.baralhos.put(baralho);
      });
    } catch (e, s) {
      print("❌ Erro ao atualizar baralho: $e\n$s");
      rethrow;
    }
  }

  Future<void> deleteBaralho(int id) async {
    try {
      await isar.writeTxn(() async {
        await isar.baralhos.delete(id);
      });
    } catch (e, s) {
      print("❌ Erro ao deletar baralho: $e\n$s");
      rethrow;
    }
  }

  Future<Baralho?> getBaralhoById(int id) async {
    try {
      return await isar.baralhos.get(id);
    } catch (e, s) {
      print("❌ Erro ao buscar baralho por ID ($id): $e\n$s");
      return null;
    }
  }

  // =====================================================
  // Relacionamento N:N
  // =====================================================

  Future<void> addPessoaToBaralho(Pessoa pessoa, Baralho baralho) async {
    try {
      await isar.writeTxn(() async {
        if (pessoa.id == 0) await isar.pessoas.put(pessoa);
        if (baralho.id == 0) await isar.baralhos.put(baralho);

        baralho.pessoas.add(pessoa);
        await baralho.pessoas.save();
      });
    } catch (e, s) {
      print("❌ Erro ao adicionar pessoa ao baralho: $e\n$s");
      rethrow;
    }
  }

  Future<void> removePessoaFromBaralho(Pessoa pessoa, Baralho baralho) async {
    try {
      await isar.writeTxn(() async {
        baralho.pessoas.remove(pessoa);
        await baralho.pessoas.save();
      });
    } catch (e, s) {
      print("❌ Erro ao remover pessoa do baralho: $e\n$s");
      rethrow;
    }
  }

  Future<List<Pessoa>> getPessoasDeBaralho(Baralho baralho) async {
    try {
      await baralho.pessoas.load();
      return baralho.pessoas.toList();
    } catch (e, s) {
      print("❌ Erro ao carregar pessoas do baralho: $e\n$s");
      return [];
    }
  }

  Future<List<Baralho>> getBaralhosDePessoa(Pessoa pessoa) async {
    try {
      await pessoa.baralhos.load();
      return pessoa.baralhos.toList();
    } catch (e, s) {
      print("❌ Erro ao carregar baralhos da pessoa: $e\n$s");
      return [];
    }
  }
}
