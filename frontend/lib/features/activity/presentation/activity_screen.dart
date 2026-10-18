import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.headerBackground,
          elevation: 0,
          title: const Text(
            'Activity',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: AppTheme.textSecondary),
              tooltip: 'Filter',
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppTheme.accentGreen,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: 'Friends'),
              Tab(text: 'You'),
              Tab(text: 'Incoming'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEmptyState(
              quote:
                  'No results.\n\nBut you wouldn\'t clap yet. Because making something disappear isn\'t enough.\nYou have to bring it back.',
            ),
            _buildEmptyState(
              quote:
                  'No recent activity.\n\nWhen you log, review, or like films, your activity will show up here.',
            ),
            _buildEmptyState(
              quote:
                  'No incoming notifications.\n\nMentions, followers, and comments will appear here.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({required String quote}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              quote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF899AA9),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
