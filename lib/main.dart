import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/criar_sala_page.dart';
import 'pages/entrar_sala_page.dart';
import 'pages/jogo_page.dart';
import 'pages/edit_deck_page.dart';
import 'services/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // necessário para async no main

  // Inicializa o Isar
  await IsarService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cara a Cara",
      initialRoute: "/",
      routes: {
        "/": (_) => const HomePage(),
        "/criar": (_) => const EnviarDeckPage(),
        "/entrar": (_) => const ReceberDeckPage(),
        "/editDeck": (_) => const EditDeckPage(),
      },
    );
  }
}
