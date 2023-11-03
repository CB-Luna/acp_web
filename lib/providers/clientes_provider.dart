import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:acp_web/functions/date_format.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:acp_web/helpers/constants.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/helpers/supabase/queries.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/services/api_error_handler.dart';

class ClientesProvider extends ChangeNotifier {
  PlutoGridStateManager? stateManager;
  List<PlutoRow> rows = [];

  //ALTA USUARIO
  TextEditingController nombreController = TextEditingController();
  TextEditingController correoController = TextEditingController();

  bool activo = true;

  List<Cliente> clientes = [];

  String? nombreImagen;
  Uint8List? webImage;

  Cliente? cliente;

  //PANTALLA USUARIOS
  final busquedaController = TextEditingController();
  String orden = "cliente_id";

  Future<void> updateState() async {
    busquedaController.clear();
    await getClientes();
  }

  void clearControllers({bool clearEmail = true, bool notify = true}) {
    nombreController.clear();
    if (clearEmail) correoController.clear();

    nombreImagen = null;
    webImage = null;

    if (notify) notifyListeners();
  }

  Future<void> getClientes() async {
    try {
      final query = supabase.from('cliente').select();

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
            'sociedad': PlutoCell(value: cliente.sociedad),
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

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) return;

    final String fileExtension = p.extension(pickedImage.name);
    const uuid = Uuid();
    final String fileName = uuid.v1();
    nombreImagen = 'avatar-$fileName$fileExtension';

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
      await supabase.storage.from('avatars').uploadBinary(
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
        await supabase.storage.from('avatars').remove([imagen]);
      }
      //usuario tiene imagen y no se modifico => no se hace nada

      //usuario tiene imagen y se cambio => se borra en bd y se sube la nueva
      if (webImage != null && nombreImagen != imagen) {
        await supabase.storage.from('avatars').remove([imagen]);
        final res2 = await uploadImage();
        if (res2 == null) {
          ApiErrorHandler.callToast('Error al subir imagen');
        }
      }
    }
  }

  // Future<Map<String, String>?> registrarUsuario() async {
  //   try {
  //     //Registrar al usuario con una contraseña temporal
  //     var response = await http.post(
  //       Uri.parse('$supabaseUrl/auth/v1/signup'),
  //       headers: {'Content-Type': 'application/json', 'apiKey': anonKey},
  //       body: json.encode(
  //         {
  //           "email": correoController.text,
  //           "password": password,
  //         },
  //       ),
  //     );
  //     if (response.statusCode > 204) return {'Error': 'El usuario ya existe'};

  //     final String? userId = jsonDecode(response.body)['user']['id'];

  //     if (userId == null) return {'Error': 'Error al registrar al usuario'};

  //     // final bool tokenSaved = await SupabaseQueries.saveToken(userId, 'token_ingreso', token);

  //     // if (!tokenSaved) return {'Error': 'Error al guardar token'};

  //     // final bool emailSent = await sendEmail(correoController.text, password, token, 'alta');

  //     // if (!emailSent) return {'Error': 'Error al mandar email'};

  //     //retornar el id del usuario
  //     return {'userId': userId};
  //   } catch (e) {
  //     log('Error en registrarUsuario() - $e');
  //     return {'Error': 'Error al registrar usuario'};
  //   }
  // }

  // Future<bool> crearPerfilDeUsuario(String userId) async {
  //   if (rolSeleccionado == null) {
  //     return false;
  //   }
  //   try {
  //     await supabase.from('perfil_usuario').insert(
  //       {
  //         'perfil_usuario_id': userId,
  //         'nombre': nombreController.text,
  //         'apellido_paterno': apellidoPaternoController.text,
  //         'apellido_materno': apellidoMaternoController.text,
  //         'telefono': telefonoController.text,
  //         'rol_fk': rolSeleccionado!.rolId,
  //         'compania': 'ACP',
  //         'cliente_fk': cliente?.clienteId,
  //         'imagen': nombreImagen,
  //         'activo': activo,
  //       },
  //     );
  //     return true;
  //   } catch (e) {
  //     log('Error en crearPerfilDeUsuario() - $e');
  //     return false;
  //   }
  // }

  // Future<bool> editarPerfilDeUsuario(String userId) async {
  //   try {
  //     await supabase.from('perfil_usuario').update(
  //       {
  //         'nombre': nombreController.text,
  //         'apellido_paterno': apellidoPaternoController.text,
  //         'apellido_materno': apellidoMaternoController.text,
  //         'telefono': telefonoController.text,
  //         'rol_fk': rolSeleccionado!.rolId,
  //         'compania': 'ACP',
  //         'cliente_fk': cliente?.clienteId,
  //         'imagen': nombreImagen,
  //         'activo': activo,
  //       },
  //     ).eq('perfil_usuario_id', userId);
  //     return true;
  //   } catch (e) {
  //     log('Error en editarPerfilUsuario() - $e');
  //     return false;
  //   }
  // }

  // Future<void> initEditarUsuario(Usuario usuario) async {
  //   nombreController.text = usuario.nombre;
  //   apellidoPaternoController.text = usuario.apellidoPaterno;
  //   apellidoMaternoController.text = usuario.apellidoMaterno ?? '';
  //   correoController.text = usuario.email;
  //   telefonoController.text = usuario.telefono;
  //   rolSeleccionado = usuario.rol;
  //   activo = usuario.activo;
  //   nombreImagen = usuario.imagen;
  //   webImage = null;
  //   cliente = usuario.cliente;
  //   if (cliente != null) {
  //     await getCliente();
  //   }
  // }

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

  // Future<bool> borrarUsuario(String userId) async {
  //   try {
  //     final res = await supabase.rpc('borrar_usuario_id', params: {
  //       'user_id': userId,
  //     });
  //     usuarios.removeWhere((user) => user.id == userId);
  //     llenarPlutoGrid(usuarios);
  //     return res;
  //   } catch (e) {
  //     log('Error en borrarUsuario() - $e');
  //     return false;
  //   }
  // }

  @override
  void dispose() {
    busquedaController.dispose();
    nombreController.dispose();
    correoController.dispose();
    super.dispose();
  }
}
