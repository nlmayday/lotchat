import 'package:flutter/material.dart';
import 'package:sky/models/user.dart';
import 'package:sky/pages/profile/widgets/profile_header.dart';
import 'package:sky/pages/profile/widgets/profile_menu.dart';
import 'package:sky/widgets/common_bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3; // 我的页面索引为 3

  @override
  Widget build(BuildContext context) {
    final user = User(
      id: '1',
      username: '测试用户',
      email: 'test@example.com',
      avatar: 'assets/images/avator.png',
      token: 'dummy_token',
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            ProfileHeader(user: user),
            const SizedBox(height: 20),
            ProfileMenu(),
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
  }
}
