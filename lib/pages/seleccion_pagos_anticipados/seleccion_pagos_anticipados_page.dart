import 'dart:html';

import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/contenedores_pagos_anticipados.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/custom_card.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/custom_list.dart';
import 'package:acp_web/pages/widgets/custom_header_options.dart';
import 'package:acp_web/pages/widgets/custom_scrollbar.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class SeleccionPagosAnticipadosPage extends StatefulWidget {
  const SeleccionPagosAnticipadosPage({super.key});

  @override
  State<SeleccionPagosAnticipadosPage> createState() => _SeleccionPagosAnticipadosPageState();
}

class _SeleccionPagosAnticipadosPageState extends State<SeleccionPagosAnticipadosPage> {
  SideMenuController sideMenuController = SideMenuController();
  SideMenuController sideNotificationsController = SideMenuController();

  bool filterSelected = false;
  bool gridSelected = true;

  bool listOpenned = false;

  late List<PlutoGridStateManager> listStateManager;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;

    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(1);

    //final bool permisoCaptura = currentUser!.rol.permisos.extraccionDeFacturas == 'C';
    //String? monedaSeleccionada = currentUser!.monedaSeleccionada;

    //final SeleccionPagosAnticipadosPage provider = Provider.of<SeleccionPagosAnticipadosPage>(context);

