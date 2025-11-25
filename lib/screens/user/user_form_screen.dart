import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({Key? key, this.user}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'user';
  bool _isLoading = false;
  bool _obscurePassword = true;

  bool get isEditMode => widget.user != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _passwordController.text = widget.user!.password ?? '';
      _selectedRole = widget.user!.role;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = User(
      id: widget.user?.id ?? '',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      role: _selectedRole,
      password: _passwordController.text.trim().isEmpty
          ? null
          : _passwordController.text.trim(),
    );

    bool success;
    if (isEditMode) {
      success = await context.read<UserProvider>().updateUser(
        widget.user!.id,
        user,
      );
    } else {
      success = await context.read<UserProvider>().createUser(user);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode
                ? 'User updated successfully'
                : 'User created successfully',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save user'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().user;
    final isEditingSelf = isEditMode && currentUser?.id == widget.user?.id;

    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit User' : 'Add User')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Preview
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: _selectedRole == 'admin'
                      ? AppColors.secondary
                      : AppColors.primary,
                  child: Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text.substring(0, 1).toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter full name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter name';
                  }
                  if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {}); // Rebuild untuk update avatar
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email';
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: isEditMode
                      ? 'Leave empty to keep current password'
                      : 'Enter password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  // Password required for new user
                  if (!isEditMode && (value == null || value.trim().isEmpty)) {
                    return 'Please enter password';
                  }
                  // If password provided, must be at least 6 characters
                  if (value != null &&
                      value.trim().isNotEmpty &&
                      value.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Self-Edit Warning
              if (isEditingSelf)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Anda tidak dapat mengubah role sendiri',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Role Selection
              const Text(
                'Role',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Admin'),
                      subtitle: const Text('Full access to all features'),
                      value: 'admin',
                      groupValue: _selectedRole,
                      onChanged: isEditingSelf
                          ? null
                          : (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                      activeColor: AppColors.secondary,
                    ),
                    Divider(height: 1, color: Colors.grey.shade300),
                    RadioListTile<String>(
                      title: const Text('User'),
                      subtitle: const Text('Read-only access to blogs'),
                      value: 'user',
                      groupValue: _selectedRole,
                      onChanged: isEditingSelf
                          ? null
                          : (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Role Description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      (_selectedRole == 'admin'
                              ? AppColors.secondary
                              : AppColors.primary)
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        (_selectedRole == 'admin'
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
                          _selectedRole == 'admin'
                              ? Icons.admin_panel_settings
                              : Icons.person,
                          color: _selectedRole == 'admin'
                              ? AppColors.secondary
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_selectedRole.toUpperCase()} Permissions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedRole == 'admin'
                                ? AppColors.secondary
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_selectedRole == 'admin') ...[
                      _buildPermissionItem('✓ Create, edit, and delete blogs'),
                      _buildPermissionItem('✓ Manage users (CRUD)'),
                      _buildPermissionItem('✓ Access to all features'),
                      _buildPermissionItem('✓ Full system control'),
                    ] else ...[
                      _buildPermissionItem('✓ View all blogs'),
                      _buildPermissionItem('✓ Search and filter blogs'),
                      _buildPermissionItem(
                        '✗ Cannot create/edit blogs',
                        isAllowed: false,
                      ),
                      _buildPermissionItem(
                        '✗ Cannot manage users',
                        isAllowed: false,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              CustomButton(
                text: isEditMode ? 'Update User' : 'Create User',
                isLoading: _isLoading,
                onPressed: _saveUser,
              ),
              const SizedBox(height: 16),

              // Cancel Button
              OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem(String text, {bool isAllowed = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isAllowed ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isAllowed ? Colors.green : Colors.red.shade300,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isAllowed ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
