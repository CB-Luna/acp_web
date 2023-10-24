import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class AccessBlockedPopup extends StatelessWidget {
  const AccessBlockedPopup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double containerWidth = 650;

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
              const Positioned(left: 40, child: BlockedWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

class BlockedWidget extends StatelessWidget {
  const BlockedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 170, 0, 40),
          child: Text(
            'Acceso Bloqueado',
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
            'Se han realizado demasiados intentos de acceso.\n\nPor favor espere una hora y vuelva a intentar.',
            style: AppTheme.of(context).bodyText1.override(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
          ),
        ),
      ],
    );
  }
}
