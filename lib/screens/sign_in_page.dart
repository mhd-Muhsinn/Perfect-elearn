import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/blocs/auth/auth_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/core/utils/form_validator.dart';
import 'package:perfect/widgets/custom_button.dart';
import 'package:perfect/widgets/custom_snackbar.dart';
import 'package:perfect/widgets/custom_text_form_field.dart';
import 'package:perfect/widgets/google_logo.dart';
import 'package:perfect/widgets/sign_in_up_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveConfig(context);
    final authbloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is NeedProfileCompletion) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/profilecompletion',
            (route) => false,
            arguments: state.user.uid,
          );
        }
        if (state is AuthenticatedError) {
          showCustomSnackbar(
              context: context, message: state.message, size: responsive,backgroundColor: PColors.error);
        } else if (state is Authenticated) {
          Navigator.pushNamed(context, '/homepage');
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SignInUpBar(
                inOrUP: 'SIGN IN',
                description:
                    'WELCOME BACK!\nContinue Your Learning Journey with PERFECT',
              ),
              SizedBox(height: responsive.spacingMedium),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _buildForm(context, authbloc, responsive),
              ),
            ],
          ),
        ),
      ),
    );
  }

//Form
  Widget _buildForm(
      BuildContext context, AuthBloc authbloc, ResponsiveConfig responsive) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: responsive.spacingLarge),
          _buildEmailField(),
          SizedBox(height: responsive.spacingSmall),
          _buildPasswordField(),
          SizedBox(height: responsive.spacingSmall),
          _buildForgotPassword(context, authbloc),
          SizedBox(height: responsive.spacingSmall),
          CustomButton(
            text: 'Sign In',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                authbloc.add(SignInEvent(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                ));
              }
            },
          ),
          const SizedBox(height: 15),
          Text('OR',
              style: TextStyle(
                  color: PColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => authbloc.add(GoogleSignInEvent()),
            child: GoogleLogo(),
          ),
          const SizedBox(height: 20),
          _buildRegisterRow(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextFormField(
      controller: emailController,
      hintText: "Enter Your email",
      prefixIcon: Icons.email,
      validator: (value) {
        return Validator.validateEmail(value);
      },
    );
  }

  Widget _buildPasswordField() {
    return CustomTextFormField(
      controller: passwordController,
      hintText: "Password",
      prefixIcon: Icons.lock,
      obscureText: true,
      validator: (value) {
        return Validator.validatePassword(value);
      },
    );
  }

  Widget _buildForgotPassword(BuildContext context, AuthBloc authbloc) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => _buildForgotPasswordDialog(context, authbloc),
          );
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: PColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildRegisterRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("REGISTER", style: TextStyle(color: PColors.primary)),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordDialog(BuildContext context, AuthBloc authbloc) {
    final dialogFormKey = GlobalKey<FormState>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: PColors.primary,
      title: Text("Forgot Password", style: TextStyle(color: PColors.white)),
      content: Form(
        key: dialogFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Enter your email and click on Reset Password.",
                style: TextStyle(color: PColors.white)),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              validator: (value) {
                return Validator.validateEmail(value);
              },
              decoration: InputDecoration(
                hintText: "Email",
                filled: true,
                fillColor: PColors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: PColors.white)),
        ),
        TextButton(
          onPressed: () {
            if (dialogFormKey.currentState!.validate()) {
              authbloc
                  .add(ForgotPasswordEvent(email: emailController.text.trim()));
              Navigator.pop(context);
            }
          },
          child: Text("Reset", style: TextStyle(color: PColors.white)),
        ),
      ],
    );
  }
}
