import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/pages/registro_usuario_page/registro_usuario_page.dart';
import 'package:flutter/material.dart';

class SociedadDropDown extends StatelessWidget {
  const SociedadDropDown({
    super.key,
    this.sociedadSeleccionada,
    this.sociedades,
    required this.onSelect,
  });

  final String? sociedadSeleccionada;
  final List<String>? sociedades;
  final dynamic Function(String?) onSelect;

  @override
  Widget build(BuildContext context) {
    return sociedades != null || (currentUser?.cliente != null && listaSociedades!.length >= 2) || (currentUser?.cliente == null)
        ? Tooltip(
            message: sociedadSeleccionada == null ? 'Por favor seleccione un tipo de sociedad' : '',
            child: SizedBox(
              width: currentUser?.cliente != null ? 200 : 65,
              child: CustomDropDown(
                label: 'Sociedades',
                key: UniqueKey(),
                items: sociedades ?? (currentUser?.cliente != null ? listaSociedades!.map((sociedad) => sociedad.nombre).toList() : listaSociedades!.map((sociedad) => sociedad.clave).toList()),
                value: sociedadSeleccionada,
                onChanged: onSelect,
                validator: (p0) {
                  return null;
                },
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
