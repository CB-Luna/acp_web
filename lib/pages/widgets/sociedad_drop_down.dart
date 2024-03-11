import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/pages/registro_usuario_page/registro_usuario_page.dart';
import 'package:flutter/material.dart';

class SociedadDropDown extends StatelessWidget {
  const SociedadDropDown({
    super.key,
    this.sociedadSeleccionada,
    required this.onSelect,
  });

  final String? sociedadSeleccionada;
  final dynamic Function(String?) onSelect;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: sociedadSeleccionada == null ? 'Por favor seleccione un tipo de sociedad' : '',
      child: SizedBox(
        width: 65,
        child: CustomDropDown(
          label: 'Sociedades',
          key: UniqueKey(),
          items: listaSociedades,
          value: sociedadSeleccionada,
          onChanged: onSelect,
          validator: (p0) {
            return null;
          },
        ),
      ),
    );
  }
}
