import 'dart:developer';
//import 'dart:typed_data';

/* import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart'; */
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SeleccionaPagosanticipadosProvider extends ChangeNotifier {
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;

  final controllerBusqueda = TextEditingController();

  final controllerFondoDisp = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final controllerFondoDispFake = TextEditingController();

  List<dynamic> listCarrito = [];

  bool ejecBloq = false;

  Future<void> clearAll() async {
    //pdfController = null;
    rows = [];
    listCarrito = [];

    controllerFondoDisp.text = '0.00';
    controllerFondoDispFake.text = '';

    ejecBloq = false;
    controllerBusqueda.clear();

    await getRecords();
  }

  Future<void> getRecords() async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }
    try {
      await checkInList();
    } catch (e) {
      log('Error en getPartidasPull() - $e');
    }
  }

  Future<bool> updateRecords() async {
    try {
      await clearAll();
      return true;
    } catch (e) {
      log('Error en UpdatePartidasSolicitadas() - $e');
      return false;
    }
  }

  Future<void> checkInList() async {
    for (var element in rows) {
      if (element.checked == true) {}
    }
    return notifyListeners();
  }

  Future<void> uncheckAll() async {
    for (var element in rows) {
      element.setChecked(false);
    }
    await checkInList();
  }

  /* bool popupVisorPdfVisible = true;
  FilePickerResult? docProveedor;
  //PdfController? pdfController;

  void verPdf(bool visible) {
    popupVisorPdfVisible = visible;
    notifyListeners();
  }

  Uint8List? imageBytes;
  Future<void> pickDoc() async {
    FilePickerResult? picker = await FilePickerWeb.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png']);
    //get and load pdf
    if (picker != null) {
      docProveedor = picker;
      imageBytes = picker.files.single.bytes;
    } else {
      imageBytes = null;
    }

    notifyListeners();
    return;
  } */
}
