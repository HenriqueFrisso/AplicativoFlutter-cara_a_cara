import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/pessoa.dart';

class GameCard extends StatefulWidget {
  final Pessoa pessoa;

  const GameCard({super.key, required this.pessoa});

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool isGrayscale = false;

  void _toggleGrayscale() {
    setState(() {
      isGrayscale = !isGrayscale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleGrayscale,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400, width: 2),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: ColorFiltered(
                  colorFilter: isGrayscale
                      ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                      : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                  child: widget.pessoa.fotoBytes != null
                      ? Image.memory(
                    Uint8List.fromList(widget.pessoa.fotoBytes!),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.person, size: 50),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              alignment: Alignment.center,
              child: Text(
                widget.pessoa.name ?? "Sem nome",
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
