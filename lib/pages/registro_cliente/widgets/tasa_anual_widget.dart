import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/pages/registro_cliente/widgets/input_container.dart';
import 'package:acp_web/theme/theme.dart';

class TasaAnualWidget extends StatefulWidget {
  const TasaAnualWidget({super.key});

  @override
  State<TasaAnualWidget> createState() => _TasaAnualWidgetState();
}

class _TasaAnualWidgetState extends State<TasaAnualWidget> {
  final dateMaskFormatter = MaskTextInputFormatter(
    mask: '####-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    final ClientesProvider provider = Provider.of<ClientesProvider>(context);

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
              'Tasa Anual Pactada',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InputContainer(
                  alignment: Alignment.centerLeft,
                  child: DataInputColumn(
                    title: '% Tasa Anual *',
                    child: CustomInputField(
                      label: 'Tasa Anual',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La tasa anual es obligatoria';
                        }
                        return null;
                      },
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]'),
                        )
                      ],
                      onChanged: (value) => provider.setTasaAnual(),
                      controller: provider.tasaAnualController,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InputContainer(
                  alignment: Alignment.centerLeft,
                  child: DataInputColumn(
                    title: 'Fecha Contrato',
                    child: CustomInputField(
                      label: 'yyyy-MM-dd',
                      keyboardType: TextInputType.datetime,
                      formatters: [dateMaskFormatter],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La fecha de contrato es obligatoria';
                        }
                        final date = DateTime.tryParse(value);
                        if (date == null) {
                          return 'La fecha no es válida';
                        }
                        return null;
                      },
                      onChanged: (_) => provider.modificado = true,
                      controller: provider.fechaContratoController,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InputContainer(
                  alignment: Alignment.centerLeft,
                  child: DataInputColumn(
                    title: '% Tasa Preferencial',
                    child: CustomInputField(
                      label: 'Tasa Preferencial',
                      keyboardType: TextInputType.text,
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]'),
                        )
                      ],
                      onChanged: (value) => provider.modificado = true,
                      controller: provider.tasaPreferencialController,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InputContainer(
                  alignment: Alignment.centerLeft,
                  child: DataInputColumn(
                    title: 'Facturación mayor a:',
                    child: CustomInputField(
                      label: '\$ 0.00',
                      keyboardType: TextInputType.text,
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]'),
                        )
                      ],
                      onChanged: (_) => provider.modificado = true,
                      controller: provider.facturacionMayorAController,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InputContainer(
            alignment: Alignment.centerLeft,
            child: DataInputColumn(
              title: '% Fórmula de Cálculo',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '% Comisión',
                    style: AppTheme.of(context).bodyText1.override(
                          fontFamily: 'Gotham-Bold',
                          useGoogleFonts: false,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    ' = Redondear(',
                    style: AppTheme.of(context).bodyText1.override(
                          fontFamily: 'Gotham-Regular',
                          useGoogleFonts: false,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          provider.getTasaAnualAsString(),
                          style: AppTheme.of(context).bodyText1.override(
                                fontFamily: 'Gotham-Regular',
                                useGoogleFonts: false,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                        Container(height: 1, color: Colors.black, width: double.infinity),
                        Text(
                          '360',
                          style: AppTheme.of(context).bodyText1.override(
                                fontFamily: 'Gotham-Regular',
                                useGoogleFonts: false,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    ' * (',
                    style: AppTheme.of(context).bodyText1.override(
                          fontFamily: 'Gotham-Regular',
                          useGoogleFonts: false,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  Tooltip(
                    message: 'Fecha normal de pago',
                    child: Text(
                      'FNP',
                      style: AppTheme.of(context).bodyText1.override(
                            fontFamily: 'Gotham-Regular',
                            useGoogleFonts: false,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dotted,
                          ),
                    ),
                  ),
                  Text(
                    ' - ',
                    style: AppTheme.of(context).bodyText1.override(
                          fontFamily: 'Gotham-Regular',
                          useGoogleFonts: false,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  Tooltip(
                    message: 'Fecha de pago anticipado',
                    child: Text(
                      'FPA',
                      style: AppTheme.of(context).bodyText1.override(
                            fontFamily: 'Gotham-Regular',
                            useGoogleFonts: false,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dotted,
                          ),
                    ),
                  ),
                  Text(
                    ' + 1 + ',
                    style: AppTheme.of(context).bodyText1.override(
                          fontFamily: 'Gotham-Regular',
                          useGoogleFonts: false,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  Tooltip(
                    message: 'Días adicionales para comisión',
                    child: Text(
                      'DAC',
                      style: AppTheme.of(context).bodyText1.override(
                            fontFamily: 'Gotham-Regular',
                            useGoogleFonts: false,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dotted,
                          ),
                    ),
                  ),
                  Text(
                    '), 6)',
                    style: AppTheme.of(context).bodyText1.override(
                          fontFamily: 'Gotham-Regular',
                          useGoogleFonts: false,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // InputContainer(
          //   child: Row(
          //     children: [
          //       Icon(Icons.),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class DataInputColumn extends StatelessWidget {
  const DataInputColumn({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

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
        child,
      ],
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
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final void Function(String)? onChanged;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      alignment: Alignment.centerLeft,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.formatters,
        onChanged: widget.onChanged,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          hintText: widget.label,
          isDense: true,
          filled: false,
          contentPadding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 15,
            bottom: 10,
          ),
          hintStyle: AppTheme.of(context).subtitle1.override(
                fontFamily: 'Gotham-Bold',
                useGoogleFonts: false,
                fontWeight: FontWeight.w400,
                color: Colors.black,
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
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
      ),
    );
  }
}
