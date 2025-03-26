import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky/providers/user_provider.dart';
import 'package:sky/pages/profile/widgets/profile_header.dart';
import 'package:sky/pages/profile/widgets/profile_menu.dart';
import 'package:sky/widgets/common_bottom_nav.dart';
import 'package:sky/api/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3;

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await AuthService.logout();
      if (!mounted) return;
      
      await context.read<UserProvider>().clearUser();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('退出失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                ProfileHeader(
                  user: user,
                  onEditAvatar: () => Navigator.pushNamed(context, '/profile/edit'),
                ),
                const SizedBox(height: 20),
                ProfileMenu(onLogout: _handleLogout),
              ],
            ),
          ),
          bottomNavigationBar: CommonBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/home');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context, '/favorites');
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, '/history');
                  break;
                case 3:
                  // 当前页面，无需跳转
                  break;
              }
            },
          ),
        );
      },
    );
  }
}
