import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/blocs/auth/auth_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/core/utils/form_validator.dart';
import 'package:perfect/cubits/user_cubit.dart/user_cubit.dart';
import 'package:perfect/models/user_model.dart';
import 'package:perfect/widgets/custom_button.dart';
import 'package:perfect/widgets/custom_snackbar.dart';
import 'package:perfect/widgets/custom_text_form_field.dart';
import 'package:perfect/widgets/google_logo.dart';
import 'package:perfect/widgets/sign_in_up_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    final responsive = ResponsiveConfig(ctx);
    final authBloc = BlocProvider.of<AuthBloc>(ctx);

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
          print(state.message);
          showCustomSnackbar(
              context: context,
              message: "Error with your credentials",
              size: responsive,
              backgroundColor: PColors.error);
        } else if (state is Authenticated) {
          ctx.read<UserCubit>().setUserDetails(
              uid: state.userModel!.uid!,
              name: state.userModel!.name!,
              email: state.userModel!.email!,
              phone: state.userModel!.Phonenumber!);
          Navigator.pushNamed(context, '/homepage');
        }
      },
      child: Scaffold(
        backgroundColor: PColors.backgrndPrimary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SignInUpBar(
                inOrUP: 'SIGN UP',
                description: 'REGISTER TO START LEARNING \nFrom PERFECT',
              ),
              SizedBox(height: responsive.spacingMedium),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: responsive.spacingMedium),
                child: _buildSignUpForm(authBloc, responsive),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(AuthBloc authBloc, ResponsiveConfig responsive) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNameField(),
          SizedBox(height: responsive.spacingSmall),
          _buildPhoneField(),
          SizedBox(height: responsive.spacingSmall),
          _buildEmailField(),
          SizedBox(height: responsive.spacingSmall),
          _buildPasswordField(),
          SizedBox(height: responsive.spacingSmall),
          _buildConfirmPasswordField(),
          SizedBox(height: responsive.spacingLarge),
          _buildSignUpButton(authBloc),
          SizedBox(height: responsive.spacingSmall),
          _buildOrDivider(),
          SizedBox(height: responsive.spacingSmall),
          _buildGoogleLogin(authBloc),
          SizedBox(height: responsive.spacingSmall),
          _buildLoginText(context),
          SizedBox(height: responsive.spacingSmall),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextFormField(
        controller: nameController,
        hintText: "Full name",
        prefixIcon: Icons.person,
        validator: (value) => Validator.validateName(value));
  }

  Widget _buildPhoneField() {
    return CustomTextFormField(
      controller: phoneNumberController,
      hintText: 'Phone Number',
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
      prefixText: '+91 ',
      maxLength: 10,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        return Validator.validatePhoneNumber(value);
      },
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
        obscureText: true,
        controller: passwordController,
        hintText: 'Password',
        prefixIcon: Icons.lock,
        validator: (value) {
          return Validator.validatePassword(value);
        });
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextFormField(
      obscureText: true,
      controller: confirmPasswordController,
      hintText: 'Confirm Password',
      prefixIcon: Icons.lock_outline,
      validator: (value) {
        if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildSignUpButton(AuthBloc authBloc) {
    return CustomButton(
      text: 'Sign Up',
      onPressed: () {
        if (Validator.checkFormValid(_formKey)) {
          final user = UserModel(
            email: emailController.text.trim(),
            password: passwordController.text,
            name: nameController.text,
            Phonenumber: phoneNumberController.text,
          );
          authBloc.add(SignUpEvent(user: user, context: context));
        }
      },
    );
  }

  Widget _buildOrDivider() {
    return Text(
      'OR',
      style: TextStyle(
        color: PColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGoogleLogin(AuthBloc authBloc) {
    return InkWell(
      onTap: () => authBloc.add(GoogleSignInEvent(context: context)),
      child: const GoogleLogo(),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/signIn'),
          child: Text("Sign In", style: TextStyle(color: PColors.primary)),
        ),
      ],
    );
  }
}
