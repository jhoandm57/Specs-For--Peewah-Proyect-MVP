import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/auth_user.dart';

class LoginPage extends StatelessWidget {
  final String email;
  final String password;
  final bool obscurePassword;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final ValueChanged<UserRole> onQuickLogin;

  const LoginPage({
    super.key,
    required this.email,
    required this.password,
    required this.obscurePassword,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onQuickLogin,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: const Icon(
                      Icons.event_note_rounded,
                      size: 38,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Recomendador de Eventos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa con la cuenta de tu organización',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        key: const Key('email_input'),
                        initialValue: email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: onEmailChanged,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          hintText: 'tu.correo@organizacion.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const Key('password_input'),
                        initialValue: password,
                        obscureText: obscurePassword,
                        textInputAction: TextInputAction.done,
                        onChanged: onPasswordChanged,
                        onFieldSubmitted: (_) => onLogin(),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: obscurePassword
                                ? 'Mostrar contraseña'
                                : 'Ocultar contraseña',
                            onPressed: onTogglePassword,
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        key: const Key('login_button'),
                        onPressed: onLogin,
                        child: const Text('Iniciar sesión'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ACCESOS RÁPIDOS DE PRUEBA',
                        style: TextStyle(
                          color: AppColors.gray500,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 14),
                _QuickAccessCard(
                  key: const Key('quick_login_admin'),
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Administrador base',
                  email: 'admin@peewah.co',
                  description: 'Acceso completo · Nuevo evento y Usar como base',
                  onTap: () => onQuickLogin(UserRole.administrador),
                ),
                const SizedBox(height: 10),
                _QuickAccessCard(
                  key: const Key('quick_login_collaborator'),
                  icon: Icons.groups_2_outlined,
                  title: 'Colaborador base',
                  email: 'colab@peewah.co',
                  description: 'Permisos restringidos · Solo consulta',
                  onTap: () => onQuickLogin(UserRole.colaborador),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Prototipo visual con datos simulados. Aún no se valida la sesión.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.gray500,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String email;
  final String description;
  final VoidCallback onTap;

  const _QuickAccessCard({
    super.key,
    required this.icon,
    required this.title,
    required this.email,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.gray200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: AppColors.black, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: const TextStyle(
                        color: AppColors.gray600,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.gray500,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: AppColors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
