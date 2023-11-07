import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/models/models.dart';
import 'package:acp_web/pages/registro_cliente/widgets/input_container.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/theme/theme.dart';

class DatosContactoWidget extends StatefulWidget {
  const DatosContactoWidget({super.key});

  @override
  State<DatosContactoWidget> createState() => _DatosContactoWidgetState();
}

class _DatosContactoWidgetState extends State<DatosContactoWidget> {
  @override
  Widget build(BuildContext context) {
    final ClientesProvider provider = Provider.of<ClientesProvider>(context);
    final contactos = provider.cliente!.contactos;

    final List<Widget> contactosWidgets = List.generate(
      contactos.length,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ContactoInputRow(
          key: Key(index.toString()),
          index: index,
          // contacto: contactos[index],
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFD7E9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Datos de Contacto',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          InputContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.add_outlined,
                        size: 21,
                        color: AppTheme.of(context).secondaryColor,
                      ),
                      splashRadius: 0.01,
                      onPressed: () {
                        provider.agregarContacto();
                      },
                    ),
                    const SizedBox(width: 5),
                    const Expanded(child: TitleLabelWidget(title: 'Puesto')),
                    const SizedBox(width: 5),
                    const Expanded(child: TitleLabelWidget(title: 'Nombre')),
                    const SizedBox(width: 5),
                    const Expanded(child: TitleLabelWidget(title: 'Correo')),
                    const SizedBox(width: 5),
                    const Expanded(child: TitleLabelWidget(title: 'Teléfono')),
                    const SizedBox(height: 20, width: 48.2),
                  ],
                ),
                ...contactosWidgets,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TitleLabelWidget extends StatelessWidget {
  const TitleLabelWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: const Color(0x4D0090FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD1D1D1))),
      child: Text(
        title,
        style: AppTheme.of(context).subtitle1.override(
              fontFamily: 'Gotham-Bold',
              useGoogleFonts: false,
              color: const Color(0x66000000),
            ),
      ),
    );
  }
}

class ContactoInputRow extends StatefulWidget {
  const ContactoInputRow({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<ContactoInputRow> createState() => _ContactoInputRowState();
}

class _ContactoInputRowState extends State<ContactoInputRow> {
  bool readOnly = true;

  @override
  Widget build(BuildContext context) {
    final ClientesProvider provider = Provider.of<ClientesProvider>(context);

    final Contacto contacto = provider.cliente!.contactos[widget.index];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFD1D1D1),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomInputField(
              label: 'Puesto',
              controller: TextEditingController(text: contacto.puesto),
              onChanged: (value) => contacto.puesto = value,
              readOnly: readOnly,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: CustomInputField(
              label: 'Nombre',
              controller: TextEditingController(text: contacto.nombre),
              onChanged: (value) => contacto.nombre = value,
              readOnly: readOnly,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: CustomInputField(
              label: 'Correo',
              controller: TextEditingController(text: contacto.correo),
              onChanged: (value) => contacto.correo = value,
              readOnly: readOnly,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: CustomInputField(
              label: 'Teléfono',
              controller: TextEditingController(text: contacto.telefono),
              onChanged: (value) => contacto.telefono = value,
              readOnly: readOnly,
            ),
          ),
          SizedBox(
            height: 20,
            width: 48.2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  alignment: Alignment.center,
                  icon: Transform.translate(
                    offset: const Offset(0, -1.5),
                    child: Icon(
                      FontAwesomeIcons.penToSquare,
                      size: 16,
                      color: AppTheme.of(context).secondaryColor,
                    ),
                  ),
                  splashRadius: 0.01,
                  onPressed: () {
                    readOnly = false;
                    setState(() {});
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.delete_outline_outlined,
                    size: 20,
                    color: AppTheme.of(context).secondaryColor,
                  ),
                  splashRadius: 0.01,
                  onPressed: () {
                    provider.eliminarContacto(widget.index);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.formatters,
    this.onChanged,
    this.readOnly = false,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final void Function(String)? onChanged;
  final bool readOnly;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.formatters,
        readOnly: widget.readOnly,
        onChanged: widget.onChanged,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: widget.label,
          isDense: true,
          filled: true,
          contentPadding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 15,
            bottom: 10,
          ),
          fillColor: const Color(0x4D0090FF),
          hintStyle: AppTheme.of(context).subtitle1.override(
                fontFamily: 'Gotham-Bold',
                useGoogleFonts: false,
                color: const Color(0x66000000),
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
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        style: AppTheme.of(context).subtitle1.override(
              fontFamily: 'Gotham-Bold',
              useGoogleFonts: false,
              color: const Color(0x66000000),
            ),
      ),
    );
  }
}
