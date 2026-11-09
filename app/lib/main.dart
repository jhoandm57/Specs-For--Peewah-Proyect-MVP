import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/event_card_preview_screen.dart';

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
      theme: AppTheme.light,
      locale: const Locale('es'),
      supportedLocales: const [Locale('es')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/galeria': (context) => const GalleryScreen(),
        '/vista-previa/tarjeta': (_) => const EventCardPreview(),
      },
    );
  }
}
