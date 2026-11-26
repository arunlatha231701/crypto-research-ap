import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/providers/providers.dart';
import 'package:frontend/presentation/viewmodels/auth_viewmodel.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final profileState = ref.watch(profileViewModelProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: false,
      ),
      body: user == null
          ? const Center(child: Text('User information not available'))
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileHeader(user.username, user.email),
          const SizedBox(height: 28),

          _buildSectionTitle('Account Information'),
          const SizedBox(height: 12),

          _buildInfoTile(
            'Username',
            user.username,
            Icons.person_outline,
          ),
          _buildInfoTile(
            'Email Address',
            user.email,
            Icons.email_outlined,
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showChangeUsernameDialog(
                currentUsername: user.username,
              ),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Change Username'),
            ),
          ),

          const SizedBox(height: 28),

          _buildSectionTitle('Security'),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Change Password'),
              subtitle: const Text(
                'Update your account password',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showChangePasswordDialog,
            ),
          ),

          if (profileState.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              profileState.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ],

          if (profileState.successMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              profileState.successMessage!,
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String username, String email) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 38,
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              username,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(email),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Future<void> _showChangeUsernameDialog({
    required String currentUsername,
  }) async {
    _usernameController.text = currentUsername;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change Username'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'New username',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final username = _usernameController.text.trim();

                if (username.isEmpty) return;

                final success = await ref
                    .read(profileViewModelProvider.notifier)
                    .changeUsername(username: username);

                if (!mounted) return;

                if (success) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChangePasswordDialog() async {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current password',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New password',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm new password',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final success = await ref
                    .read(profileViewModelProvider.notifier)
                    .changePassword(
                  currentPassword: _currentPasswordController.text,
                  newPassword: _newPasswordController.text,
                  confirmPassword: _confirmPasswordController.text,
                );

                if (!mounted) return;

                if (success) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Update Password'),
            ),
          ],
        );
      },
    );
  }
}