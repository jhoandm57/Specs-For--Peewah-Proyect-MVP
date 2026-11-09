import '../models/auth_user.dart';

const mockOrganizationId = 'org-peewah-01';
const mockOrganizationName = 'Tech Events Corp';

const mockAdminUser = AuthUser(
  id: 'usr-admin-01',
  email: 'admin@peewah.co',
  name: 'Sofía Gómez',
  organizationId: mockOrganizationId,
  organizationName: mockOrganizationName,
  role: UserRole.administrador,
);

const mockCollaboratorUser = AuthUser(
  id: 'usr-colab-02',
  email: 'colab@peewah.co',
  name: 'Carlos Pérez',
  organizationId: mockOrganizationId,
  organizationName: mockOrganizationName,
  role: UserRole.colaborador,
);
