import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          // Profile card
          _buildProfileCard(),
          const SizedBox(height: 24),

          
          _buildSectionHeader('Account'),
          const SizedBox(height: 10),
          _buildSettingsGroup([
            _SettingsTile(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              onTap: () => _showSnack(context, 'Profile settings coming soon'),
            ),
            _SettingsTile(
              icon: Icons.notifications_none_rounded,
              label: 'Notifications',
              onTap: () =>
                  _showSnack(context, 'Notification settings coming soon'),
              trailing: _toggleChip(true),
            ),
            _SettingsTile(
              icon: Icons.language_rounded,
              label: 'Language',
              subtitle: 'English',
              onTap: () => _showSnack(context, 'Language settings coming soon'),
            ),
            _SettingsTile(
              icon: Icons.dark_mode_outlined,
              label: 'Dark Mode',
              onTap: () => _showSnack(context, 'Dark mode coming soon'),
              trailing: _toggleChip(false),
            ),
          ]),

          const SizedBox(height: 24),

          // About section
          _buildSectionHeader('About'),
          const SizedBox(height: 10),
          _buildSettingsGroup([
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              label: 'About Us',
              onTap: () => _showAboutDialog(context),
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              onTap: () =>
                  _showSnack(context, 'Privacy Policy coming soon'),
            ),
            _SettingsTile(
              icon: Icons.description_outlined,
              label: 'Terms & Conditions',
              onTap: () =>
                  _showSnack(context, 'Terms & Conditions coming soon'),
            ),
            _SettingsTile(
              icon: Icons.help_outline_rounded,
              label: 'Help & Support',
              onTap: () => _showSnack(context, 'Help & Support coming soon'),
              isLast: true,
            ),
          ]),

          const SizedBox(height: 24),
          // App version
          const Center(
            child: Text(
              'Recipe App v1.0.0',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF14A380), Color(0xFF0E7A60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded,
                color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chef Rayhan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'rayhan22cse011@example.com',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSettingsGroup(List<_SettingsTile> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: tiles,
      ),
    );
  }

  Widget _toggleChip(bool value) {
    return Container(
      width: 44,
      height: 26,
      decoration: BoxDecoration(
        color: value
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.border,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Align(
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(3),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: value ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.restaurant_menu_rounded, color: AppColors.primary),
            SizedBox(width: 10),
            Text('About Recipe App',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Recipe App is a personal cooking companion.\n\nDiscover hundreds of recipes, plan your weekly meals, and save your favourites.\n\nVersion 1.0.0\nDeveloped by Rayhan (22CSE011)',
          style:
              TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: subtitle != null
              ? Text(subtitle!,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textLight))
              : null,
          trailing: trailing ??
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textLight, size: 22),
        ),
        if (!isLast)
          const Divider(
              height: 1, indent: 72, endIndent: 18, color: AppColors.border),
      ],
    );
  }
}
