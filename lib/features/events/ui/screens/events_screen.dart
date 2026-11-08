import 'package:flutter/material.dart';

/// Pantalla de eventos anteriores (F-02), con opción de cerrar sesión para regresar al Login.
class EventsScreen extends StatelessWidget {
  final String organizationName;
  final String userName;
  final String role;

  const EventsScreen({
    super.key,
    this.organizationName = 'Tech Events Corp',
    this.userName = 'Organizador Demo',
    this.role = 'Administrador',
  });

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text(
          'Al salir, nadie más podrá ver los datos de tu organización desde este dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            key: const Key('confirm_logout_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF161A26),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Regresa al inicio de sesión limpiando la pila
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eventos Anteriores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF161A26),
              ),
            ),
            Text(
              organizationName,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF556074),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            key: const Key('logout_button'),
            onPressed: () => _confirmLogout(context),
            icon: const Icon(
              Icons.logout_rounded,
              size: 18,
              color: Color(0xFF161A26),
            ),
            label: const Text(
              'Cerrar sesión',
              style: TextStyle(
                color: Color(0xFF161A26),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta informativa de la sesión
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E4EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFF0F1F4),
                      child: Icon(
                        Icons.person_rounded,
                        color: Color(0xFF161A26),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF161A26),
                            ),
                          ),
                          Text(
                            organizationName,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF556074),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F1F4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFD0D4DE),
                        ),
                      ),
                      child: Text(
                        role,
                        key: const Key('user_role_badge'),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF161A26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Título de la sección
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  const Text(
                    'Eventos de la organización',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF161A26),
                    ),
                  ),
                  Text(
                    'AD-09 · Aislamiento activo',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Lista de eventos
              const _EventCard(
                title: 'Congreso Internacional de Tecnología 2025',
                category: 'Congreso',
                modality: 'Híbrida',
                attendees: '450 asistentes',
                date: '15 de Octubre, 2025',
              ),
              const SizedBox(height: 12),
              const _EventCard(
                title: 'Feria Universitaria de Innovación',
                category: 'Feria',
                modality: 'Presencial',
                attendees: '300 asistentes',
                date: '20 de Agosto, 2025',
              ),
              const SizedBox(height: 12),
              const _EventCard(
                title: 'Seminario de Inteligencia Artificial',
                category: 'Seminario',
                modality: 'Virtual',
                attendees: '200 asistentes',
                date: '10 de Mayo, 2025',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('new_event_button'),
        backgroundColor: const Color(0xFF161A26),
        foregroundColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Paso 1: Configurar nuevo evento (F-03)'),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'Nuevo evento',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String category;
  final String modality;
  final String attendees;
  final String date;

  const _EventCard({
    required this.title,
    required this.category,
    required this.modality,
    required this.attendees,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E4EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF556074),
                  ),
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF79809A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF161A26),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Color(0xFF79809A),
              ),
              const SizedBox(width: 4),
              Text(
                modality,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF556074),
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.people_outline,
                size: 14,
                color: Color(0xFF79809A),
              ),
              const SizedBox(width: 4),
              Text(
                attendees,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF556074),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
