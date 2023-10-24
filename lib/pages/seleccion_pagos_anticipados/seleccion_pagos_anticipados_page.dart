import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeleccionPagosAnticipadosPage extends StatefulWidget {
  const SeleccionPagosAnticipadosPage({super.key});

  @override
  State<SeleccionPagosAnticipadosPage> createState() => _SeleccionPagosAnticipadosPageState();
}

class _SeleccionPagosAnticipadosPageState extends State<SeleccionPagosAnticipadosPage> {
  @override
  Widget build(BuildContext context) {
    //final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    //visualState.setTapedOption(2);

    //final bool permisoCaptura = currentUser!.rol.permisos.extraccionDeFacturas == 'C';
    //String? monedaSeleccionada = currentUser!.monedaSeleccionada;

    //final SeleccionPagosAnticipadosPage provider = Provider.of<SeleccionPagosAnticipadosPage>(context);

    return Scaffold(
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: const SizedBox(
        child: Row(
          children: [
            CustomSideMenu(),
            Column(),
            Column(),
          ],
        ),
      ),
    );
  }
}

class HandmadeSideMenu extends StatelessWidget {
  const HandmadeSideMenu({super.key});

  final double sidemenuPadding = 15;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 210),
      width: MediaQuery.of(context).size.width * 210 / 1440,
      height: double.infinity,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  color: Colors.red,
                ),
                const SizedBox(width: 5),
                Text(
                  'Mario Alonso',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.of(context).primaryBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: sidemenuPadding),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'Tesorero',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.of(context).primaryBackground,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chevron_right_outlined,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          const SizedBox(width: 5),
                          const Row(
                            children: [
                              Icon(
                                Icons.home_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Home',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: sidemenuPadding),
            const Expanded(child: SizedBox.shrink()),
            SizedBox(height: sidemenuPadding),
            Container(
              width: 180,
              height: 60,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
