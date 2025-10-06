import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:perfect/blocs/auth/auth_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/core/utils/form_validator.dart';
import 'package:perfect/models/user_model.dart';
import 'package:perfect/widgets/custom_button.dart';
import 'package:perfect/widgets/custom_text_form_field.dart';

class ProfileCompletionPage extends StatefulWidget {
  const ProfileCompletionPage({
    super.key,
  });

  @override
  State<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    final Size = ResponsiveConfig(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ProfileCompleted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/homepage', (route) => false);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: Size.spacingMedium),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: _buildForm(authBloc, Size, uid),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 30),
      decoration: BoxDecoration(
        color: PColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: const Text(
        "COMPLETE YOUR PROFILE",
        style: TextStyle(
          color: PColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildForm(
      AuthBloc authBloc, ResponsiveConfig responsive, String uid) {
    return Column(
      children: [
        _buildNameField(),
        SizedBox(height: responsive.spacingSmall),
        _buildPhoneField(),
        SizedBox(height: responsive.spacingSmall),
        _buildEmailField(),
        const SizedBox(height: 45),
        _buildCompleteButton(authBloc, uid),
      ],
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
      maxLength: 10,
      prefixText: '+91 ',
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        return Validator.validatePhoneNumber(value);
      },
    );
  }

  Widget _buildEmailField() {
    return CustomTextFormField(
      controller: emailController,
      hintText: "Your Email",
      prefixIcon: Icons.email,
      validator: (value) {
        return Validator.validateEmail(value);
      },
    );
  }

  Widget _buildCompleteButton(AuthBloc authBloc, String uid) {
    return CustomButton(
      text: 'Complete',
      onPressed: () {
        if (Validator.checkFormValid(_formKey)) {
          final user = UserModel(
            uid: uid,
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            Phonenumber: phoneNumberController.text.trim(),
          );
          authBloc.add(CompleteProfileEvent(user: user, uid: user.uid));
        }
      },
    );
  }
}
