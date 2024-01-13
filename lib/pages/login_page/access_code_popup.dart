import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sf;
import 'package:provider/provider.dart';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/helpers/supabase/queries.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/services/api_error_handler.dart';
import 'package:acp_web/theme/theme.dart';

class AccessCodePopup extends StatefulWidget {
  const AccessCodePopup({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  State<AccessCodePopup> createState() => _AccessCodePopupState();
}

class _AccessCodePopupState extends State<AccessCodePopup> {
  TextEditingController accessCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FToast fToast = FToast();

  @override
  Widget build(BuildContext context) {
    const double containerWidth = 650;
    fToast.init(context);

    final UserState userState = Provider.of<UserState>(context);

    Future<void> login() async {
      // validate access token entered
      // if valid login, else show code is incorrect

      final codeValid = await userState.validateAccessCode(widget.userId, accessCodeController.text);

      if (!codeValid) {
        ApiErrorHandler.callToast('El código de acceso es inválido');
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

      // if (currentUser!.activado == false) {
      //   await ApiErrorHandler.callToast('El usuario está desactivado');
      //   await supabase.auth.signOut();
      //   return;
      // }

      // await userState.checkIfUserChangedPasswordInLast90Days(currentUser!.id);

      // if (!userState.userChangedPasswordInLast90Days) {
      //   if (!mounted) return;
      //   context.pushReplacement('/cambio-contrasena');
      //   return;
      // }

      // if (!currentUser!.cambioContrasena) {
      //   if (!mounted) return;
      //   context.pushReplacement('/cambio-contrasena');
      //   return;
      // }

      // userState.registerLogin(currentUser!.id);

      if (!mounted) return;
      context.pushReplacement('/');
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: containerWidth,
        height: 600,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Positioned(
                top: 70,
                left: 40,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 170, 0, 40),
                      child: Text(
                        'Código de acceso',
                        style: AppTheme.of(context).bodyText1.override(
                              fontFamily: 'Bicyclette-Light',
                              color: Colors.white,
                              fontSize: 50,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                      child: Text(
                        'Se ha envíado un código de acceso a tu correo.\n\nPor favor ingrésalo a continuación:',
                        style: AppTheme.of(context).bodyText1.override(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: containerWidth * 0.7,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppTheme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Form(
                                key: formKey,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                                  child: TextFormField(
                                    controller: accessCodeController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'El código de acceso es requerido';
                                      } else if (value.length != 6) {
                                        return 'El código de acceso es inválido';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'),
                                      )
                                    ],
                                    decoration: InputDecoration(
                                      hintStyle: AppTheme.of(context).bodyText2,
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    style: AppTheme.of(context).bodyText1.override(
                                          fontFamily: 'Montserrat',
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    try {
                                      await login();
                                    } catch (e) {
                                      if (e is sf.AuthException) {
                                        await ApiErrorHandler.callToast('Credenciales inválidas');
                                        return;
                                      }
                                      log('Error al ingresar codigo de acceso - $e');
                                    }
                                  },
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: AppTheme.of(context).primaryColor,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
