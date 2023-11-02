import 'package:acp_web/helpers/globals.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/pages/widgets/get_image_widget.dart';
import 'package:acp_web/pages/registro_usuario_page/widgets/opciones_widget.dart';
import 'package:acp_web/pages/registro_usuario_page/widgets/header.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/pages/widgets/footer.dart';

class RegistroUsuariosPage extends StatefulWidget {
  const RegistroUsuariosPage({
    super.key,
    this.usuario,
  });

  final Usuario? usuario;

  @override
  State<RegistroUsuariosPage> createState() => _RegistroUsuariosPageState();
}

class _RegistroUsuariosPageState extends State<RegistroUsuariosPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String? imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.usuario?.imagen != null) {
      imageUrl = supabase.storage.from('avatars').getPublicUrl(widget.usuario!.imagen!);
    }
  }

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
              mainAxisSize: MainAxisSize.min,
              children: [
                //Top Menu
                const CustomTopMenu(pantalla: 'Registro de Usuarios'),
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
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await provider.selectImage();
                                        },
                                        child: Container(
                                          width: 160,
                                          height: 160,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: getUserImage(
                                            height: 152,
                                            provider.webImage ?? imageUrl,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: -16,
                                        bottom: 0,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.delete_outline_outlined,
                                            size: 28,
                                            color: Color(0xFF0A0859),
                                          ),
                                          splashRadius: 0.01,
                                          onPressed: () {
                                            imageUrl = null;
                                            provider.clearImage();
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
                                        title: 'Nombre de contacto',
                                        child: CustomInputField(
                                          label: 'Nombre',
                                          controller: provider.nombreController,
                                          keyboardType: TextInputType.name,
                                          formatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r"^[a-zA-ZÀ-ÿ´ ]+"),
                                            )
                                          ],
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
                                        title: 'Correo Electrónico',
                                        child: CustomInputField(
                                          label: 'Email',
                                          controller: provider.correoController,
                                          keyboardType: TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'El correo es obligatorio';
                                            } else if (!EmailValidator.validate(value)) {
                                              return 'El correo no es válido';
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
                                        title: 'Apellido Paterno',
                                        child: CustomInputField(
                                          label: 'Apellido Paterno',
                                          controller: provider.apellidoPaternoController,
                                          keyboardType: TextInputType.name,
                                          formatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r"^[a-zA-ZÀ-ÿ´ ]+"),
                                            )
                                          ],
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'El apellido es requerido';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      InputContainer(
                                        title: 'Apellido Materno',
                                        child: CustomInputField(
                                          label: 'Apellido Materno',
                                          controller: provider.apellidoMaternoController,
                                          keyboardType: TextInputType.name,
                                          formatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r"^[a-zA-ZÀ-ÿ´ ]+"),
                                            )
                                          ],
                                          // validator: (value) {
                                          //   if (value == null || value.isEmpty) {
                                          //     return 'El apellido es requerido';
                                          //   }
                                          //   return null;
                                          // },
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
                                          keyboardType: TextInputType.phone,
                                          formatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'),
                                            )
                                          ],
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'El teléfono es obligatorio';
                                            }
                                            if (value.length != 10) {
                                              return 'El teléfono debe tener 10 dígitos';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      InputContainer(
                                        title: 'Rol de Usuario',
                                        child: CustomDropDown(
                                          label: 'Rol',
                                          value: provider.rolSeleccionado?.nombre,
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
                                      // InputContainer(
                                      //   title: 'Compañía',
                                      //   child: CustomInputField(
                                      //     label: 'Compañía',
                                      //     controller: TextEditingController(),
                                      //     validator: (value) {
                                      //       if (value == null || value.isEmpty) {
                                      //         return 'La compañía es requerida';
                                      //       }
                                      //       return null;
                                      //     },
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  if (provider.rolSeleccionado?.nombre == 'Cliente') ...[
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InputContainer(
                                          title: 'Código de cliente',
                                          child: CustomInputField(
                                            label: 'Código',
                                            controller: provider.codigoClienteController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El código es obligatorio';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) async {
                                              await provider.getCliente();
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        InputContainer(
                                          title: 'Sociedad',
                                          child: CustomInputField(
                                            label: 'Sociedad',
                                            controller: provider.sociedadClienteController,
                                            keyboardType: TextInputType.text,
                                            readOnly: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                                ],
                              ),
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
                    formKey: formKey,
                    usuario: widget.usuario,
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
    this.alignment = Alignment.center,
  });

  final String title;
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
