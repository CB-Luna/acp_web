import 'package:acp_web/pages/registro_cliente/widgets/input_container.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/providers/providers.dart';

class TasaAnualWidget extends StatefulWidget {
  const TasaAnualWidget({super.key});

  @override
  State<TasaAnualWidget> createState() => _TasaAnualWidgetState();
}

class _TasaAnualWidgetState extends State<TasaAnualWidget> {
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
          const InputContainer(
            alignment: Alignment.centerLeft,
            child: TasaInputColumn(title: '% Tasa Anual', data: '%'),
          ),
          const SizedBox(height: 16),
          const InputContainer(
            alignment: Alignment.centerLeft,
            child: TasaInputColumn(title: '% Fórmula de Cálculo', data: 'Fórmula'),
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

class TasaInputColumn extends StatelessWidget {
  const TasaInputColumn({
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
