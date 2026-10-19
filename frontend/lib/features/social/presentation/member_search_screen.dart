import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../data/social_models.dart';
import '../data/social_service.dart';
import 'user_profile_screen.dart';
import 'widgets/follow_button.dart';

class MemberSearchScreen extends StatefulWidget {
  const MemberSearchScreen({Key? key}) : super(key: key);

  @override
  State<MemberSearchScreen> createState() => _MemberSearchScreenState();
}

class _MemberSearchScreenState extends State<MemberSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final SocialService _service = SocialService();
  Timer? _debounce;
  List<SocialUser> _results = [];
  bool _loading = false;
  bool _searched = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = value.trim();
      if (query.isEmpty) {
        setState(() {
          _results = [];
          _searched = false;
          _loading = false;
          _error = null;
        });
      } else {
        _search(query);
      }
    });
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _searched = true;
      _error = null;
    });
    try {
      final results = await _service.searchUsers(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = friendlyError(e);
      });
    }
  }

  Future<void> _openProfile(SocialUser user) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => UserProfileScreen(userId: user.id)),
    );
    // Status follow bisa berubah di halaman profil -> segarkan hasil
    final query = _controller.text.trim();
    if (mounted && query.isNotEmpty) _search(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.headerBackground,
        elevation: 0,
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: _onChanged,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
            decoration: const InputDecoration(
              hintText: 'Search members',
              hintStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
              prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingState(message: 'Searching...');
    if (_error != null) {
      return ErrorState(message: _error!, onRetry: () => _search(_controller.text.trim()));
    }
    if (!_searched) {
      return const EmptyState(message: 'Search members by username or name.');
    }
    if (_results.isEmpty) {
      return EmptyState(message: 'No members found for "${_controller.text.trim()}".');
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(color: Color(0xFF242E37), height: 1),
      itemBuilder: (context, index) {
        final user = _results[index];
        final initial = user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : 'U';
        return ListTile(
          onTap: () => _openProfile(user),
          leading: CircleAvatar(
            backgroundColor: AppTheme.accentGreen,
            child: Text(
              initial,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(user.displayName, style: const TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text(
            '@${user.username}',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          trailing: FollowButton(
            key: ValueKey('search-follow-${user.id}'),
            userId: user.id,
            initialFollowing: user.isFollowing,
            onChanged: (value) => user.isFollowing = value,
          ),
        );
      },
    );
  }
}