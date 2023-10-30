import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/pages/registro_usuario_page/widgets/opciones_widget.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UsuariosProvider provider = Provider.of<UsuariosProvider>(
        context,
        listen: false,
      );
      await provider.updateState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(4);

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
                                      label: 'Nombre',
                                      controller: provider.nombreController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'El nombre es requerido';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    InputContainer(
                                      title: 'Apellido',
                                      label: 'Apellido',
                                      controller: provider.apellidosController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'El apellido es requerido';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InputContainer(
                                      title: 'Teléfono de Contacto',
                                      label: 'Teléfono',
                                      controller: provider.telefonoController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'El teléfono es requerido';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    InputContainer(
                                      title: 'Rol',
                                      label: 'Rol',
                                      controller: TextEditingController(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'El rol es requerido';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InputContainer(
                                      title: 'Compañía',
                                      label: 'Compañía',
                                      controller: provider.nombreController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'La compañía es requerida';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    InputContainer(
                                      title: 'Contacto',
                                      label: 'Email',
                                      controller: provider.apellidosController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'El email es requerido';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InputContainer(
                                      title: 'País',
                                      label: 'País',
                                      controller: provider.nombreController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'El país es requerido';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    InputContainer(
                                      title: 'Sociedad',
                                      label: 'Sociedad',
                                      controller: provider.apellidosController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'La sociedad es requerida';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                InputContainer(
                                  title: 'Estatus',
                                  label: 'Estatus',
                                  width: 844,
                                  controller: provider.apellidosController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El apellido es requerido';
                                    }
                                    return null;
                                  },
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
    required this.label,
    required this.controller,
    required this.validator,
    this.width = 414,
  });

  final String title;
  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final double width;

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
          CustomInputField(
            label: label,
            controller: controller,
            validator: validator,
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
