import 'dart:typed_data';
import 'package:flutter/material.dart';

class PessoaAvatarEscolhida extends StatelessWidget {
  final Uint8List? foto;
  final String? nome;
  final double size;

  const PessoaAvatarEscolhida({
    super.key,
    this.foto,
    this.nome,
    this.size = 80,
  });

  void _showFullImage(BuildContext context) {
    if (foto == null) return;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black,
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    image: DecorationImage(
                      image: MemoryImage(foto!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (nome != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      nome!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullImage(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: CircleAvatar(
              radius: size / 2 - 4,
              backgroundImage: foto != null ? MemoryImage(foto!) : null,
              child: foto == null ? const Icon(Icons.person, size: 40) : null,
            ),
          ),
          if (nome != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                nome!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
