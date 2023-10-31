import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/pages/registro_usuario_page/widgets/opciones_widget.dart';
import 'package:acp_web/pages/registro_usuario_page/widgets/header.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/pages/widgets/footer.dart';

class RegistroUsuariosPage extends StatefulWidget {
  const RegistroUsuariosPage({super.key});

  @override
  State<RegistroUsuariosPage> createState() => _RegistroUsuariosPageState();
}

class _RegistroUsuariosPageState extends State<RegistroUsuariosPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final UsuariosProvider provider = Provider.of<UsuariosProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: Row(
        children: [
          const CustomSideMenu(),
          Expanded(
            child: Column(
              children: [
                //Top Menu
                const CustomTopMenu(pantalla: 'Registro de Usuarios'),
                //Contenido
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Encabezado
                        const RegistroUsuariosHeader(encabezado: 'Registro de Usuarios'),
                        //Contenido
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7E9FB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Información de Usuario',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InputContainer(
                                      title: 'Nombre de contacto',
                                      child: CustomInputField(
                                        label: 'Nombre',
                                        controller: provider.nombreController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'El nombre es requerido';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    InputContainer(
                                      title: 'Apellido',
                                      child: CustomInputField(
                                        label: 'Apellido',
                                        controller: provider.apellidosController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'El apellido es requerido';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InputContainer(
                                      title: 'Teléfono de Contacto',
                                      child: CustomInputField(
                                        label: 'Teléfono',
                                        controller: provider.telefonoController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'El teléfono es requerido';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    InputContainer(
                                      title: 'Rol',
                                      child: CustomDropDown(
                                        label: 'Rol',
                                        items: provider.roles.map((rol) => rol.nombre).toList(),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'El rol es requerido';
                                          }
                                          return null;
                                        },
                                        onChanged: provider.setRolSeleccionado,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InputContainer(
                                      title: 'Compañía',
                                      child: CustomInputField(
                                        label: 'Compañía',
                                        controller: TextEditingController(),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'La compañía es requerida';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    InputContainer(
                                      title: 'Contacto',
                                      child: CustomInputField(
                                        label: 'Email',
                                        controller: provider.correoController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'El email es requerido';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InputContainer(
                                      title: 'País',
                                      child: CustomDropDown(
                                        label: 'País',
                                        items: provider.paises.map((pais) => pais.nombre).toList(),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'El país es requerido';
                                          }
                                          return null;
                                        },
                                        onChanged: provider.setPaisSeleccionado,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    InputContainer(
                                      title: 'Sociedad',
                                      child: CustomDropDown(
                                        label: 'Sociedad',
                                        items: provider.sociedades.map((sociedad) => sociedad.nombre).toList(),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'La sociedad es requerida';
                                          }
                                          return null;
                                        },
                                        onChanged: provider.setSociedad,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                InputContainer(
                                  title: 'Estatus',
                                  width: 844,
                                  child: CustomInputField(
                                    label: 'Estatus',
                                    controller: TextEditingController(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'El apellido es requerido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: OpcionesWidget(
                    formKey: formKey,
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

class InputContainer extends StatelessWidget {
  const InputContainer({
    super.key,
    required this.title,
    required this.child,
    this.width = 414,
  });

  final String title;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: const Color(0x661C1C1C),
            ),
          ),
          const SizedBox(height: 5),
          child,
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
    required this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;

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
    required this.items,
    required this.validator,
    required this.onChanged,
  });

  final String label;
  final List<String> items;
  final String? Function(String?) validator;
  final void Function(String) onChanged;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? selectedValue;

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
