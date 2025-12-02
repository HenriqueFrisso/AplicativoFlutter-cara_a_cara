import 'dart:math';
import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../widgets/game_card.dart';
import '../widgets/pessoa_avatar_escolhida.dart';

class JogoPage extends StatefulWidget {
  final List<Pessoa> pessoas;

  const JogoPage({
    super.key,
    required this.pessoas,
  });

  @override
  State<JogoPage> createState() => _JogoPageState();
}

class _JogoPageState extends State<JogoPage> {
  Pessoa? pessoaEscolhida;

  @override
  void initState() {
    super.initState();
    _sortearPessoa();
  }

  void _sortearPessoa() {
    if (widget.pessoas.isEmpty) return;

    final random = Random();
    setState(() {
      pessoaEscolhida = widget.pessoas[random.nextInt(widget.pessoas.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jogo")),

      body: Stack(
        children: [
          widget.pessoas.isEmpty
              ? const Center(child: Text("Nenhuma pessoa recebida"))
              : Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: widget.pessoas.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (_, index) {
                return GameCard(pessoa: widget.pessoas[index]);
              },
            ),
          ),

          // Avatar da pessoa escolhida
          if (pessoaEscolhida != null)
            Positioned(
              right: 16,
              bottom: 26,
              child: PessoaAvatarEscolhida(
                foto: pessoaEscolhida!.fotoBytes,
                nome: pessoaEscolhida!.name,
                size: 100,
              ),
            ),

          // 🔁 Botão de Re-Roll
          Positioned(
            left: 16,
            bottom: 60,
            child: FloatingActionButton(
              heroTag: "reroll",
              onPressed: _sortearPessoa,
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
