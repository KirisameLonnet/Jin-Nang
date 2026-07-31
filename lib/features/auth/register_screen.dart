import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../core/di.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_safe_area.dart';
import '../../widgets/pressable.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_loading) return;
    setState(() { _loading = true; _error = null; });
    try {
      final token = await Di.api.register(
          _emailCtrl.text.trim(), _passwordCtrl.text, _nameCtrl.text.trim());
      await Di.tokenStore.saveToken(token);
      if (mounted) context.go('/study');
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['error'] as String? ?? 'Registration failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48),
                      const Text('Create\nAccount',
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.morandiText, height: 1.1)),
                      const SizedBox(height: 8),
                      Text('Start your Chinese learning journey.',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                              color: AppColors.morandiText.withValues(alpha: 0.6))),
                      const SizedBox(height: 48),
                      _buildField('Name', _nameCtrl),
                      const SizedBox(height: 16),
                      _buildField('Email', _emailCtrl, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildField('Password', _passwordCtrl, obscure: true),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(_error!, style: const TextStyle(color: AppColors.semanticRed, fontWeight: FontWeight.w600)),
                      ],
                      const SizedBox(height: 32),
                      Pressable(
                        onPressed: _loading ? null : _register,
                        child: _buildButton(_loading ? 'Creating...' : 'Create Account', AppColors.lavenderPurple),
                      ),
                      const SizedBox(height: 16),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('Already have an account? ',
                            style: TextStyle(color: AppColors.morandiText.withValues(alpha: 0.6), fontWeight: FontWeight.w600)),
                        Pressable(
                          onPressed: () => context.go('/login'),
                          child: const Text('Sign In',
                              style: TextStyle(color: AppColors.lavenderPurple, fontWeight: FontWeight.w900)),
                        ),
                      ]),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl,
      {bool obscure = false, TextInputType? keyboardType}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.morandiText, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)],
        ),
        child: TextField(
          controller: ctrl,
          obscureText: obscure ? _obscure : false,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.morandiText),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: InputBorder.none,
            suffixIcon: obscure
                ? IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.naturalGray19),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ),
    ]);
  }

  Widget _buildButton(String label, Color color) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppColors.morandiText, width: 3),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)],
      ),
      child: Center(
        child: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
      ),
    );
  }
}
