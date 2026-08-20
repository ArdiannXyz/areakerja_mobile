import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/role_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../data/models/login_request_model.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserRole _selectedRole = UserRole.pelamar;
  bool _agreeTerms = false;
  bool _termsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    setState(() {
      _termsError = !_agreeTerms;
    });

    if ((_formKey.currentState?.validate() ?? false) && _agreeTerms) {
      final request = RegisterRequestModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        companyName: _selectedRole == UserRole.perusahaan ? _companyController.text.trim() : null,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        role: _selectedRole.value,
      );
      context.read<AuthBloc>().add(AuthRegisterSubmitted(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            AppSnackbar.showSuccess(
              context,
              'Akun berhasil didaftarkan! Selamat datang, ${state.user.name}',
            );

            // Role-based Navigation
            switch (state.user.role) {
              case UserRole.perusahaan:
                Navigator.of(context).pushNamedAndRemoveUntil('/dashboard-perusahaan', (route) => false);
                break;
              case UserRole.kandidat:
                Navigator.of(context).pushNamedAndRemoveUntil('/dashboard-kandidat', (route) => false);
                break;
              case UserRole.pelamar:
              default:
                Navigator.of(context).pushNamedAndRemoveUntil('/dashboard-pelamar', (route) => false);
                break;
            }
          } else if (state is AuthFailureState) {
            AppSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      AppStrings.registerTitle,
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.registerSubtitle,
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: AppDimensions.spaceXL),

                    // Role Selector Tabs
                    Text(
                      AppStrings.selectRole,
                      style: AppTextStyles.labelLarge.copyWith(fontSize: 13.5),
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.border.withValues(alpha: 0.5),
                        borderRadius: AppDimensions.borderRadiusM,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _RoleTabItem(
                              title: AppStrings.rolePelamar,
                              icon: Icons.person_outline_rounded,
                              isSelected: _selectedRole == UserRole.pelamar,
                              onTap: () {
                                setState(() {
                                  _selectedRole = UserRole.pelamar;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: _RoleTabItem(
                              title: 'Perusahaan',
                              icon: Icons.business_outlined,
                              isSelected: _selectedRole == UserRole.perusahaan,
                              onTap: () {
                                setState(() {
                                  _selectedRole = UserRole.perusahaan;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXL),

                    // Error state banner
                    if (state is AuthFailureState) ...[
                      CustomErrorBanner(
                        message: state.message,
                        onDismiss: () {
                          context.read<AuthBloc>().add(const AuthClearError());
                        },
                      ),
                      const SizedBox(height: AppDimensions.spaceL),
                    ],

                    // Full Name Field
                    CustomTextField(
                      label: AppStrings.fullName,
                      hintText: AppStrings.fullNamePlaceholder,
                      controller: _nameController,
                      isRequired: true,
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary, size: 20),
                      validator: (val) => Validators.validateRequired(val, fieldName: 'Nama lengkap'),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),

                    // Company Name Field (if role == perusahaan)
                    if (_selectedRole == UserRole.perusahaan) ...[
                      CustomTextField(
                        label: AppStrings.companyName,
                        hintText: AppStrings.companyNamePlaceholder,
                        controller: _companyController,
                        isRequired: true,
                        prefixIcon: const Icon(Icons.apartment_rounded, color: AppColors.textSecondary, size: 20),
                        validator: (val) => Validators.validateRequired(val, fieldName: 'Nama perusahaan'),
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
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary, size: 20),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),

                    // Phone Field
                    CustomTextField(
                      label: AppStrings.phoneNumber,
                      hintText: AppStrings.phoneNumberPlaceholder,
                      controller: _phoneController,
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 20),
                      validator: Validators.validatePhone,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),

                    // Password Field
                    CustomTextField(
                      label: AppStrings.password,
                      hintText: AppStrings.passwordPlaceholder,
                      controller: _passwordController,
                      isRequired: true,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary, size: 20),
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),

                    // Confirm Password Field
                    CustomTextField(
                      label: AppStrings.confirmPassword,
                      hintText: AppStrings.confirmPasswordPlaceholder,
                      controller: _confirmPasswordController,
                      isRequired: true,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.textSecondary, size: 20),
                      validator: (val) => Validators.validateConfirmPassword(val, _passwordController.text),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),

                    // Terms and Conditions Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _agreeTerms,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _agreeTerms = val ?? false;
                                if (_agreeTerms) _termsError = false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppStrings.agreeTerms,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: _termsError ? AppColors.danger : AppColors.textSecondary,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_termsError) ...[
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.termsMustBeAccepted,
                        style: AppTextStyles.caption.copyWith(color: AppColors.danger),
                      ),
                    ],
                    const SizedBox(height: AppDimensions.space2XL),

                    // Submit Register Button
                    PrimaryButton(
                      text: AppStrings.register,
                      isLoading: isLoading,
                      icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 18),
                      onPressed: _onRegisterPressed,
                    ),
                    const SizedBox(height: AppDimensions.spaceXL),

                    // Login redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${AppStrings.haveAccount} ',
                          style: AppTextStyles.bodySmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppStrings.login,
                            style: AppTextStyles.link.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space2XL),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RoleTabItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleTabItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: 13,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
