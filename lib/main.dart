import 'package:flutter/material.dart';
import 'features/events/ui/screens/events_screen.dart';
import 'features/login/ui/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PeewahApp());
}

class PeewahApp extends StatelessWidget {
  const PeewahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recomendador de Eventos Peewah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBFBFD),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF161A26),
          primary: const Color(0xFF161A26),
          surface: const Color(0xFFFBFBFD),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF161A26),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/eventos': (context) => const EventsScreen(),
      },
    );
  }
}
