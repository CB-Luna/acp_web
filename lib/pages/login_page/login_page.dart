import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sf;

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/helpers/supabase/queries.dart';
import 'package:acp_web/providers/user_provider.dart';
import 'package:acp_web/services/api_error_handler.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/pages/login_page/access_blocked_popup.dart';
import 'package:acp_web/pages/login_page/access_code_popup.dart';
import 'package:acp_web/pages/login_page/reset_password_popup.dart';
import 'package:acp_web/pages/widgets/custom_button.dart';
import 'package:acp_web/pages/widgets/toggle_icon.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    this.token,
  }) : super(key: key);

  final Token? token;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisibility = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);

    Future<void> login() async {
      //Login
      try {
        // Check if user exists
        //if it doesnt return
        final userId = await userState.getUserId(userState.emailController.text);

        if (userId == null) {
          await ApiErrorHandler.callToast('El correo no está registrado');
          return;
        }

        //Check if token exists
        if (widget.token == null) {
          final userIsBlocked = await userState.checkIfUserBlocked(
            userState.emailController.text,
          );
          if (userIsBlocked) {
            if (!mounted) return;
            await showDialog(
              context: context,
              builder: (_) => const AccessBlockedPopup(),
            );
            return;
          }
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
        }

        //if it exists = validate, login and dont ask for access code
        final tokenValid = await widget.token!.validate('ingreso');
        if (!tokenValid) {
          //mostrar mensaje de error
          await ApiErrorHandler.callToast(
            'Contraseña inválida',
          );
          return;
        }

        await supabase.auth.signInWithPassword(
          email: userState.emailController.text,
          password: userState.passwordController.text,
        );

        if (userState.recuerdame == true) {
          await userState.setEmail();
          await userState.setPassword();
        } else {
          userState.emailController.text = '';
          userState.passwordController.text = '';
          await prefs.remove('email');
          await prefs.remove('password');
        }

        if (supabase.auth.currentUser == null) {
          await ApiErrorHandler.callToast();
          return;
        }

        currentUser = await SupabaseQueries.getCurrentUserData();

        if (currentUser == null) {
          await ApiErrorHandler.callToast();
          return;
        }

        if (currentUser!.activado == false) {
          await ApiErrorHandler.callToast('El usuario está desactivado');
          await supabase.auth.signOut();
          return;
        }

        await userState.checkIfUserChangedPasswordInLast90Days(currentUser!.id);

        if (!userState.userChangedPasswordInLast90Days) {
          if (!mounted) return;
          context.pushReplacement('/cambio-contrasena');
          return;
        }

        if (!currentUser!.cambioContrasena) {
          if (!mounted) return;
          context.pushReplacement('/cambio-contrasena');
          return;
        }

        // userState.registerLogin(currentUser!.id);

        if (!mounted) return;
        context.pushReplacement('/');
      } catch (e) {
        if (e is sf.AuthException) {
          await userState.incrementLoginAttempts(
            userState.emailController.text,
          );
          await ApiErrorHandler.callToast('Credenciales inválidas');

          return;
        }
        log('Error al iniciar sesion - $e');
      }
    }

    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/images/bgacp.png').image,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 113.33,
                right: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 28.5),
                    Container(
                      // width: 464,
                      // height: 519,
                      padding: const EdgeInsets.all(40),
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
                            Text('Usuario'),
                            Text('Contraseña'),
                            Text('Recordarme'),
                            Text('¿Olvidaste tu Contraseña?'),
                            Text('Ingresar'),
                            Text('La seguridad...'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   key: scaffoldKey,
    //   backgroundColor: AppTheme.of(context).primaryBackground,
    //   body: GestureDetector(
    //     onTap: () => FocusScope.of(context).unfocus(),
    //     child: Container(
    //       width: double.infinity,
    //       height: double.infinity,
    //       decoration: BoxDecoration(
    //         color: Colors.black,
    //         image: DecorationImage(
    //           fit: BoxFit.cover,
    //           image: Image.asset('assets/images/bg1.png').image,
    //         ),
    //       ),
    //       child: Stack(
    //         children: [
    //           Positioned(
    //             top: 50,
    //             left: 100,
    //             child: Image.asset(
    //               'assets/images/LogoBlanco.png',
    //               height: 50,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //           Center(
    //             child: Form(
    //               key: formKey,
    //               child: SingleChildScrollView(
    //                 child: Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
    //                       child: Text(
    //                         'Inicio de sesión',
    //                         style: AppTheme.of(context).bodyText1.override(
    //                               fontFamily: 'Bicyclette-Light',
    //                               color: Colors.white,
    //                               fontSize: 60,
    //                               fontWeight: FontWeight.w600,
    //                               useGoogleFonts: false,
    //                             ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width * 0.3,
    //                       child: TextFormField(
    //                         controller: userState.emailController,
    //                         onFieldSubmitted: (value) async {
    //                           if (!formKey.currentState!.validate()) {
    //                             return;
    //                           }
    //                           await login();
    //                         },
    //                         validator: (value) {
    //                           if (value == null || value.isEmpty) {
    //                             return 'El correo es requerido';
    //                           } else if (!EmailValidator.validate(value)) {
    //                             return 'Por favor ingresa un correo válido';
    //                           }
    //                           return null;
    //                         },
    //                         decoration: InputDecoration(
    //                           labelText: 'Usuario',
    //                           hintText: 'Usuario',
    //                           labelStyle: AppTheme.of(context).bodyText2.override(
    //                                 fontFamily: 'Poppins',
    //                                 color: Colors.white,
    //                                 fontWeight: FontWeight.normal,
    //                               ),
    //                           hintStyle: AppTheme.of(context).bodyText2.override(
    //                                 fontFamily: 'Poppins',
    //                                 color: Colors.white,
    //                                 fontWeight: FontWeight.normal,
    //                               ),
    //                           enabledBorder: const UnderlineInputBorder(
    //                             borderSide: BorderSide(
    //                               color: Colors.white,
    //                               width: 1,
    //                             ),
    //                             borderRadius: BorderRadius.only(
    //                               topLeft: Radius.circular(4.0),
    //                               topRight: Radius.circular(4.0),
    //                             ),
    //                           ),
    //                           focusedBorder: const UnderlineInputBorder(
    //                             borderSide: BorderSide(
    //                               color: Colors.white,
    //                               width: 1,
    //                             ),
    //                             borderRadius: BorderRadius.only(
    //                               topLeft: Radius.circular(4.0),
    //                               topRight: Radius.circular(4.0),
    //                             ),
    //                           ),
    //                         ),
    //                         style: AppTheme.of(context).bodyText1.override(
    //                               fontFamily: 'Poppins',
    //                               color: Colors.white,
    //                               fontSize: 15,
    //                               fontWeight: FontWeight.normal,
    //                             ),
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
    //                       child: SizedBox(
    //                         width: MediaQuery.of(context).size.width * 0.3,
    //                         child: TextFormField(
    //                           controller: userState.passwordController,
    //                           obscureText: !passwordVisibility,
    //                           onFieldSubmitted: (value) async {
    //                             if (!formKey.currentState!.validate()) {
    //                               return;
    //                             }
    //                             await login();
    //                           },
    //                           validator: (value) {
    //                             if (value == null || value.isEmpty) {
    //                               return 'La contraseña es requerida';
    //                             }
    //                             return null;
    //                           },
    //                           decoration: InputDecoration(
    //                             labelText: 'Contraseña',
    //                             hintText: 'Contraseña',
    //                             hintStyle: AppTheme.of(context).bodyText2.override(
    //                                   fontFamily: 'Poppins',
    //                                   color: Colors.white,
    //                                   fontWeight: FontWeight.normal,
    //                                 ),
    //                             labelStyle: AppTheme.of(context).bodyText2.override(
    //                                   fontFamily: 'Poppins',
    //                                   color: Colors.white,
    //                                   fontWeight: FontWeight.normal,
    //                                 ),
    //                             enabledBorder: const UnderlineInputBorder(
    //                               borderSide: BorderSide(
    //                                 color: Colors.white,
    //                                 width: 1,
    //                               ),
    //                               borderRadius: BorderRadius.only(
    //                                 topLeft: Radius.circular(4.0),
    //                                 topRight: Radius.circular(4.0),
    //                               ),
    //                             ),
    //                             focusedBorder: const UnderlineInputBorder(
    //                               borderSide: BorderSide(
    //                                 color: Colors.white,
    //                                 width: 1,
    //                               ),
    //                               borderRadius: BorderRadius.only(
    //                                 topLeft: Radius.circular(4.0),
    //                                 topRight: Radius.circular(4.0),
    //                               ),
    //                             ),
    //                             suffixIcon: InkWell(
    //                               onTap: () => setState(
    //                                 () => passwordVisibility = !passwordVisibility,
    //                               ),
    //                               focusNode: FocusNode(skipTraversal: true),
    //                               child: Icon(
    //                                 passwordVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
    //                                 color: Colors.white,
    //                                 size: 22,
    //                               ),
    //                             ),
    //                           ),
    //                           style: AppTheme.of(context).bodyText1.override(
    //                                 fontFamily: 'Poppins',
    //                                 color: Colors.white,
    //                                 fontSize: 15,
    //                                 fontWeight: FontWeight.normal,
    //                               ),
    //                         ),
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
    //                       child: Row(
    //                         mainAxisSize: MainAxisSize.max,
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
    //                             child: ToggleIcon(
    //                               onPressed: () async {
    //                                 userState.updateRecuerdame();
    //                               },
    //                               value: userState.recuerdame,
    //                               onIcon: const Icon(
    //                                 Icons.check_circle_outline_sharp,
    //                                 color: Color(0xFF03C774),
    //                                 size: 36,
    //                               ),
    //                               offIcon: const Icon(
    //                                 Icons.circle,
    //                                 color: Color(0xFF03C774),
    //                                 size: 36,
    //                               ),
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
    //                             child: Text(
    //                               'Recordarme',
    //                               style: AppTheme.of(context).bodyText1.override(
    //                                     fontFamily: 'Montserrat',
    //                                     color: Colors.white,
    //                                     fontSize: 18,
    //                                     fontWeight: FontWeight.w500,
    //                                   ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 5, 0),
    //                       child: InkWell(
    //                         onTap: () => showDialog(
    //                           context: context,
    //                           builder: (_) => const ResetPasswordPopup(),
    //                         ),
    //                         child: Text(
    //                           '¿Olvidaste tu contraseña?',
    //                           style: AppTheme.of(context).bodyText1.override(
    //                                 fontFamily: 'Montserrat',
    //                                 color: Colors.white,
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight.normal,
    //                                 decoration: TextDecoration.underline,
    //                               ),
    //                         ),
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
    //                       child: CustomButton(
    //                         onPressed: () async {
    //                           if (!formKey.currentState!.validate()) {
    //                             return;
    //                           }
    //                           await login();
    //                         },
    //                         text: 'Ingresar',
    //                         options: ButtonOptions(
    //                           width: 200,
    //                           height: 50,
    //                           color: const Color(0xFF03C774),
    //                           textStyle: AppTheme.of(context).subtitle2.override(
    //                                 fontFamily: 'Poppins',
    //                                 color: Colors.white,
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight.normal,
    //                               ),
    //                           borderSide: const BorderSide(
    //                             color: Colors.transparent,
    //                             width: 1,
    //                           ),
    //                           borderRadius: BorderRadius.circular(30),
    //                         ),
    //                       ),
    //                     ),
    //                     /* const MSLoginButton(), */
    //                     Padding(
    //                       padding: const EdgeInsetsDirectional.fromSTEB(15, 40, 15, 0),
    //                       child: Row(
    //                         mainAxisSize: MainAxisSize.min,
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           Row(
    //                             mainAxisSize: MainAxisSize.max,
    //                             children: [
    //                               const Padding(
    //                                 padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
    //                                 child: Icon(
    //                                   Icons.shield_outlined,
    //                                   color: Colors.white,
    //                                   size: 40,
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
    //                                 child: Text(
    //                                   'Acceso\nseguro',
    //                                   style: AppTheme.of(context).bodyText1.override(
    //                                         fontFamily: 'Poppins',
    //                                         color: Colors.white,
    //                                         fontSize: 15,
    //                                       ),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                           Container(
    //                             width: 2,
    //                             height: 70,
    //                             decoration: const BoxDecoration(
    //                               color: Color(0xFFE7E7E7),
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 2),
    //                             child: Text(
    //                               'La seguridad es nuestra prioridad, por\neso usamos los estándares mas altos.',
    //                               style: AppTheme.of(context).bodyText1.override(
    //                                     fontFamily: 'Poppins',
    //                                     color: const Color(0xFFE7E7E7),
    //                                     fontSize: 14,
    //                                     fontWeight: FontWeight.normal,
    //                                   ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
