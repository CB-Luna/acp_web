import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/functions/date_format.dart';
import 'package:acp_web/services/api_error_handler.dart';

class ClientesProvider extends ChangeNotifier {
  PlutoGridStateManager? stateManager;
  List<PlutoRow> rows = [];

  TextEditingController codigoClienteController = TextEditingController();
  TextEditingController tasaAnualController = TextEditingController();
  TextEditingController tasaPreferencialController = TextEditingController();
  TextEditingController facturacionMayorAController = TextEditingController();
  TextEditingController fechaContratoController = TextEditingController();

  bool activo = true;

  List<Cliente> clientes = [];
  String? sociedadSeleccionada;

  String? nombreImagen;
  Uint8List? webImage;

  Cliente? cliente;
  bool modificado = false;

  final busquedaController = TextEditingController();
  String orden = "cliente_id";

  Future<void> updateState() async {
    busquedaController.clear();
    await getClientes();
  }

  void initCliente(Cliente cliente) async {
    clearControllers(notify: false);
    this.cliente = cliente;
    sociedadSeleccionada = cliente.sociedadActual;
    tasaAnualController.text = cliente.tasaAnual?.toString() ?? '';
    tasaPreferencialController.text = cliente.tasaPreferencial?.toString() ?? '';
    facturacionMayorAController.text = cliente.facturacionMayorA?.toString() ?? '';
    fechaContratoController.text = dateFormatInverse(cliente.fechaContrato);
  }

  void clearControllers({bool clearEmail = true, bool notify = true}) {
    codigoClienteController.clear();
    tasaAnualController.clear();
    tasaPreferencialController.clear();
    facturacionMayorAController.clear();

    nombreImagen = null;
    webImage = null;

    modificado = false;

    if (notify) notifyListeners();
  }

  Future<void> getClientes() async {
    try {
      final query = supabase.from('cliente_completo').select();

      final res = await query.like('nombre_fiscal', '%${busquedaController.text}%').order(orden, ascending: true);

      if (res == null) {
        log('Error en getUsuarios()');
        return;
      }

      clientes = (res as List<dynamic>).map((cliente) => Cliente.fromJson(jsonEncode(cliente))).toList();

      llenarPlutoGrid(clientes);
    } catch (e) {
      log('Error en getClientes() - $e');
    }
  }

  void llenarPlutoGrid(List<Cliente> usuarios) {
    rows.clear();
    for (Cliente cliente in clientes) {
      rows.add(
        PlutoRow(
          cells: {
            'cliente_id': PlutoCell(value: cliente.clienteId),
            'cliente': PlutoCell(value: cliente),
            'fecha_registro': PlutoCell(value: dateFormat(cliente.fechaRegistro)),
            'sociedad': PlutoCell(value: cliente.sociedadActual),
            'moneda': PlutoCell(value: cliente.moneda),
            'tasa_anual': PlutoCell(value: '${cliente.tasaAnual.toString()}%'),
            'activo': PlutoCell(value: cliente.estatus),
            'acciones': PlutoCell(value: cliente),
          },
        ),
      );
    }
    if (stateManager != null) stateManager!.notifyListeners();
    notifyListeners();
  }

  Future<bool> getCliente() async {
    try {
      var res = await supabase.from('cliente').select('cliente_id').eq(
            'codigo_cliente',
            codigoClienteController.text,
          ) as List;

      if (res.isNotEmpty) {
        await ApiErrorHandler.callToast('Ya existe un cliente con este código');
        return false;
      }

      res = await supabase.from('cliente_sap_b2b').select().eq(
            'codigo_cliente',
            codigoClienteController.text,
          ) as List;

      if (res.isEmpty) {
        await ApiErrorHandler.callToast('No se encontró un cliente con este código');
        return false;
      }

      cliente = Cliente.fromClienteSap(res.first);

      return true;
    } catch (e) {
      log('Error en getCliente() - $e');
      return false;
    }
  }