    List<Map<String, dynamic>> listadoEjemplo = [
      {
        "nombreCliente": "Braskem S.A.",
        "facturacion": 896486.01,
        "beneficio": 581.44,
        "pagoAdelantado": 895904.57,
        "cantidadFacturas": 36,
        "cantidadFacturasSeleccionadas": 18
      },
      {
        "nombreCliente": "Seanergy Maritime Holdings Corp",
        "facturacion": 608423.64,
        "beneficio": 882.67,
        "pagoAdelantado": 607540.97,
        "cantidadFacturas": 19,
        "cantidadFacturasSeleccionadas": 10
      },
      {
        "nombreCliente": "Home Federal Bancorp, Inc. of Louisiana",
        "facturacion": 431981.97,
        "beneficio": 513.42,
        "pagoAdelantado": 431468.55,
        "cantidadFacturas": 33,
        "cantidadFacturasSeleccionadas": 19
      },
      {
        "nombreCliente": "Conyers Park Acquisition Corp.",
        "facturacion": 826387.67,
        "beneficio": 549.32,
        "pagoAdelantado": 825838.35,
        "cantidadFacturas": 17,
        "cantidadFacturasSeleccionadas": 15
      },
      {
        "nombreCliente": "VictoryShares US 500 Volatility Wtd ETF",
        "facturacion": 637716.32,
        "beneficio": 799.39,
        "pagoAdelantado": 636916.93,
        "cantidadFacturas": 48,
        "cantidadFacturasSeleccionadas": 12
      },
      {
        "nombreCliente": "Monolithic Power Systems, Inc.",
        "facturacion": 486137.79,
        "beneficio": 765.19,
        "pagoAdelantado": 485372.6,
        "cantidadFacturas": 25,
        "cantidadFacturasSeleccionadas": 25
      },
      {
        "nombreCliente": "Alliance California Municipal Income Fund Inc",
        "facturacion": 686625.75,
        "beneficio": 915.65,
        "pagoAdelantado": 685710.1,
        "cantidadFacturas": 2,
        "cantidadFacturasSeleccionadas": 2
      },
      {
        "nombreCliente": "DDR Corp.",
        "facturacion": 821889.98,
        "beneficio": 760.32,
        "pagoAdelantado": 821129.66,
        "cantidadFacturas": 24,
        "cantidadFacturasSeleccionadas": 16
      },
      {
        "nombreCliente": "Pangaea Logistics Solutions Ltd.",
        "facturacion": 821068.45,
        "beneficio": 631.47,
        "pagoAdelantado": 820436.98,
        "cantidadFacturas": 29,
        "cantidadFacturasSeleccionadas": 29
      },
      {
        "nombreCliente": "Boston Private Financial Holdings, Inc.",
        "facturacion": 194916.98,
        "beneficio": 633.44,
        "pagoAdelantado": 194283.54,
        "cantidadFacturas": 42,
        "cantidadFacturasSeleccionadas": 42
      },
      {
        "nombreCliente": "MYOS RENS Technology Inc.",
        "facturacion": 429025.93,
        "beneficio": 659.36,
        "pagoAdelantado": 428366.57,
        "cantidadFacturas": 8,
        "cantidadFacturasSeleccionadas": 8
      },
      {
        "nombreCliente": "Mitsubishi UFJ Financial Group Inc",
        "facturacion": 933012.51,
        "beneficio": 939.99,
        "pagoAdelantado": 932072.52,
        "cantidadFacturas": 31,
        "cantidadFacturasSeleccionadas": 31
      },
      {
        "nombreCliente": "Maiden Holdings, Ltd.",
        "facturacion": 197361.4,
        "beneficio": 965.68,
        "pagoAdelantado": 196395.72,
        "cantidadFacturas": 19,
        "cantidadFacturasSeleccionadas": 8
      },
      {
        "nombreCliente": "AmTrust Financial Services, Inc.",
        "facturacion": 955894.05,
        "beneficio": 702.02,
        "pagoAdelantado": 955192.03,
        "cantidadFacturas": 28,
        "cantidadFacturasSeleccionadas": 13
      },
      {
        "nombreCliente": "Southern Company (The)",
        "facturacion": 777369.59,
        "beneficio": 628.55,
        "pagoAdelantado": 776741.04,
        "cantidadFacturas": 19,
        "cantidadFacturasSeleccionadas": 2
      },
      {
        "nombreCliente": "Matador Resources Company",
        "facturacion": 983605.81,
        "beneficio": 833.81,
        "pagoAdelantado": 982772.0,
        "cantidadFacturas": 6,
        "cantidadFacturasSeleccionadas": 6
      },
      {
        "nombreCliente": "Goldman Sachs Group, Inc. (The)",
        "facturacion": 900610.66,
        "beneficio": 940.87,
        "pagoAdelantado": 899669.79,
        "cantidadFacturas": 1,
        "cantidadFacturasSeleccionadas": 1
      },
      {
        "nombreCliente": "First Trust Dorsey Wright Focus 5 ETF",
        "facturacion": 85280.56,
        "beneficio": 674.35,
        "pagoAdelantado": 84606.21,
        "cantidadFacturas": 39,
        "cantidadFacturasSeleccionadas": 21
      },
      {
        "nombreCliente": "Reading International Inc",
        "facturacion": 462969.29,
        "beneficio": 721.36,
        "pagoAdelantado": 462247.93,
        "cantidadFacturas": 19,
        "cantidadFacturasSeleccionadas": 19
      },
      {
        "nombreCliente": "Kennedy-Wilson Holdings Inc.",
        "facturacion": 813065.62,
        "beneficio": 724.0,
        "pagoAdelantado": 812341.62,
        "cantidadFacturas": 39,
        "cantidadFacturasSeleccionadas": 5
      },
      {
        "nombreCliente": "1-800 FLOWERS.COM, Inc.",
        "facturacion": 312016.44,
        "beneficio": 922.44,
        "pagoAdelantado": 311094.0,
        "cantidadFacturas": 44,
        "cantidadFacturasSeleccionadas": 4
      },
      {
        "nombreCliente": "Proshares UltraPro Nasdaq Biotechnology",
        "facturacion": 70781.01,
        "beneficio": 893.44,
        "pagoAdelantado": 69887.57,
        "cantidadFacturas": 3,
        "cantidadFacturasSeleccionadas": 3
      },
      {
        "nombreCliente": "Dime Community Bancshares, Inc.",
        "facturacion": 260242.77,
        "beneficio": 782.03,
        "pagoAdelantado": 259460.74,
        "cantidadFacturas": 6,
        "cantidadFacturasSeleccionadas": 6
      },
      {
        "nombreCliente": "Dynasil Corporation of America",
        "facturacion": 211903.22,
        "beneficio": 868.88,
        "pagoAdelantado": 211034.34,
        "cantidadFacturas": 34,
        "cantidadFacturasSeleccionadas": 22
      },
      {
        "nombreCliente": "Douglas Dynamics, Inc.",
        "facturacion": 805439.05,
        "beneficio": 874.62,
        "pagoAdelantado": 804564.43,
        "cantidadFacturas": 49,
        "cantidadFacturasSeleccionadas": 17
      },
      {
        "nombreCliente": "ROBO Global Robotics and Automation Index ETF",
        "facturacion": 300607.98,
        "beneficio": 925.92,
        "pagoAdelantado": 299682.06,
        "cantidadFacturas": 50,
        "cantidadFacturasSeleccionadas": 5
      },
      {
        "nombreCliente": "NCI, Inc.",
        "facturacion": 984735.44,
        "beneficio": 689.46,
        "pagoAdelantado": 984045.98,
        "cantidadFacturas": 8,
        "cantidadFacturasSeleccionadas": 8
      },
      {
        "nombreCliente": "BLACKROCK INTERNATIONAL, LTD.",
        "facturacion": 218238.61,
        "beneficio": 992.7,
        "pagoAdelantado": 217245.91,
        "cantidadFacturas": 16,
        "cantidadFacturasSeleccionadas": 16
      },
      {
        "nombreCliente": "BioCryst Pharmaceuticals, Inc.",
        "facturacion": 668064.75,
        "beneficio": 742.05,
        "pagoAdelantado": 667322.7,
        "cantidadFacturas": 2,
        "cantidadFacturasSeleccionadas": 2
      },
      {
        "nombreCliente": "Versartis, Inc.",
        "facturacion": 920556.74,
        "beneficio": 683.67,
        "pagoAdelantado": 919873.07,
        "cantidadFacturas": 33,
        "cantidadFacturasSeleccionadas": 33
      },
      {
        "nombreCliente": "Marine Petroleum Trust",
        "facturacion": 229269.67,
        "beneficio": 731.43,
        "pagoAdelantado": 228538.24,
        "cantidadFacturas": 2,
        "cantidadFacturasSeleccionadas": 2
      },
      {
        "nombreCliente": "Amkor Technology, Inc.",
        "facturacion": 574036.21,
        "beneficio": 791.89,
        "pagoAdelantado": 573244.32,
        "cantidadFacturas": 24,
        "cantidadFacturasSeleccionadas": 7
      },
      {
        "nombreCliente": "AVX Corporation",
        "facturacion": 687523.62,
        "beneficio": 782.3,
        "pagoAdelantado": 686741.32,
        "cantidadFacturas": 7,
        "cantidadFacturasSeleccionadas": 7
      },
      {
        "nombreCliente": "Flexion Therapeutics, Inc.",
        "facturacion": 395680.77,
        "beneficio": 929.33,
        "pagoAdelantado": 394751.44,
        "cantidadFacturas": 45,
        "cantidadFacturasSeleccionadas": 34
      },
      {
        "nombreCliente": "Apartment Investment and Management Company",
        "facturacion": 243662.14,
        "beneficio": 617.58,
        "pagoAdelantado": 243044.56,
        "cantidadFacturas": 5,
        "cantidadFacturasSeleccionadas": 5
      },
      {
        "nombreCliente": "Yulong Eco-Materials Limited",
        "facturacion": 545045.55,
        "beneficio": 520.03,
        "pagoAdelantado": 544525.52,
        "cantidadFacturas": 22,
        "cantidadFacturasSeleccionadas": 22
      },
      {
        "nombreCliente": "S&W Seed Company",
        "facturacion": 591888.58,
        "beneficio": 914.04,
        "pagoAdelantado": 590974.54,
        "cantidadFacturas": 18,
        "cantidadFacturasSeleccionadas": 3
      },
      {
        "nombreCliente": "Banc of California, Inc.",
        "facturacion": 322922.74,
        "beneficio": 918.36,
        "pagoAdelantado": 322004.38,
        "cantidadFacturas": 46,
        "cantidadFacturasSeleccionadas": 7
      },
      {
        "nombreCliente": "Heartland Financial USA, Inc.",
        "facturacion": 634483.56,
        "beneficio": 542.71,
        "pagoAdelantado": 633940.85,
        "cantidadFacturas": 16,
        "cantidadFacturasSeleccionadas": 16
      },
      {
        "nombreCliente": "ITUS Corporation",
        "facturacion": 879903.86,
        "beneficio": 779.97,
        "pagoAdelantado": 879123.89,
        "cantidadFacturas": 25,
        "cantidadFacturasSeleccionadas": 11
      },
      {
        "nombreCliente": "Conatus Pharmaceuticals Inc.",
        "facturacion": 293320.1,
        "beneficio": 990.91,
        "pagoAdelantado": 292329.19,
        "cantidadFacturas": 42,
        "cantidadFacturasSeleccionadas": 42
      },
      {
        "nombreCliente": "Onconova Therapeutics, Inc.",
        "facturacion": 41155.97,
        "beneficio": 665.76,
        "pagoAdelantado": 40490.21,
        "cantidadFacturas": 32,
        "cantidadFacturasSeleccionadas": 28
      },
      {
        "nombreCliente": "Sensata Technologies Holding N.V.",
        "facturacion": 461646.48,
        "beneficio": 985.03,
        "pagoAdelantado": 460661.45,
        "cantidadFacturas": 27,
        "cantidadFacturasSeleccionadas": 4
      },
      {
        "nombreCliente": "Signature Bank",
        "facturacion": 455251.25,
        "beneficio": 517.56,
        "pagoAdelantado": 454733.69,
        "cantidadFacturas": 37,
        "cantidadFacturasSeleccionadas": 37
      },
      {
        "nombreCliente": "NorthWestern Corporation",
        "facturacion": 881648.68,
        "beneficio": 773.14,
        "pagoAdelantado": 880875.54,
        "cantidadFacturas": 39,
        "cantidadFacturasSeleccionadas": 22
      },
      {
        "nombreCliente": "Blackbaud, Inc.",
        "facturacion": 232052.93,
        "beneficio": 980.24,
        "pagoAdelantado": 231072.69,
        "cantidadFacturas": 25,
        "cantidadFacturasSeleccionadas": 25
      },
      {
        "nombreCliente": "Global Indemnity Limited",
        "facturacion": 819740.15,
        "beneficio": 909.36,
        "pagoAdelantado": 818830.79,
        "cantidadFacturas": 20,
        "cantidadFacturasSeleccionadas": 20
      },
      {
        "nombreCliente": "First Trust Senior Loan Fund ETF",
        "facturacion": 553160.38,
        "beneficio": 998.84,
        "pagoAdelantado": 552161.54,
        "cantidadFacturas": 12,
        "cantidadFacturasSeleccionadas": 11
      },
      {
        "nombreCliente": "iShares FTSE EPRA/NAREIT Global Real Estate ex-U.S. Index Fund",
        "facturacion": 411538.07,
        "beneficio": 571.78,
        "pagoAdelantado": 410966.29,
        "cantidadFacturas": 44,
        "cantidadFacturasSeleccionadas": 6
      },
      {
        "nombreCliente": "Weibo Corporation",
        "facturacion": 336109.23,
        "beneficio": 686.93,
        "pagoAdelantado": 335422.3,
        "cantidadFacturas": 2,
        "cantidadFacturasSeleccionadas": 2
      },
      {
        "nombreCliente": "UBS AG",
        "facturacion": 900912.01,
        "beneficio": 988.62,
        "pagoAdelantado": 899923.39,
        "cantidadFacturas": 7,
        "cantidadFacturasSeleccionadas": 7
      },
      {
        "nombreCliente": "Universal Technical Institute Inc",
        "facturacion": 584892.64,
        "beneficio": 505.28,
        "pagoAdelantado": 584387.36,
        "cantidadFacturas": 36,
        "cantidadFacturasSeleccionadas": 17
      },
      {
        "nombreCliente": "Weibo Corporation",
        "facturacion": 596286.72,
        "beneficio": 616.12,
        "pagoAdelantado": 595670.6,
        "cantidadFacturas": 8,
        "cantidadFacturasSeleccionadas": 8
      },
      {
        "nombreCliente": "NorthWestern Corporation",
        "facturacion": 645089.64,
        "beneficio": 690.25,
        "pagoAdelantado": 644399.39,
        "cantidadFacturas": 2,
        "cantidadFacturasSeleccionadas": 2
      },
      {
        "nombreCliente": "Elevate Credit, Inc.",
        "facturacion": 430990.84,
        "beneficio": 893.02,
        "pagoAdelantado": 430097.82,
        "cantidadFacturas": 44,
        "cantidadFacturasSeleccionadas": 31
      },
      {
        "nombreCliente": "Tetraphase Pharmaceuticals, Inc.",
        "facturacion": 397196.87,
        "beneficio": 548.69,
        "pagoAdelantado": 396648.18,
        "cantidadFacturas": 2,
        "cantidadFacturasSeleccionadas": 2
      },
      {
        "nombreCliente": "Crawford & Company",
        "facturacion": 89490.31,
        "beneficio": 536.41,
        "pagoAdelantado": 88953.9,
        "cantidadFacturas": 27,
        "cantidadFacturasSeleccionadas": 27
      },
      {
        "nombreCliente": "Movado Group Inc.",
        "facturacion": 58680.56,
        "beneficio": 680.27,
        "pagoAdelantado": 58000.29,
        "cantidadFacturas": 25,
        "cantidadFacturasSeleccionadas": 25
      },
      {
        "nombreCliente": "Vanguard Long-Term Government Bond ETF",
        "facturacion": 224102.28,
        "beneficio": 937.25,
        "pagoAdelantado": 223165.03,
        "cantidadFacturas": 35,
        "cantidadFacturasSeleccionadas": 14
      },
      {
        "nombreCliente": "Kate Spade & Company",
        "facturacion": 383832.84,
        "beneficio": 646.64,
        "pagoAdelantado": 383186.2,
        "cantidadFacturas": 2,
        "cantidadFacturasSeleccionadas": 2
      },
      {
        "nombreCliente": "GATX Corporation",
        "facturacion": 527226.37,
        "beneficio": 690.8,
        "pagoAdelantado": 526535.57,
        "cantidadFacturas": 13,
        "cantidadFacturasSeleccionadas": 13
      },
      {
        "nombreCliente": "Cross Country Healthcare, Inc.",
        "facturacion": 395969.66,
        "beneficio": 680.52,
        "pagoAdelantado": 395289.14,
        "cantidadFacturas": 30,
        "cantidadFacturasSeleccionadas": 21
      },
      {
        "nombreCliente": "Summer Infant, Inc.",
        "facturacion": 106920.17,
        "beneficio": 800.06,
        "pagoAdelantado": 106120.11,
        "cantidadFacturas": 32,
        "cantidadFacturasSeleccionadas": 32
      },
      {
        "nombreCliente": "MPLX LP",
        "facturacion": 187122.56,
        "beneficio": 865.82,
        "pagoAdelantado": 186256.74,
        "cantidadFacturas": 10,
        "cantidadFacturasSeleccionadas": 10
      },
      {
        "nombreCliente": "Mettler-Toledo International, Inc.",
        "facturacion": 334627.04,
        "beneficio": 792.29,
        "pagoAdelantado": 333834.75,
        "cantidadFacturas": 32,
        "cantidadFacturasSeleccionadas": 21
      },
      {
        "nombreCliente": "Lawson Products, Inc.",
        "facturacion": 730655.75,
        "beneficio": 682.2,
        "pagoAdelantado": 729973.55,
        "cantidadFacturas": 27,
        "cantidadFacturasSeleccionadas": 27
      },
      {
        "nombreCliente": "Biogen Inc.",
        "facturacion": 844393.35,
        "beneficio": 697.54,
        "pagoAdelantado": 843695.81,
        "cantidadFacturas": 13,
        "cantidadFacturasSeleccionadas": 13
      },
      {
        "nombreCliente": "Buckeye Partners L.P.",
        "facturacion": 190052.68,
        "beneficio": 967.32,
        "pagoAdelantado": 189085.36,
        "cantidadFacturas": 19,
        "cantidadFacturasSeleccionadas": 2
      },
      {
        "nombreCliente": "Celgene Corporation",
        "facturacion": 696177.28,
        "beneficio": 711.54,
        "pagoAdelantado": 695465.74,
        "cantidadFacturas": 35,
        "cantidadFacturasSeleccionadas": 34
      },
      {
        "nombreCliente": "Alexandria Real Estate Equities, Inc.",
        "facturacion": 759780.82,
        "beneficio": 591.81,
        "pagoAdelantado": 759189.01,
        "cantidadFacturas": 23,
        "cantidadFacturasSeleccionadas": 21
      },
      {
        "nombreCliente": "First Guaranty Bancshares, Inc.",
        "facturacion": 134953.11,
        "beneficio": 517.24,
        "pagoAdelantado": 134435.87,
        "cantidadFacturas": 15,
        "cantidadFacturasSeleccionadas": 6
      },
      {
        "nombreCliente": "SVB Financial Group",
        "facturacion": 81494.43,
        "beneficio": 826.38,
        "pagoAdelantado": 80668.05,
        "cantidadFacturas": 3,
        "cantidadFacturasSeleccionadas": 3
      },
      {
        "nombreCliente": "Connecticut Water Service, Inc.",
        "facturacion": 967548.26,
        "beneficio": 736.55,
        "pagoAdelantado": 966811.71,
        "cantidadFacturas": 17,
        "cantidadFacturasSeleccionadas": 17
      },
      {
        "nombreCliente": "Anworth Mortgage Asset  Corporation",
        "facturacion": 96567.51,
        "beneficio": 818.07,
        "pagoAdelantado": 95749.44,
        "cantidadFacturas": 40,
        "cantidadFacturasSeleccionadas": 28
      },
      {
        "nombreCliente": "Amec Plc Ord",
        "facturacion": 752511.79,
        "beneficio": 843.32,
        "pagoAdelantado": 751668.47,
        "cantidadFacturas": 45,
        "cantidadFacturasSeleccionadas": 17
      },
      {
        "nombreCliente": "UMB Financial Corporation",
        "facturacion": 636540.16,
        "beneficio": 625.85,
        "pagoAdelantado": 635914.31,
        "cantidadFacturas": 23,
        "cantidadFacturasSeleccionadas": 23
      },
      {
        "nombreCliente": "WideOpenWest, Inc.",
        "facturacion": 101588.2,
        "beneficio": 764.52,
        "pagoAdelantado": 100823.68,
        "cantidadFacturas": 38,
        "cantidadFacturasSeleccionadas": 27
      },
      {
        "nombreCliente": "NOW Inc.",
        "facturacion": 253222.66,
        "beneficio": 723.49,
        "pagoAdelantado": 252499.17,
        "cantidadFacturas": 24,
        "cantidadFacturasSeleccionadas": 24
      },
      {
        "nombreCliente": "Utah Medical Products, Inc.",
        "facturacion": 30340.8,
        "beneficio": 630.7,
        "pagoAdelantado": 29710.1,
        "cantidadFacturas": 26,
        "cantidadFacturasSeleccionadas": 24
      },
      {
        "nombreCliente": "Equity Commonwealth",
        "facturacion": 694699.32,
        "beneficio": 564.98,
        "pagoAdelantado": 694134.34,
        "cantidadFacturas": 38,
        "cantidadFacturasSeleccionadas": 23
      },
      {
        "nombreCliente": "Green Brick Partners, Inc.",
        "facturacion": 846518.84,
        "beneficio": 737.18,
        "pagoAdelantado": 845781.66,
        "cantidadFacturas": 27,
        "cantidadFacturasSeleccionadas": 27
      },
      {
        "nombreCliente": "Penns Woods Bancorp, Inc.",
        "facturacion": 923780.19,
        "beneficio": 707.24,
        "pagoAdelantado": 923072.95,
        "cantidadFacturas": 40,
        "cantidadFacturasSeleccionadas": 22
      },
      {
        "nombreCliente": "Datawatch Corporation",
        "facturacion": 546003.22,
        "beneficio": 885.45,
        "pagoAdelantado": 545117.77,
        "cantidadFacturas": 4,
        "cantidadFacturasSeleccionadas": 4
      },
      {
        "nombreCliente": "Kohl's Corporation",
        "facturacion": 827391.45,
        "beneficio": 854.79,
        "pagoAdelantado": 826536.66,
        "cantidadFacturas": 40,
        "cantidadFacturasSeleccionadas": 7
      },
      {
        "nombreCliente": "Emerald Expositions Events, Inc.",
        "facturacion": 529529.67,
        "beneficio": 804.76,
        "pagoAdelantado": 528724.91,
        "cantidadFacturas": 49,
        "cantidadFacturasSeleccionadas": 4
      },
      {
        "nombreCliente": "Goldman Sachs Group, Inc. (The)",
        "facturacion": 455093.58,
        "beneficio": 819.43,
        "pagoAdelantado": 454274.15,
        "cantidadFacturas": 8,
        "cantidadFacturasSeleccionadas": 8
      },
      {
        "nombreCliente": "ExlService Holdings, Inc.",
        "facturacion": 940950.3,
        "beneficio": 518.66,
        "pagoAdelantado": 940431.64,
        "cantidadFacturas": 37,
        "cantidadFacturasSeleccionadas": 6
      },
      {
        "nombreCliente": "Hospitality Properties Trust",
        "facturacion": 984345.92,
        "beneficio": 987.85,
        "pagoAdelantado": 983358.07,
        "cantidadFacturas": 36,
        "cantidadFacturasSeleccionadas": 1
      },
      {
        "nombreCliente": "Arbor Realty Trust",
        "facturacion": 525804.03,
        "beneficio": 935.59,
        "pagoAdelantado": 524868.44,
        "cantidadFacturas": 10,
        "cantidadFacturasSeleccionadas": 10
      },
      {
        "nombreCliente": "Insignia Systems, Inc.",
        "facturacion": 849557.22,
        "beneficio": 733.39,
        "pagoAdelantado": 848823.83,
        "cantidadFacturas": 12,
        "cantidadFacturasSeleccionadas": 12
      },
      {
        "nombreCliente": "Hub Group, Inc.",
        "facturacion": 404123.09,
        "beneficio": 828.76,
        "pagoAdelantado": 403294.33,
        "cantidadFacturas": 30,
        "cantidadFacturasSeleccionadas": 4
      },
      {
        "nombreCliente": "Pampa Energia S.A.",
        "facturacion": 323242.03,
        "beneficio": 807.38,
        "pagoAdelantado": 322434.65,
        "cantidadFacturas": 31,
        "cantidadFacturasSeleccionadas": 19
      },
      {
        "nombreCliente": "Aethlon Medical, Inc.",
        "facturacion": 338769.66,
        "beneficio": 570.67,
        "pagoAdelantado": 338198.99,
        "cantidadFacturas": 5,
        "cantidadFacturasSeleccionadas": 5
      },
      {
        "nombreCliente": "Vermilion Energy Inc.",
        "facturacion": 500897.98,
        "beneficio": 714.93,
        "pagoAdelantado": 500183.05,
        "cantidadFacturas": 11,
        "cantidadFacturasSeleccionadas": 11
      },
      {
        "nombreCliente": "First Trust NASDAQ-100 Ex-Technology Sector Index Fund",
        "facturacion": 444296.58,
        "beneficio": 519.45,
        "pagoAdelantado": 443777.13,
        "cantidadFacturas": 7,
        "cantidadFacturasSeleccionadas": 7
      },
      {
        "nombreCliente": "Cesca Therapeutics Inc.",
        "facturacion": 301268.56,
        "beneficio": 773.07,
        "pagoAdelantado": 300495.49,
        "cantidadFacturas": 21,
        "cantidadFacturasSeleccionadas": 21
      },
      {
        "nombreCliente": "Reinsurance Group of America, Incorporated",
        "facturacion": 160745.17,
        "beneficio": 830.19,
        "pagoAdelantado": 159914.98,
        "cantidadFacturas": 35,
        "cantidadFacturasSeleccionadas": 35
      },
      {
        "nombreCliente": "Exponent, Inc.",
        "facturacion": 956733.49,
        "beneficio": 915.59,
        "pagoAdelantado": 955817.9,
        "cantidadFacturas": 28,
        "cantidadFacturasSeleccionadas": 13
      },
      {
        "nombreCliente": "China Southern Airlines Company Limited",
        "facturacion": 295471.05,
        "beneficio": 786.24,
        "pagoAdelantado": 294684.81,
        "cantidadFacturas": 38,
        "cantidadFacturasSeleccionadas": 26
      },
      {
        "nombreCliente": "Nutanix, Inc.",
        "facturacion": 205968.18,
        "beneficio": 993.99,
        "pagoAdelantado": 204974.19,
        "cantidadFacturas": 21,
        "cantidadFacturasSeleccionadas": 21
      }
    ];

