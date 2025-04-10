import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sky/providers/user_provider.dart';
import 'package:sky/pages/home/home_page.dart';
import 'package:sky/utils/theme.dart';
import 'package:sky/pages/profile/profile_page.dart';
import 'package:sky/pages/favorites/favorites_page.dart';
import 'package:sky/pages/history/history_page.dart';
import 'package:sky/pages/chat/chat_page.dart';
import 'package:sky/widgets/auth_guard.dart';
import 'package:sky/pages/auth/login_page.dart';
import 'package:sky/pages/auth/register_page.dart';
import 'package:sky/pages/auth/forgot_password_page.dart';
import 'package:sky/pages/wallet/recharge_page.dart';
import 'package:sky/pages/wallet/recharge_history_page.dart';
import 'package:sky/api/services/character_service.dart'; // 添加这行导入
import 'package:sky/pages/wallet/coupon_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CharacterService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider()..loadUser(),
      child: MaterialApp(
        title: 'Sky Chat',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        routes: {
          '/home': (context) => AuthGuard(child: const HomePage()),
          '/favorites': (context) => AuthGuard(child: const FavoritesPage()),
          '/history': (context) => AuthGuard(child: const HistoryPage()),
          '/profile': (context) => AuthGuard(child: const ProfilePage()),
          // '/profile/edit': (context) => const ProfileEditPage(),
          '/chat': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, String>;
            return AuthGuard(
              child: ChatPage(
                characterId: args['characterId']!,
                // character: args['character']!, // 确保传递了 character 参数
              ),
            );
          },
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/forgot-password': (context) => const ForgotPasswordPage(),
          // 暂时注释掉充值页面路由，等待 RechargePage 类的实现
          '/wallet/recharge': (context) => const RechargePage(),
          '/wallet/history': (context) => const RechargeHistoryPage(),
          '/wallet/coupons': (context) => const CouponPage(),
        },
      ),
    );
  }
}