  Future<void> cambiarCliente(String sociedad) async {
    try {
      final res = await supabase
          .from('cliente_completo')
          .select()
          .eq('cliente_id', cliente!.clienteId)
          .eq('sociedad', sociedad);
      cliente = Cliente.fromMap(res.first);
      initCliente(cliente!);
      notifyListeners();
    } catch (e) {
      log('Error en cambiar cliente');
    }
  }

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) return;

    final String fileExtension = p.extension(pickedImage.name);
    const uuid = Uuid();
    final String fileName = uuid.v1();
    nombreImagen = 'logo-$fileName$fileExtension';

    webImage = await pickedImage.readAsBytes();

    notifyListeners();
  }

  void clearImage() {
    webImage = null;
    nombreImagen = null;
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (webImage != null && nombreImagen != null) {
      await supabase.storage.from('logo-clientes').uploadBinary(
            nombreImagen!,
            webImage!,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      return nombreImagen;
    }
    return null;
  }

  Future<void> validarImagen(String? imagen) async {
    if (imagen == null) {
      if (webImage != null) {
        //usuario no tiene imagen y se agrego => se sube imagen
        final res = await uploadImage();
        if (res == null) {
          ApiErrorHandler.callToast('Error al subir imagen');
        }
      }
      //usuario no tiene imagen y no se agrego => no hace nada
    } else {
      //usuario tiene imagen y se borro => se borra en bd
      if (webImage == null && nombreImagen == null) {
        await supabase.storage.from('logo-clientes').remove([imagen]);
      }
      //usuario tiene imagen y no se modifico => no se hace nada

      //usuario tiene imagen y se cambio => se borra en bd y se sube la nueva
      if (webImage != null && nombreImagen != imagen) {
        await supabase.storage.from('logo-clientes').remove([imagen]);
        final res2 = await uploadImage();
        if (res2 == null) {
          ApiErrorHandler.callToast('Error al subir imagen');
        }
      }
    }
  }

  void agregarContacto() {
    if (cliente?.clienteId == null) {
      return;
    }
    modificado = true;
    final contactoVacio = Contacto(
      nombre: '',
      correo: '',
      puesto: '',
      telefono: '',
      clienteFk: cliente!.clienteId!,
    );
    cliente!.contactos.add(contactoVacio);
    notifyListeners();
  }

  void eliminarContacto(int index) {
    cliente!.contactos.removeAt(index);
    modificado = true;
    notifyListeners();
  }

  Future<bool> guardarCliente() async {
    try {
      if (cliente == null) return false;
      if (!modificado) return true;

      cliente!.tasaAnual = num.tryParse(tasaAnualController.text);
      cliente!.fechaContrato = DateTime.tryParse(fechaContratoController.text);
      cliente!.tasaPreferencial = num.tryParse(tasaPreferencialController.text);
      cliente!.facturacionMayorA = num.tryParse(facturacionMayorAController.text);

      if (cliente!.clienteId == null) {
        //nuevo cliente - insertar en tabla

        final res = await supabase
            .from('cliente')
            .insert(
              cliente!.toMap(),
              defaultToNull: false,
            )
            .select('cliente_id');

        if ((res as List).isEmpty) return false;

        final clienteId = res.first['cliente_id'];

        //Crear contactos
        if (modificado == true) {
          for (var contacto in cliente!.contactos) {
            await supabase.from('contacto').insert(contacto.toMap(clienteId: clienteId));
          }
        }
      } else {
        //cliente existente - actualizar tabla
        await supabase.from('cliente').update(cliente!.toMap()).eq('cliente_id', cliente!.clienteId);
        //Crear o actualizar contactos
        for (var contacto in cliente!.contactos) {
          if (contacto.contactoId == null) {
            //crear
            await supabase.from('contacto').insert(contacto.toMap(clienteId: cliente!.clienteId));
          } else {
            //actualizar
            await supabase.from('contacto').update(contacto.toMap(clienteId: cliente!.clienteId)).eq(
                  'contacto_id',
                  contacto.contactoId,
                );
          }
        }
      }

      return true;
    } catch (e) {
      log('Error en guardarCliente() - $e');
      return false;
    }
  }

  void setTasaAnual() {
    final parsedValue = num.tryParse(tasaAnualController.text);
    if (parsedValue == null) return;
    modificado = true;
    // cliente!.tasaAnual = parsedValue;
    notifyListeners();
  }

  String getTasaAnualAsString() {
    num? parsedValue = num.tryParse(tasaAnualController.text);
    if (parsedValue == null) return 'Tasa Anual';
    parsedValue = parsedValue / 100;
    return parsedValue.toStringAsPrecision(6);
  }

  Future<bool> updateActivado(Cliente cliente, bool value, int rowIndex) async {
    try {
      //actualizar usuario
      await supabase.from('cliente').update({'activo': value}).eq('cliente_id', cliente.clienteId);
      rows[rowIndex].cells['activo']?.value = cliente.estatus;
      if (stateManager != null) stateManager!.notifyListeners();
      return true;
    } catch (e) {
      log('Error en updateActivado() - $e');
      return false;
    }
  }

  @override
  void dispose() {
    busquedaController.dispose();
    codigoClienteController.dispose();
    tasaAnualController.dispose();
    tasaPreferencialController.dispose();
    facturacionMayorAController.dispose();
    fechaContratoController.dispose();
    super.dispose();
  }
}