    return Scaffold(
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomSideMenu(),
            Expanded(
              child: Column(
                children: [
                  //Top Menu
                  CustomTopMenu(
                    sideMenuController: sideMenuController,
                    sideNotificationsController: sideNotificationsController,
                    pantalla: 'Propuesta de Pago',
                  ),
                  //Contenido
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Encabezado
                          CustomHeaderOptions(
                            encabezado: 'Selección de Pagos Anticipados',
                            filterSelected: filterSelected,
                            gridSelected: gridSelected,
                            onFilterSelected: () {
                              setState(() {
                                filterSelected = !filterSelected;
                              });
                            },
                            onGridSelected: () {
                              setState(() {
                                gridSelected = true;
                              });
                            },
                            onListSelected: () {
                              setState(() {
                                gridSelected = false;
                              });
                            },
                          ),
                          //Contenedores
                          const ContenedoresPagosAnticipados(),
                          //Lista - Grid
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: SizedBox(
                              height: height * 1024 - 415,
                              child: gridSelected
                                  ? GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 400,
                                        //childAspectRatio: 3,
                                        crossAxisSpacing: 35,
                                        mainAxisSpacing: 35,
                                        mainAxisExtent: 230,
                                      ),
                                      shrinkWrap: true,
                                      itemCount: listadoEjemplo.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return CustomCard(
                                          moneda: 'GTQ',
                                          nombreCliente: listadoEjemplo[index]['nombreCliente'],
                                          facturacion: listadoEjemplo[index]['facturacion'],
                                          beneficio: listadoEjemplo[index]['beneficio'],
                                          pagoAdelantado: listadoEjemplo[index]['pagoAdelantado'],
                                          cantidadFacturas: listadoEjemplo[index]['cantidadFacturas'],
                                          cantidadFacturasSeleccionadas: listadoEjemplo[index]
                                              ['cantidadFacturasSeleccionadas'],
                                        );
                                      },
                                    )
                                  : Column(
                                      children: [
                                        //Encabezado
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 16.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: height * 79,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: AppTheme.of(context).primaryColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 24),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.person,
                                                          size: 20,
                                                          color: AppTheme.of(context).primaryBackground,
                                                        ),
                                                        Text(
                                                          'Cliente',
                                                          style: AppTheme.of(context).subtitle1.override(
                                                                fontFamily: 'Gotham',
                                                                useGoogleFonts: false,
                                                                color: AppTheme.of(context).primaryBackground,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.content_paste,
                                                          size: 20,
                                                          color: AppTheme.of(context).primaryBackground,
                                                        ),
                                                        Text(
                                                          'Num. Facturas',
                                                          style: AppTheme.of(context).subtitle1.override(
                                                                fontFamily: 'Gotham',
                                                                useGoogleFonts: false,
                                                                color: AppTheme.of(context).primaryBackground,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.receipt_long,
                                                          color: AppTheme.of(context).primaryBackground,
                                                        ),
                                                        Text(
                                                          'Facturación',
                                                          style: AppTheme.of(context).subtitle1.override(
                                                                fontFamily: 'Gotham',
                                                                useGoogleFonts: false,
                                                                color: AppTheme.of(context).primaryBackground,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.payments_outlined,
                                                          color: AppTheme.of(context).primaryBackground,
                                                        ),
                                                        Text(
                                                          'Beneficio',
                                                          style: AppTheme.of(context).subtitle1.override(
                                                                fontFamily: 'Gotham',
                                                                useGoogleFonts: false,
                                                                color: AppTheme.of(context).primaryBackground,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.shopping_bag,
                                                          color: AppTheme.of(context).primaryBackground,
                                                        ),
                                                        Text(
                                                          'Pago Adelantado',
                                                          style: AppTheme.of(context).subtitle1.override(
                                                                fontFamily: 'Gotham',
                                                                useGoogleFonts: false,
                                                                color: AppTheme.of(context).primaryBackground,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 65),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Contenido
                                        Expanded(
                                          child: SizedBox(
                                            height: height * 505,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: 20,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (BuildContext ctx, index) {
                                                return CustomListCard(
                                                  moneda: 'GTQ',
                                                  nombreCliente: listadoEjemplo[index]['nombreCliente'],
                                                  facturacion: listadoEjemplo[index]['facturacion'],
                                                  beneficio: listadoEjemplo[index]['beneficio'],
                                                  pagoAdelantado: listadoEjemplo[index]['pagoAdelantado'],
                                                  cantidadFacturas: listadoEjemplo[index]['cantidadFacturas'],
                                                  cantidadFacturasSeleccionadas: listadoEjemplo[index]
                                                      ['cantidadFacturasSeleccionadas'],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          )
                        ],
                      ),
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
      ),
    );
  }
}
