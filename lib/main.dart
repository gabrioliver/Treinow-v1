import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'theme_controller.dart';

// Telas
import 'screens/splash/splash_screen.dart' as splash;
import 'screens/login/login_screen.dart';
import 'screens/login/register_screen.dart';
import 'screens/login/recover_login_screen.dart';
import 'screens/painel_profissional/painel_profissional_screen.dart' as painel;
import 'screens/alunos/meus_alunos_screen.dart';
import 'screens/alunos/detalhes_aluno_screen.dart';
import 'screens/financeiro/financeiro_screen.dart';
import 'screens/financeiro/recibo_completo_screen.dart';
import 'screens/agenda/agenda_calendar_screen.dart';
import 'screens/agenda/add_event_screen.dart';
import 'screens/dieta/dieta_screen.dart';
import 'screens/aviso/aviso_screen.dart';
<<<<<<< HEAD
import 'screens/relatorios/relatorios_screen.dart';
=======
>>>>>>> 34ceb76d0a34228caed8a480bcaaebddf456137e
import 'screens/painel_aluno/painel_aluno_screen.dart';
import 'screens/painel_aluno/buscar_profissional/buscar_profissional_screen.dart';
import 'screens/painel_profissional/perfil_profissional_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppThemeWrapper());
}

class AppThemeWrapper extends StatefulWidget {
  const AppThemeWrapper({super.key});

  @override
  State<AppThemeWrapper> createState() => _AppThemeWrapperState();
}

class _AppThemeWrapperState extends State<AppThemeWrapper> {
  ThemeMode _currentThemeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _currentThemeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyAppThemeController(
      themeMode: _currentThemeMode,
      setThemeMode: _setThemeMode,
      child: TreiNowApp(themeMode: _currentThemeMode),
    );
  }
}

class TreiNowApp extends StatelessWidget {
  final ThemeMode themeMode;
  const TreiNowApp({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TreiNow',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        primaryColor: const Color(0xFF0077B6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0077B6),
          primary: const Color(0xFF0077B6),
          secondary: const Color(0xFF00B386),
          brightness: Brightness.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0077B6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF00B386),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B386),
          primary: const Color(0xFF00B386),
          secondary: const Color(0xFF0077B6),
          brightness: Brightness.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B386),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const splash.SplashScreen(),
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/recover': (context) => const RecoverLoginScreen(),
        '/painel': (context) => const painel.PainelProfissionalScreen(),
        '/alunos': (context) => const MeusAlunosScreen(),
        '/financeiro': (context) => const FinanceiroScreen(),
        '/recibo_completo': (context) => const ReciboCompletoScreen(),
        '/agenda': (context) => const AgendaCalendarScreen(),
        '/dieta': (context) => const DietaScreen(),
        '/aviso': (context) => const AvisosScreen(),
        '/painel_aluno': (context) => const PainelAlunoScreen(),
        '/buscar_profissional': (context) => const BuscarProfissionalScreen(),
<<<<<<< HEAD
        '/relatorios': (context) => const RelatoriosScreen()
=======
>>>>>>> 34ceb76d0a34228caed8a480bcaaebddf456137e
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detalhes_aluno') {
          final Map<String, dynamic> aluno = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DetalhesAlunoScreen(aluno: aluno),
          );
        } else if (settings.name == '/add_event') {
          final DateTime selectedDate = settings.arguments as DateTime;
          return MaterialPageRoute(
            builder: (context) => AddEventScreen(selectedDate: selectedDate),
          );
        } else if (settings.name == '/detalhes_profissional') {
          final Map<String, dynamic> profissional = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => PerfilProfissionalScreen(uidProfissional: profissional['uid']),
          );
        }
        return null;
      },
    );
  }
}
