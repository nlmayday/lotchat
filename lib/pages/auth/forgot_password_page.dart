import 'package:flutter/material.dart';
import 'package:sky/api/services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.forgotPassword(_emailController.text);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送重置邮件失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('忘记密码'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _emailSent ? _buildSuccessView() : _buildFormView(),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '请输入您的注册邮箱，我们将发送重置密码的链接到您的邮箱',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: '邮箱',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入邮箱';
              }
              if (!value.contains('@')) {
                return '请输入有效的邮箱地址';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _resetPassword,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('发送重置邮件'),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('返回登录'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 80,
          color: Colors.green,
        ),
        const SizedBox(height: 20),
        const Text(
          '重置邮件已发送',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          '我们已向 ${_emailController.text} 发送了重置密码的邮件，请查收并按照邮件中的指引重置您的密码。',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: const Text('返回登录'),
        ),
      ],
    );
  }
}