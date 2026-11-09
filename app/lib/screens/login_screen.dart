import 'package:flutter/material.dart';

import '../data/mock_users.dart';
import '../models/auth_user.dart';
import 'events_screen.dart';
import '../pages/login_page.dart';

/// Screen anfitriona del inicio de sesión (F-01).
/// El estado del formulario vive aquí y la página reporta los cambios.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;

  AuthUser _userForEmail(String email) {
    return email.trim().toLowerCase() == 'colab@peewah.co'
        ? mockCollaboratorUser
        : mockAdminUser;
  }

  void _openEvents(AuthUser user) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => EventsScreen(user: user)),
    );
  }

  void _onLogin() {
    _openEvents(_userForEmail(_email));
  }

  void _onQuickLogin(UserRole role) {
    _openEvents(
      role == UserRole.colaborador ? mockCollaboratorUser : mockAdminUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage(
        email: _email,
        password: _password,
        obscurePassword: _obscurePassword,
        onEmailChanged: (value) => setState(() => _email = value),
        onPasswordChanged: (value) => setState(() => _password = value),
        onTogglePassword: () {
          setState(() => _obscurePassword = !_obscurePassword);
        },
        onLogin: _onLogin,
        onQuickLogin: _onQuickLogin,
      ),
    );
  }
}
