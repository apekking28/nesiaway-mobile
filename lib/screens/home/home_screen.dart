import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blog/blog_list_screen.dart';
import '../profile/profile_screen.dart';
import '../user/user_list_screen.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.user;
    final isAdmin = currentUser?.isAdmin ?? false;

    // Dynamic screens based on role
    final List<Widget> screens = [
      const BlogListScreen(),
      if (isAdmin) const UserListScreen(), // Admin only
      const ProfileScreen(),
    ];

    // Dynamic navigation items based on role
    final List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Blog'),
      if (isAdmin) // Admin only
        const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: navItems,
      ),
    );
  }
}
