import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

import 'package:acp_web/functions/check_password.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/helpers/supabase/queries.dart';
import 'package:acp_web/pages/widgets/custom_button.dart';
import 'package:acp_web/pages/widgets/toasts/change_password_toast.dart';
import 'package:acp_web/pages/widgets/toasts/success_toast.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/services/api_error_handler.dart';
import 'package:acp_web/theme/theme.dart';

class CambioContrasenaPage extends StatefulWidget {
  const CambioContrasenaPage({
    Key? key,
    this.token,
  }) : super(key: key);

  final Token? token;

  @override
  State<CambioContrasenaPage> createState() => _CambioContrasenaPageState();
}

class _CambioContrasenaPageState extends State<CambioContrasenaPage> {
  TextEditingController nuevaContrasenaController = TextEditingController();
  TextEditingController confNuevaContrasenaController = TextEditingController();
  bool nuevaContrasenaVisibility = false;
  bool confNuevaContrasenaVisibility = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  FToast fToast = FToast();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserState provider = Provider.of<UserState>(
        context,
        listen: false,
      );
      if (!provider.userChangedPasswordInLast90Days) {
        fToast.init(context);
        fToast.showToast(
          child: const ChangePasswordToast(
            message: 'Por motivos de seguridad, debe actualizar su contraseña cada 90 días',
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 6),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/images/bgaruxlogin_Mesa_de_trabajo_1.png',
                  ).image,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF161616), Color(0xFF37A26B)],
                  stops: [0, 1],
                  begin: AlignmentDirectional(1, 0),
                  end: AlignmentDirectional(-1, 0),
                ),
              ),
            ),
            Positioned(
              left: 150,
              top: 200,
              child: Material(
                color: Colors.transparent,
                elevation: 80,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: 500,
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF37A26B), Color(0xFF116538)],
                      stops: [0, 1],
                      begin: AlignmentDirectional(0.34, -1),
                      end: AlignmentDirectional(-0.34, 1),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: formKey,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 5,
                                left: 5,
                                child: IconButton(
                                  onPressed: () async {
                                    await userState.logout();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(4, 40, 4, 4),
                                    child: Text(
                                      'Cambiar contraseña',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.of(context).bodyText1.override(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 30,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                    child: TextFormField(
                                      controller: nuevaContrasenaController,
                                      obscuringCharacter: '*',
                                      obscureText: !nuevaContrasenaVisibility,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'La contraseña es obligatoria';
                                        }
                                        return checkPassword(value);
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Nueva contraseña *',
                                        labelStyle: AppTheme.of(context).bodyText1.override(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        hintText: 'Ingresa contraseña...',
                                        hintStyle: AppTheme.of(context).bodyText2.override(
                                              fontFamily: 'Poppins',
                                              color: const Color(0xFFA5A5A5),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                            ),
                                        errorStyle: AppTheme.of(context).bodyText2.override(
                                              fontFamily: 'Poppins',
                                              color: Colors.red.shade200,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                            ),
                                        errorMaxLines: 3,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFF414040),
                                        suffixIcon: InkWell(
                                          onTap: () => setState(
                                            () => nuevaContrasenaVisibility = !nuevaContrasenaVisibility,
                                          ),
                                          focusNode: FocusNode(skipTraversal: true),
                                          child: Icon(
                                            nuevaContrasenaVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: AppTheme.of(context).secondaryColor,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      style: AppTheme.of(context).bodyText1.override(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                    child: TextFormField(
                                      controller: confNuevaContrasenaController,
                                      obscureText: !confNuevaContrasenaVisibility,
                                      obscuringCharacter: '*',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'La contraseña de confirmación es requerida';
                                        } else if (value != nuevaContrasenaController.text) {
                                          return 'Las contraseñas no coinciden';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Confirmar contraseña *',
                                        labelStyle: AppTheme.of(context).bodyText1.override(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        hintText: 'Confirma tu contraseña...',
                                        hintStyle: AppTheme.of(context).bodyText2.override(
                                              fontFamily: 'Poppins',
                                              color: const Color(0xFFA5A5A5),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                            ),
                                        errorStyle: AppTheme.of(context).bodyText2.override(
                                              fontFamily: 'Poppins',
                                              color: Colors.red.shade200,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                            ),
                                        errorMaxLines: 3,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFF414040),
                                        suffixIcon: InkWell(
                                          onTap: () => setState(
                                            () => confNuevaContrasenaVisibility = !confNuevaContrasenaVisibility,
                                          ),
                                          focusNode: FocusNode(skipTraversal: true),
                                          child: Icon(
                                            confNuevaContrasenaVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: AppTheme.of(context).secondaryColor,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      style: AppTheme.of(context).bodyText1.override(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                    child: CustomButton(
                                      showLoadingIndicator: true,
                                      onPressed: () async {
                                        if (!formKey.currentState!.validate()) {
                                          return;
                                        }

                                        if (currentUser == null) {
                                          if (widget.token == null) {
                                            context.pushReplacement('/login');
                                            return;
                                          } else {
                                            //validate token
                                            final tokenValid = await widget.token!.validate('reset');
                                            if (!tokenValid) {
                                              await ApiErrorHandler.callToast(
                                                'Contraseña inválida',
                                              );
                                              return;
                                            } else {
                                              final res = await SupabaseQueries.tokenChangePassword(
                                                widget.token!.userId,
                                                nuevaContrasenaController.text,
                                              );
                                              if (!res) {
                                                ApiErrorHandler.callToast('Error al actualizar contraseña');
                                              }
                                              await supabase.auth.signInWithPassword(
                                                email: widget.token!.email,
                                                password: nuevaContrasenaController.text,
                                              );
                                            }
                                          }
                                        }

                                        final res = await supabase.auth.updateUser(
                                          UserAttributes(
                                            password: nuevaContrasenaController.text,
                                          ),
                                        );

                                        currentUser = await SupabaseQueries.getCurrentUserData();

                                        if (currentUser == null) {
                                          await ApiErrorHandler.callToast();
                                          return;
                                        }

                                        if (res.user == null) {
                                          ApiErrorHandler.callToast('Error al actualizar contraseña');
                                          log('Error al actualizar contraseña');
                                          return;
                                        }

                                        await supabase.from('perfil_usuario').update({
                                          'cambio_contrasena': true,
                                        }).eq('perfil_usuario_id', currentUser!.id);

                                        if (!mounted) return;

                                        fToast.init(context);
                                        fToast.showToast(
                                          child: const SuccessToast(
                                            message: 'Contraseña actualizada exitosamente',
                                          ),
                                          gravity: ToastGravity.BOTTOM,
                                          toastDuration: const Duration(seconds: 2),
                                        );

                                        // userState
                                        //     .registerLogin(currentUser!.id);

                                        context.pushReplacement('/');
                                      },
                                      text: 'Cambiar contraseña',
                                      options: ButtonOptions(
                                        width: 190,
                                        height: 50,
                                        color: const Color(0xFF39D24A),
                                        textStyle: AppTheme.of(context).subtitle2.override(
                                              fontFamily: 'Montserrat',
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        elevation: 0,
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 150,
              top: 50,
              child: Image(
                image: AssetImage('assets/images/LogoBlanco.png'),
                height: 110,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
