import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/pages/registro_cliente/widgets/header.dart';
import 'package:acp_web/pages/registro_cliente/widgets/opciones_widget.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/pages/widgets/get_image_widget.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/pages/widgets/footer.dart';

class RegistroClientePage extends StatefulWidget {
  const RegistroClientePage({
    super.key,
    required this.cliente,
  });

  final dynamic cliente;

  @override
  State<RegistroClientePage> createState() => _RegistroClientePageState();
}

class _RegistroClientePageState extends State<RegistroClientePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.cliente is Cliente) {
      imageUrl = widget.cliente.imagen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ClientesProvider provider = Provider.of<ClientesProvider>(context);

    final bool editado = widget.cliente is Cliente;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: Row(
        children: [
          const CustomSideMenu(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Top Menu
                const CustomTopMenu(pantalla: 'Registro de Clientes'),
                //Contenido
                Expanded(
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Encabezado
                          const RegistroClientesHeader(encabezado: 'Registro de Clientes'),
                          //Contenido
                          Container(
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
                                    'Datos Generales',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  height: 195,
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await provider.selectImage();
                                        },
                                        child: Container(
                                          width: 175,
                                          height: 175,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: getUserImage(
                                            height: 145,
                                            provider.webImage ?? imageUrl,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InputContainer(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ClienteDataWidget(
                                                      title: 'Código de cliente',
                                                      data: widget.cliente.codigoCliente,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ClienteDataWidget(
                                                      title: 'Sociedad',
                                                      data: widget.cliente.sociedad,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ClienteDataWidget(
                                                      title: 'Dirección',
                                                      data: widget.cliente.direccion,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            InputContainer(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ClienteDataWidget(
                                                      title: 'Identificación Fiscal',
                                                      data: widget.cliente.identificadorFiscal,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ClienteDataWidget(
                                                      title: 'Cuenta',
                                                      data: widget.cliente.tipoCuenta ?? '',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ClienteDataWidget(
                                                      title: 'Condición Pago',
                                                      data: widget.cliente.condicionPago.toString(),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ClienteDataWidget(
                                                      title: 'Banco',
                                                      data: widget.cliente.bancoIndustrial ?? '',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: OpcionesWidget(
                    cliente: widget.cliente,
                  ),
                ),
                //Footer
                const Footer(),
              ],
            ),
          ),
          const CustomSideNotifications(),
        ],
      ),
    );
  }
}

class ClienteDataWidget extends StatelessWidget {
  const ClienteDataWidget({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.of(context).subtitle1.override(
                fontFamily: 'Gotham-Bold',
                useGoogleFonts: false,
                color: const Color(0x661C1C1C),
              ),
        ),
        const SizedBox(height: 16),
        Text(
          data,
          style: AppTheme.of(context).subtitle1.override(
                fontFamily: 'Gotham-Regular',
                useGoogleFonts: false,
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}

class InputContainer extends StatelessWidget {
  const InputContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final double width;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
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
      height: 45,
      alignment: Alignment.center,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.formatters,
        readOnly: widget.readOnly,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.label,
          isCollapsed: true,
          isDense: true,
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
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromARGB(204, 0, 0, 0),
        ),
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.validator,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final String? Function(String?) validator;
  final void Function(String) onChanged;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text(
            'Seleccionar ${widget.label}',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: const Color.fromARGB(204, 0, 0, 0),
            ),
          ),
          icon: const Icon(
            Icons.unfold_more_rounded,
            size: 20,
            color: Color(0x661C1C1C),
          ),
          validator: widget.validator,
          items: widget.items
              .map(
                (String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: const Color.fromARGB(204, 0, 0, 0),
                    ),
                  ),
                ),
              )
              .toList(),
          value: selectedValue,
          onChanged: (String? value) {
            if (value == null) return;
            selectedValue = value;
            widget.onChanged(value);
          },
          padding: EdgeInsets.zero,
          decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isCollapsed: true,
            isDense: true,
          ),
        ),
      ),
    );
  }
}
