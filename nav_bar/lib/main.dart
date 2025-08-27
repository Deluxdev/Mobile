import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavBar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const RootShell(),
    );
  }
}

/// Mantém a BottomNavigationBar visível em todas as telas.
/// Usamos IndexedStack para preservar o estado de cada página.
class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0; // Coloco a aba/tela que vai abrir ao iniciar

  final _pages = const [
    HomePage(),
    Modulo2Page(), // contem as tap bar
    ConfigPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Módulo'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config.'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _Centered(title: 'Bem Vindo!');
  }
}

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _Centered(title: 'Configurações');
  }
}

/// Página do Módulo 2 com TabBar no topo (rotas aninhadas visíveis)
class Modulo2Page extends StatelessWidget {
  const Modulo2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0, // já abre na Aba 2
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Módulos'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Aba 1'),
              Tab(text: 'Aba 2'),
              Tab(text: 'Aba 3'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AbaPage(title: 'Bem vindo a aba 1'),
            AbaPage(title: 'Bem vindo a aba 2'),
            AbaPage(title: 'Bem vindo a aba 3'),
          ],
        ),
      ),
    );
  }
}

class AbaPage extends StatelessWidget {
  final String title;
  const AbaPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return _Centered(title: title);
  }
}

class _Centered extends StatelessWidget {
  final String title;
  const _Centered({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
