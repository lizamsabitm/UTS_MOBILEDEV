import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_bottom_nav.dart';
import 'features/activity/presentation/activity_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/home/presentation/widgets/quick_log_sheet.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/search/presentation/search_screen.dart';

class LayarboxdApp extends StatelessWidget {
  const LayarboxdApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Layarboxd',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;

  final GlobalKey<ActivityScreenState> _activityKey =
      GlobalKey<ActivityScreenState>();

  late final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const SearchScreen(),
    ActivityScreen(key: _activityKey),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Tab Activity ada di IndexedStack (initState hanya jalan sekali) -> segarkan saat dibuka
    if (index == 2) _activityKey.currentState?.reload(silent: true);
  }

  void _onCenterPlusTapped() {
    QuickLogSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        onCenterTap: _onCenterPlusTapped,
      ),
    );
  }
}
