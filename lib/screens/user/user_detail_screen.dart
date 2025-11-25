import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import 'user_form_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().user;
    final isViewingOwnProfile = currentUser?.id == user.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail'),
        actions: [
          if (!isViewingOwnProfile)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserFormScreen(user: user)),
                );
              },
              tooltip: 'Edit User',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: user.isAdmin
                      ? [
                          AppColors.secondary,
                          AppColors.secondary.withOpacity(0.7),
                        ]
                      : [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: user.isAdmin
                              ? AppColors.secondary
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          user.isAdmin
                              ? Icons.admin_panel_settings
                              : Icons.person,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          user.role.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Self Profile Info Banner
            if (isViewingOwnProfile)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ini adalah profil Anda. Anda tidak dapat mengubah role sendiri.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // User Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Information Section
                  _buildSectionHeader('Account Information'),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: user.email,
                    iconColor: AppColors.primary,
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.badge,
                    label: 'User ID',
                    value: user.id,
                    iconColor: AppColors.accent,
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.lock,
                    label: 'Password',
                    value: user.password != null && user.password!.isNotEmpty
                        ? '••••••••'
                        : 'Not set',
                    iconColor:
                        user.password != null && user.password!.isNotEmpty
                        ? Colors.green
                        : Colors.grey,
                  ),

                  const SizedBox(height: 32),

                  // Permissions Section
                  _buildSectionHeader('Permissions & Access'),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          (user.isAdmin
                                  ? AppColors.secondary
                                  : AppColors.primary)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            (user.isAdmin
                                    ? AppColors.secondary
                                    : AppColors.primary)
                                .withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              user.isAdmin
                                  ? Icons.admin_panel_settings
                                  : Icons.person,
                              color: user.isAdmin
                                  ? AppColors.secondary
                                  : AppColors.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${user.role.toUpperCase()} Role',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: user.isAdmin
                                    ? AppColors.secondary
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (user.isAdmin) ...[
                          _buildPermissionItem(
                            'Create, edit, and delete blogs',
                            true,
                          ),
                          _buildPermissionItem('Manage all users', true),
                          _buildPermissionItem('Access admin panel', true),
                          _buildPermissionItem('Full system control', true),
                        ] else ...[
                          _buildPermissionItem('View all blogs', true),
                          _buildPermissionItem('Search and filter blogs', true),
                          _buildPermissionItem('View blog details', true),
                          _buildPermissionItem('Create/edit blogs', false),
                          _buildPermissionItem('Manage users', false),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Account Activity Section
                  _buildSectionHeader('Account Activity'),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    label: 'Created',
                    value: user.createdAt != null
                        ? DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(user.createdAt!)
                        : 'N/A',
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.update,
                    label: 'Last Updated',
                    value: user.updatedAt != null
                        ? DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(user.updatedAt!)
                        : 'N/A',
                    iconColor: Colors.orange,
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserFormScreen(user: user),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit User'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(String text, bool isAllowed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            isAllowed ? Icons.check_circle : Icons.cancel,
            size: 20,
            color: isAllowed ? Colors.green : Colors.red.shade300,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isAllowed ? Colors.black87 : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
