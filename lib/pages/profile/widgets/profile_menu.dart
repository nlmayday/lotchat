import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuSection('账户管理', [
          MenuItem(
            icon: Icons.account_circle_outlined,
            title: '个人信息',
            onTap: () {
              // TODO: 导航到个人信息编辑页面
            },
          ),
          MenuItem(
            icon: Icons.lock_outline,
            title: '修改密码',
            onTap: () {
              // TODO: 导航到密码修改页面
            },
          ),
        ]),
        _buildMenuSection('钱包', [
          MenuItem(
            icon: Icons.account_balance_wallet_outlined,
            title: '充值',
            onTap: () {
              // TODO: 导航到充值页面
            },
          ),
          MenuItem(
            icon: Icons.receipt_long_outlined,
            title: '充值记录',
            onTap: () {
              // TODO: 导航到充值记录页面
            },
          ),
          MenuItem(
            icon: Icons.local_offer_outlined,
            title: '优惠券',
            badge: '2',
            onTap: () {
              // TODO: 导航到优惠券页面
            },
          ),
        ]),
        _buildMenuSection('其他', [
          MenuItem(
            icon: Icons.settings_outlined,
            title: '设置',
            onTap: () {
              // TODO: 导航到设置页面
            },
          ),
          MenuItem(
            icon: Icons.help_outline,
            title: '帮助与反馈',
            onTap: () {
              // TODO: 导航到帮助页面
            },
          ),
          MenuItem(
            icon: Icons.info_outline,
            title: '关于',
            onTap: () {
              // TODO: 导航到关于页面
            },
          ),
        ]),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: items.map((item) => _buildMenuItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.badge!,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
      onTap: item.onTap,
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final String? badge;
  final VoidCallback onTap;

  MenuItem({
    required this.icon,
    required this.title,
    this.badge,
    required this.onTap,
  });
}
