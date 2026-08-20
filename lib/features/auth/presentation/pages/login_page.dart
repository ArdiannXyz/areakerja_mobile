import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/role_constants.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../data/models/login_request_model.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  void _loadSavedEmail() {
    // Check if remember me was previously stored
    final storage = RepositoryProvider.of<LocalStorageService>(context, listen: false);
    final savedEmail = storage.getRememberMeEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _emailController.text = savedEmail;
      setState(() {
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = LoginRequestModel(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );
      context.read<AuthBloc>().add(AuthLoginSubmitted(request));
    }
  }

  void _fillDemoCredentials(String email, String password) {
    _emailController.text = email;
    _passwordController.text = password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            AppSnackbar.showSuccess(
              context,
              'Selamat datang, ${state.user.name}!',
            );

            // Role-based Navigation
            switch (state.user.role) {
              case UserRole.perusahaan:
                Navigator.of(context).pushReplacementNamed('/dashboard-perusahaan');
                break;
              case UserRole.kandidat:
              case UserRole.admin:
              case UserRole.pelamar:
              default:
                Navigator.of(context).pushReplacementNamed('/dashboard-pelamar');
                break;
            }
          } else if (state is AuthFailureState) {
            AppSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: AppDimensions.screenPadding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Logo & Branding
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.work_rounded,
                                color: AppColors.primary,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceM),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Area',
                                  style: AppTextStyles.heading2.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Kerja',
                                  style: AppTextStyles.heading2.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppStrings.appTagline,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space3XL),

                      // Card Container
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppDimensions.borderRadiusXL,
                          border: Border.all(color: AppColors.border, width: 1),
                          boxShadow: AppDimensions.cardShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.loginTitle,
                              style: AppTextStyles.heading3,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppStrings.loginSubtitle,
                              style: AppTextStyles.bodySmall,
                            ),
                            const SizedBox(height: AppDimensions.spaceXL),

                            // Error state banner if any
                            if (state is AuthFailureState) ...[
                              CustomErrorBanner(
                                message: state.message,
                                onDismiss: () {
                                  context.read<AuthBloc>().add(const AuthClearError());
                                },
                              ),
                              const SizedBox(height: AppDimensions.spaceL),
                            ],

                            // Email Field
                            CustomTextField(
                              label: AppStrings.email,
                              hintText: AppStrings.emailPlaceholder,
                              controller: _emailController,
                              isRequired: true,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: AppDimensions.spaceL),

                            // Password Field
                            CustomTextField(
                              label: AppStrings.password,
                              hintText: AppStrings.passwordPlaceholder,
                              controller: _passwordController,
                              isRequired: true,
                              isPassword: true,
                              textInputAction: TextInputAction.done,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              validator: Validators.validatePassword,
                              onFieldSubmitted: (_) => _onLoginPressed(),
                            ),
                            const SizedBox(height: AppDimensions.spaceM),

                            // Remember Me & Forgot Password Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        activeColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            _rememberMe = val ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppStrings.rememberMe,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/forgot-password');
                                  },
                                  child: Text(
                                    AppStrings.forgotPassword,
                                    style: AppTextStyles.link.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.space2XL),

                            // Submit Login Button
                            PrimaryButton(
                              text: AppStrings.login,
                              isLoading: isLoading,
                              icon: const Icon(
                                Icons.login_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: _onLoginPressed,
                            ),
                            const SizedBox(height: AppDimensions.spaceXL),

                            // Register redirect
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${AppStrings.dontHaveAccount} ',
                                  style: AppTextStyles.bodySmall,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/register');
                                  },
                                  child: Text(
                                    AppStrings.register,
                                    style: AppTextStyles.link.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space2XL),

                      // Quick Demo Accounts Helper
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppDimensions.borderRadiusM,
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.bolt_rounded,
                                  color: AppColors.warning,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Akun Demo Cepat (Klik untuk isi)',
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _DemoChip(
                                  label: 'Pelamar',
                                  color: AppColors.accent,
                                  onTap: () => _fillDemoCredentials(
                                    'pelamar@areakerja.com',
                                    'password123',
                                  ),
                                ),
                                _DemoChip(
                                  label: 'Perusahaan',
                                  color: AppColors.primary,
                                  onTap: () => _fillDemoCredentials(
                                    'perusahaan@areakerja.com',
                                    'password123',
                                  ),
                                ),
                                _DemoChip(
                                  label: 'Kandidat',
                                  color: AppColors.roleKandidat,
                                  onTap: () => _fillDemoCredentials(
                                    'kandidat@areakerja.com',
                                    'password123',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DemoChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DemoChip({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
