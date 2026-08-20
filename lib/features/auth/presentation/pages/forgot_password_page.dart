import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetCode() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      context.read<AuthBloc>().add(AuthForgotPasswordSubmitted(email));
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
          if (state is AuthOtpSentState) {
            AppSnackbar.showSuccess(context, state.message);
            Navigator.of(context).pushNamed(
              '/otp-verify',
              arguments: {'email': state.email},
            );
          } else if (state is AuthFailureState) {
            AppSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: AppDimensions.screenPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Header
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          color: AppColors.primary,
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space2XL),

                    Text(
                      AppStrings.forgotPasswordTitle,
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.forgotPasswordSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space2XL),

                    // Error banner
                    if (state is AuthFailureState) ...[
                      CustomErrorBanner(
                        message: state.message,
                        onDismiss: () {
                          context.read<AuthBloc>().add(const AuthClearError());
                        },
                      ),
                      const SizedBox(height: AppDimensions.spaceL),
                    ],

                    CustomTextField(
                      label: AppStrings.email,
                      hintText: AppStrings.emailPlaceholder,
                      controller: _emailController,
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary, size: 20),
                      validator: Validators.validateEmail,
                      onFieldSubmitted: (_) => _onSendResetCode(),
                    ),
                    const SizedBox(height: AppDimensions.space2XL),

                    PrimaryButton(
                      text: AppStrings.sendResetCode,
                      isLoading: isLoading,
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: _onSendResetCode,
                    ),
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
