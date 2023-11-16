import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class Marcadores extends StatefulWidget {
  const Marcadores({super.key, required this.width, required this.titulo, required this.cantidad, required this.porcentaje, required this.icono, required this.moneda, required this.color});

  final double width;
  final String titulo;
  final String cantidad;
  final double porcentaje;
  final IconData icono;
  final String moneda;
  final Color color;

  @override
  State<Marcadores> createState() => _MarcadoresState();
}

class _MarcadoresState extends State<Marcadores> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 160,
      height: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: widget.color),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              Text(
                widget.titulo,
                textAlign: TextAlign.center,
                style: AppTheme.of(context).title3,
              ),
              const Spacer(),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    widget.icono,
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              Text(
                '${widget.moneda} ${widget.cantidad} ${widget.porcentaje}%',
                textAlign: TextAlign.center,
                style: AppTheme.of(context).title3,
              ),
              widget.porcentaje >= 20
                  ? const Icon(
                      Icons.arrow_upward,
                      size: 20,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.arrow_downward,
                      size: 20,
                      color: Colors.red,
                    ),
              const Spacer(),
            ],
          )
        ]),
      ),
    );
  }
}
