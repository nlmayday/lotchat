import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sky/providers/user_provider.dart';
import 'package:sky/pages/home/home_page.dart';
import 'package:sky/utils/theme.dart';
import 'package:sky/pages/profile/profile_page.dart';
import 'package:sky/pages/favorites/favorites_page.dart';
import 'package:sky/pages/history/history_page.dart';
import 'package:sky/pages/chat/chat_page.dart'; // 假设聊天页面路径为 chat_page.dart
import 'package:sky/widgets/auth_guard.dart';
import 'package:sky/pages/auth/login_page.dart';
import 'package:sky/pages/auth/register_page.dart';
import 'package:sky/pages/profile/profile_edit_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final userProvider = UserProvider();
await userProvider.loadUser();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ChangeNotifierProvider.value(
      value: userProvider,
      child: const MyApp(),
    ),
  );
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
          '/profile/edit': (context) => const ProfileEditPage(), // Add this line
          '/register': (context) => const RegisterPage(),
        },
      ),
    );
  }
}
