import 'dart:developer';

import 'package:acp_web/helpers/constants.dart';
import 'package:acp_web/pages/login_page/access_code_popup.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sf;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/pages/login_page/reset_password_popup.dart';
import 'package:acp_web/pages/widgets/custom_button.dart';
import 'package:acp_web/pages/widgets/toggle_icon.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/services/api_error_handler.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  bool passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final mobile = MediaQuery.of(context).size.width < mobileSize;

    Future<void> login() async {
      //Login
      try {
        // Check if user exists
        //if it doesnt return
        final userId = await userState.getUserId(userState.emailController.text);

        if (userId == null) {
          await ApiErrorHandler.callToast('Usuario y/o contraseña incorrecta');
          return;
        }

        // final userIsBlocked = await userState.checkIfUserBlocked(
        //   userState.emailController.text,
        // );
        // if (userIsBlocked) {
        //   if (!mounted) return;
        //   await showDialog(
        //     context: context,
        //     builder: (_) => const AccessBlockedPopup(),
        //   );
        //   return;
        // }

        //Validate password
        await supabase.auth.signInWithPassword(
          email: userState.emailController.text,
          password: userState.passwordController.text,
        );
        await supabase.auth.signOut();
        //send access code
        final emailSent = await userState.sendAccessCode(userId);
        if (!emailSent) {
          await ApiErrorHandler.callToast('Error al enviar código de acceso');
          return;
        }
        //show access code popup
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (_) => AccessCodePopup(userId: userId),
        );
        return;
      } catch (e) {
        if (e is sf.AuthException) {
          await userState.incrementLoginAttempts(
            userState.emailController.text,
          );
          await ApiErrorHandler.callToast('Usuario y/o contraseña incorrecta');

          return;
        }
        log('Error al iniciar sesion - $e');
      }
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/Logo.png',
            height: 118,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 28.5),
          Container(
            width: 464,
            height: 550,
            padding: EdgeInsets.all(mobile ? 20 : 40),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF022B79),
                  Color(0xFF0078E2),
                ],
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Inicio de Sesión',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: userState.emailController,
                      onFieldSubmitted: (value) async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        await login();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El correo es requerido';
                        } else if (!EmailValidator.validate(value)) {
                          return 'Por favor ingresa un correo válido';
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration('Usuario'),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: const Color.fromARGB(204, 0, 0, 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: userState.passwordController,
                      obscureText: !passwordVisibility,
                      onFieldSubmitted: (value) async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        await login();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña es requerida';
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration('Contraseña', isPassword: true),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: const Color.fromARGB(204, 0, 0, 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ToggleIcon(
                        onPressed: () async {
                          userState.updateRecuerdame();
                        },
                        value: userState.recuerdame,
                        onIcon: const Icon(
                          Icons.radio_button_checked,
                          color: Colors.white,
                          size: 28,
                        ),
                        offIcon: const Icon(
                          Icons.radio_button_off,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Recordarme',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => const ResetPasswordPopup(),
                    ),
                    child: Text(
                      '¿Olvidaste tu Contraseña?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: const Color.fromARGB(204, 255, 255, 255),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      await login();
                    },
                    text: 'Ingresar',
                    options: ButtonOptions(
                      width: 200,
                      height: 50,
                      color: const Color(0xFF1C1C1C),
                      textStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: Color.fromARGB(102, 255, 255, 255),
                        size: 42,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Acceso\nseguro',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color.fromARGB(102, 255, 255, 255),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: 2,
                          height: 40,
                          color: const Color.fromARGB(102, 255, 255, 255),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'La seguridad es nuestra prioridad, por\neso usamos los estándares mas altos.',
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: const Color.fromARGB(102, 255, 255, 255),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, {bool isPassword = false}) {
    Widget? suffixIcon;
    if (isPassword) {
      suffixIcon = InkWell(
        onTap: () => setState(
          () => passwordVisibility = !passwordVisibility,
        ),
        focusNode: FocusNode(skipTraversal: true),
        child: Icon(
          passwordVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: const Color.fromARGB(204, 0, 0, 0),
          size: 22,
        ),
      );
    }
    return InputDecoration(
      hintText: label,
      filled: true,
      isCollapsed: true,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 15,
        bottom: 15,
      ),
      fillColor: Colors.white,
      hintStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: const Color.fromARGB(204, 0, 0, 0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
