import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/providers/user_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/services/api_error_handler.dart';
import 'package:acp_web/pages/widgets/toasts/success_toast.dart';

class ResetPasswordPopup extends StatefulWidget {
  const ResetPasswordPopup({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPopup> createState() => _ResetPasswordPopupState();
}

class _ResetPasswordPopupState extends State<ResetPasswordPopup> {
  TextEditingController emailAddressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FToast fToast = FToast();

  @override
  Widget build(BuildContext context) {
    const double containerWidth = 750;
    fToast.init(context);

    final UserState userState = Provider.of<UserState>(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: containerWidth,
        height: 700,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.of(context).secondaryColor),
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
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(50, 170, 0, 40),
                      child: Text(
                        'Reestablecer \nContraseña',
                        style: AppTheme.of(context).bodyText1.override(
                              fontFamily: 'Bicyclette-Light',
                              color: Colors.white,
                              fontSize: 50,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                    child: Text(
                      'Ingresa el correo registrado a tu cuenta.\n\nDe esta forma sabremos que esta cuenta te pertenece',
                      style: AppTheme.of(context).bodyText1.override(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  ),
                  Container(
                    width: containerWidth * 0.7,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppTheme.of(context).secondaryColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: formKey,
                            autovalidateMode: AutovalidateMode.always,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                              child: TextFormField(
                                controller: emailAddressController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'El correo es requerido';
                                  } else if (!EmailValidator.validate(value)) {
                                    return 'Por favor ingresa un correo válido';
                                  }
                                  return null;
                                },
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

                                final res = await userState.resetPassword(emailAddressController.text);

                                if (res != null) {
                                  ApiErrorHandler.callToast(res['Error']!);
                                  return;
                                }

                                if (!mounted) return;
                                fToast.showToast(
                                  child: const SuccessToast(
                                    message: 'Correo enviado',
                                  ),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(seconds: 2),
                                );
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                color: AppTheme.of(context).secondaryColor,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
