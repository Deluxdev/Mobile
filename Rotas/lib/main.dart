import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const App());

class AuthState extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

final authState = AuthState();

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3B82F6),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (!authState.isAuthenticated && 
            (settings.name == '/menu' || settings.name == '/perfil' || settings.name == '/configuracoes')) {
          return MaterialPageRoute(
            builder: (context) => const HomePage(),
          );
        }

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/menu':
            return MaterialPageRoute(builder: (context) => const MenuPage());
          case '/perfil':
            return MaterialPageRoute(builder: (context) => const PerfilPage());
          case '/configuracoes':
            return MaterialPageRoute(
              builder: (context) => ConfiguracoesPage(
                userData: settings.arguments as Map<String, String>?,
              ),
            );
          default:
            return MaterialPageRoute(builder: (context) => const HomePage());
        }
      },
    );
  }
}

// Página Inicial
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bem-vindo'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authState.login();
                Navigator.pushNamed(context, '/menu');
              },
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 20),
            if (authState.isAuthenticated)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/perfil');
                },
                child: const Text('Ir para Perfil'),
              ),
          ],
        ),
      ),
    );
  }
}

//Menu
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/perfil');
              },
              child: const Text('Perfil'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final userData = {
                  'nome': 'Erick Gabriel',
                  'dataNascimento': '01/01/2000',
                  'telefone': '(64) 99999-9999'
                };
                Navigator.pushNamed(
                  context,
                  '/configuracoes',
                  arguments: userData,
                );
              },
              child: const Text('Configurações'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authState.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}

//Perfil
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/menu'),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Página do Perfil'),
            SizedBox(height: 20),
            Text('Informações do Usuário'),
          ],
        ),
      ),
    );
  }
}

//Configurações
class ConfiguracoesPage extends StatelessWidget {
  final Map<String, String>? userData;

  const ConfiguracoesPage({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/menu'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Configurações do Usuário'),
            const SizedBox(height: 20),
            Text('Nome: ${userData?['nome'] ?? 'N/A'}'),
            Text('Data de Nascimento: ${userData?['dataNascimento'] ?? 'N/A'}'),
            Text('Telefone: ${userData?['telefone'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}

//formulário no carrossel
class Registro {
  final TextEditingController nome = TextEditingController();
  DateTime? dataNascimento;
  String? sexo;

  Map<String, dynamic> toMap() => {
        'nome': nome.text.trim(),
        'dataNascimento': dataNascimento?.toIso8601String(),
        'sexo': sexo,
      };

  bool get valido =>
      nome.text.trim().isNotEmpty && dataNascimento != null && sexo != null;

  void dispose() => nome.dispose();
}

class ChamadaPage extends StatefulWidget {
  const ChamadaPage({super.key});
  @override
  State<ChamadaPage> createState() => _ChamadaPageState();
}

class _ChamadaPageState extends State<ChamadaPage> {
  final _pageController = PageController(viewportFraction: .9);
  final _registros = <Registro>[Registro()];
  int _pageIndex = 0;

  @override
  void dispose() {
    for (final r in _registros) {
      r.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _adicionarCard() {
    setState(() => _registros.add(Registro()));
    Future.delayed(const Duration(milliseconds: 150), () {
      _pageController.animateToPage(
        _registros.length - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _removerCardAtual() {
    if (_registros.length == 1) return;
    final idx = _pageIndex;
    setState(() {
      final r = _registros.removeAt(idx);
      r.dispose();
      _pageIndex = _pageIndex.clamp(0, _registros.length - 1);
    });
  }

  Future<void> _salvar() async {
    final invalidos = <int>[];
    for (var i = 0; i < _registros.length; i++) {
      if (!_registros[i].valido) invalidos.add(i);
    }
    if (invalidos.isNotEmpty) {
      _pageController.animateToPage(
        invalidos.first,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Preencha todos os campos nos cards: ${invalidos.map((i) => i + 1).join(', ')}.',
          ),
        ),
      );
      return;
    }
    final dados = _registros.map((r) => r.toMap()).toList();
    debugPrint('ENVIANDO: $dados');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados enviados com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário em Carrossel'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _pageIndex = i),
              itemCount: _registros.length,
              itemBuilder: (context, index) {
                return _FormCard(index: index, registro: _registros[index]);
              },
            ),
          ),
          const SizedBox(height: 8),
          _Dots(total: _registros.length, index: _pageIndex),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _removerCardAtual,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Remover card'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _adicionarCard,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar card'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.check),
                label: const Text('Validar e Enviar'),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: cor.surface,
    );
  }
}

class _FormCard extends StatefulWidget {
  final int index;
  final Registro registro;
  const _FormCard({required this.index, required this.registro});

  @override
  State<_FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<_FormCard> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _selecionarData() async {
    final agora = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(agora.year, agora.month, agora.day),
      initialDate: widget.registro.dataNascimento ?? DateTime(2000, 1, 1),
      helpText: 'Selecione a data de nascimento',
    );
    if (picked != null) {
      setState(() => widget.registro.dataNascimento = picked);
    }
  }

  String _formatarData(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.registro;
    return Center(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    'Formulário ${widget.index + 1}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: r.nome,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nome Completo',
                      hintText: 'Ex.: Erick Gabriel',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _selecionarData,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Data de Nascimento',
                          hintText: 'dd/mm/aaaa',
                          suffixIcon: IconButton(
                            onPressed: _selecionarData,
                            icon: const Icon(Icons.calendar_today_outlined),
                          ),
                        ),
                        controller: TextEditingController(
                          text: _formatarData(r.dataNascimento),
                        ),
                        validator: (_) =>
                            r.dataNascimento == null ? 'Selecione a data' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: r.sexo,
                    items: const [
                      DropdownMenuItem(value: 'Homem', child: Text('Homem')),
                      DropdownMenuItem(value: 'Mulher', child: Text('Mulher')),
                    ],
                    onChanged: (v) => setState(() => r.sexo = v),
                    decoration: const InputDecoration(labelText: 'Sexo'),
                    validator: (v) => v == null ? 'Selecione o sexo' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int total;
  final int index;
  const _Dots({required this.total, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i == index;
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? Colors.black.withOpacity(.6)
                : Colors.black.withOpacity(.2),
          ),
        );
      }),
    );
  }
}
