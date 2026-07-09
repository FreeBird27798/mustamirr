import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onReset() {
    if (_formKey.currentState!.validate()) {
      // TODO: call reset password API with widget.email + new password
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Back button + title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.verifyOtp),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                      const Text(
                        'تعيين كلمة المرور',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.key_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // New password
                  const Text(
                    'كلمة السر الجديدة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _passwordController,
                    hintText: '••••••••••••••••••',
                    suffixIcon: Icons.lock_outline,
                    prefixIcon: Icons.remove_red_eye_outlined,
                    obscureText: _obscurePassword,
                    onPrefixTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      if (value.length < 8) {
                        return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Confirm password
                  const Text(
                    'تأكيد كلمة السر الجديدة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _confirmController,
                    hintText: '••••••••••••••••••',
                    suffixIcon: Icons.lock_outline,
                    prefixIcon: Icons.remove_red_eye_outlined,
                    obscureText: _obscureConfirm,
                    onPrefixTap: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء تأكيد كلمة المرور';
                      }
                      if (value != _passwordController.text) {
                        return 'كلمة المرور غير متطابقة';
                      }
                      return null;
                    },
                  ),

                  const Spacer(),

                  AuthButton(
                    label: 'إعادة تعيين كلمة المرور',
                    onPressed: _onReset,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
