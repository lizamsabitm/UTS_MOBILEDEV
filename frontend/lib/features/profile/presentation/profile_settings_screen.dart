import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/presentation/login_screen.dart';

import '../data/user_service.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String username;
  final String email;
  final String? name;

  const ProfileSettingsScreen({
    Key? key,
    required this.username,
    required this.email,
    this.name,
  }) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  late TextEditingController _givenNameController;
  late TextEditingController _familyNameController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  late TextEditingController _bioController;

  String _pronoun = 'They / their';
  String _allowReplies = 'Anyone';
  String _customPosters = 'Enabled';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final parts = (widget.name ?? '').trim().split(' ');
    final given = parts.isNotEmpty ? parts.first : '';
    final family = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    _givenNameController = TextEditingController(text: given);
    _familyNameController = TextEditingController(text: family);
    _emailController = TextEditingController(text: widget.email);
    _locationController = TextEditingController();
    _websiteController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _givenNameController.dispose();
    _familyNameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2730),
        title: const Text('Sign out', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to sign out of Layarboxd?',
          style: TextStyle(color: Color(0xFF899AA9)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF899AA9))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8000)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.headerBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          _isSaving
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF00E054),
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check, color: Color(0xFF00E054)),
                  tooltip: 'Save',
                  onPressed: () async {
                    setState(() => _isSaving = true);
                    final fullName = [
                      _givenNameController.text.trim(),
                      _familyNameController.text.trim()
                    ].where((s) => s.isNotEmpty).join(' ');

                    final messenger = ScaffoldMessenger.of(context);
                    final nav = Navigator.of(context);

                    await _userService.updateProfile(
                      name: fullName.isNotEmpty ? fullName : widget.username,
                    );

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: Color(0xFF1F2730),
                      ),
                    );
                    nav.pop(true);
                  },
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Signed in as ${widget.username}',
              style: const TextStyle(
                color: Color(0xFF899AA9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Validation email sent!')),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Resend email validation',
                  style: TextStyle(
                    color: Color(0xFFBAC6D0),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Auth Settings',
                      style: TextStyle(color: Color(0xFFBAC6D0), fontSize: 14),
                    ),
                    Icon(Icons.chevron_right, color: Color(0xFF899AA9), size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _logout,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Sign out',
                  style: TextStyle(
                    color: Color(0xFFFF8000),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF242E37)),
            const SizedBox(height: 16),

            // Form Fields
            _buildField('Given Name', _givenNameController),
            const SizedBox(height: 12),
            _buildField('Family Name', _familyNameController),
            const SizedBox(height: 12),
            _buildField('Email Address', _emailController),
            const SizedBox(height: 12),
            _buildField('Location', _locationController),
            const SizedBox(height: 12),
            _buildField('Website', _websiteController),
            const SizedBox(height: 12),
            _buildField('Bio', _bioController, maxLines: 3),
            const SizedBox(height: 12),

            // Pronoun dropdown
            _buildDropdown(
              label: 'Pronoun',
              value: _pronoun,
              items: ['They / their', 'He / him', 'She / her', 'Not specified'],
              onChanged: (val) => setState(() => _pronoun = val!),
            ),
            const SizedBox(height: 12),

            // Allow Replies dropdown
            _buildDropdown(
              label: 'Allow Replies From',
              value: _allowReplies,
              items: ['Anyone', 'Friends only', 'Nobody'],
              onChanged: (val) => setState(() => _allowReplies = val!),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 12, left: 2),
              child: Text(
                'Applies to new comments. You may override this default on each review or list.',
                style: TextStyle(color: Color(0xFF677785), fontSize: 12),
              ),
            ),

            // Custom Posters dropdown
            _buildDropdown(
              label: 'Custom Posters',
              value: _customPosters,
              items: ['Enabled', 'Disabled'],
              onChanged: (val) => setState(() => _customPosters = val!),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 20, left: 2),
              child: Text(
                'Select whether you see custom posters on other members\' content. The option to customize posters is available for Patron and HQ accounts.',
                style: TextStyle(color: Color(0xFF677785), fontSize: 12),
              ),
            ),

            // FAVORITE FILMS
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FAVORITE FILMS',
                  style: TextStyle(
                    color: Color(0xFF899AA9),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Drag to re-order',
                  style: TextStyle(color: Color(0xFF677785), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    height: 105,
                    margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF202830),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF2C3946)),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Color(0xFF677785), size: 24),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // AVATAR section
            const Text(
              'AVATAR',
              style: TextStyle(
                color: Color(0xFF899AA9),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF202830),
                  child: Icon(Icons.person, size: 36, color: Color(0xFF677785)),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Add or update your avatar in Advanced Settings. If you connect a Twitter account or have a Gravatar with the same email, it may appear here.',
                    style: TextStyle(
                      color: Color(0xFF899AA9),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Color(0xFF242E37)),

            // Settings items
            _buildSettingsTile('App icon'),
            _buildSettingsTile('Push notifications'),
            _buildSettingsTile('Email notifications'),
            _buildSettingsTile('Advanced settings'),
            _buildSettingsTile('Subscription settings'),
            _buildSettingsTile('Send logs', hasArrow: false),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Disable account',
                  style: TextStyle(color: Color(0xFFFF8000), fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '3.5.8 (504)',
              style: TextStyle(color: Color(0xFF455565), fontSize: 12),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF202830),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF899AA9),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF202830),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF899AA9),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF202830),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF899AA9)),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, {bool hasArrow = true}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Color(0xFFBAC6D0), fontSize: 14),
            ),
            if (hasArrow)
              const Icon(Icons.chevron_right, color: Color(0xFF899AA9), size: 18),
          ],
        ),
      ),
    );
  }
}
