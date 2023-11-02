import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:acp_web/functions/phone_format.dart';
import 'package:acp_web/helpers/constants.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/helpers/supabase/queries.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/services/api_error_handler.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:path/path.dart' as p;
import 'package:random_password_generator/random_password_generator.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class UsuariosProvider extends ChangeNotifier {
  PlutoGridStateManager? stateManager;
  List<PlutoRow> rows = [];

  //ALTA USUARIO
  TextEditingController nombreController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController apellidoPaternoController = TextEditingController();
  TextEditingController apellidoMaternoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  Rol? rolSeleccionado;
  TextEditingController codigoClienteController = TextEditingController();
  bool activo = true;

  List<Rol> roles = [];
  List<Sociedad> sociedades = [];
  List<Usuario> usuarios = [];

  String? nombreImagen;
  Uint8List? webImage;

  Cliente? cliente;
  TextEditingController sociedadClienteController = TextEditingController();

  //PANTALLA USUARIOS
  final busquedaController = TextEditingController();
  String orden = "usuario_id_secuencial";

  Future<void> updateState() async {
    busquedaController.clear();
    await getRoles(notify: false);
    await getUsuarios();
  }

  void clearControllers({bool clearEmail = true, bool notify = true}) {
    nombreController.clear();
    if (clearEmail) correoController.clear();
    apellidoPaternoController.clear();
    apellidoMaternoController.clear();
    telefonoController.clear();
    rolSeleccionado = null;
    codigoClienteController.clear();
    sociedadClienteController.clear();

    nombreImagen = null;
    webImage = null;

    if (notify) notifyListeners();
  }

  void setRolSeleccionado(String rol) async {
    rolSeleccionado = roles.firstWhere((element) => element.nombre == rol);
    notifyListeners();
  }

  Future<void> getRoles({bool notify = true}) async {
    if (roles.isNotEmpty) return;
    final res = await supabase.from('rol').select('rol_id, nombre, permisos').order(
          'nombre',
          ascending: true,
        );

    roles = (res as List<dynamic>).map((rol) => Rol.fromJson(jsonEncode(rol))).toList();

    if (notify) notifyListeners();
  }

  Future<void> getCliente() async {
    if (cliente != null) {
      codigoClienteController.text = cliente!.codigoAcreedor;
      sociedadClienteController.text = cliente!.sociedad;
      return;
    }
    try {
      final res = await supabase.from('clientes').select().eq('codigo_acreedor', codigoClienteController.text);

      if (res == null) return;

      if ((res as List).length != 1) {
        cliente = null;
        sociedadClienteController.text = 'No se encontró';
      } else {
        cliente = Cliente.fromMap(res[0]);
        sociedadClienteController.text = cliente?.sociedad ?? '';
      }
    } catch (e) {
      log('Error en getCliente() - $e');
    }
  }

  Future<void> getUsuarios() async {
    try {
      final query = supabase.from('users').select();

      final res = await query.like('nombre', '%${busquedaController.text}%').order(orden, ascending: true);

      if (res == null) {
        log('Error en getUsuarios()');
        return;
      }

      usuarios = (res as List<dynamic>).map((usuario) => Usuario.fromJson(jsonEncode(usuario))).toList();

      llenarPlutoGrid(usuarios);
    } catch (e) {
      log('Error en getUsuarios() - $e');
    }

    notifyListeners();
  }

  void llenarPlutoGrid(List<Usuario> usuarios) {
    rows.clear();
    for (Usuario usuario in usuarios) {
      String? imageUrl;
      if (usuario.imagen != null) {
        imageUrl = supabase.storage.from('avatars').getPublicUrl(usuario.imagen!);
      }
      Map<String, String?> infoUsuario = {'nombre': usuario.nombreCompleto, 'imagen': imageUrl};
      rows.add(
        PlutoRow(
          cells: {
            'usuario_id_secuencial': PlutoCell(value: usuario.idSecuencial),
            'usuario': PlutoCell(value: infoUsuario),
            'telefono': PlutoCell(value: formatPhone(usuario.telefono)),
            'rol': PlutoCell(value: usuario.rol.nombre),
            'compania': PlutoCell(value: usuario.compania),
            'email': PlutoCell(value: usuario.email),
            'sociedad': PlutoCell(value: usuario.cliente?.sociedad ?? '-'),
            'activo': PlutoCell(value: usuario.estatus),
            'acciones': PlutoCell(value: usuario.id),
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

  Future<Map<String, String>?> registrarUsuario() async {
    try {
      //Generar contrasena aleatoria
      final password = generatePassword();

      //Registrar al usuario con una contraseña temporal
      var response = await http.post(
        Uri.parse('$supabaseUrl/auth/v1/signup'),
        headers: {'Content-Type': 'application/json', 'apiKey': anonKey},
        body: json.encode(
          {
            "email": correoController.text,
            "password": password,
          },
        ),
      );
      if (response.statusCode > 204) return {'Error': 'El usuario ya existe'};

      final String? userId = jsonDecode(response.body)['user']['id'];

      if (userId == null) return {'Error': 'Error al registrar al usuario'};

      final token = generateToken(userId, correoController.text);

      // final bool tokenSaved = await SupabaseQueries.saveToken(userId, 'token_ingreso', token);

      // if (!tokenSaved) return {'Error': 'Error al guardar token'};

      // final bool emailSent = await sendEmail(correoController.text, password, token, 'alta');

      // if (!emailSent) return {'Error': 'Error al mandar email'};

      //retornar el id del usuario
      return {'userId': userId};
    } catch (e) {
      log('Error en registrarUsuario() - $e');
      return {'Error': 'Error al registrar usuario'};
    }
  }

  Future<bool> crearPerfilDeUsuario(String userId) async {
    if (rolSeleccionado == null) {
      return false;
    }
    try {
      await supabase.from('perfil_usuario').insert(
        {
          'perfil_usuario_id': userId,
          'nombre': nombreController.text,
          'apellido_paterno': apellidoPaternoController.text,
          'apellido_materno': apellidoMaternoController.text,
          'telefono': telefonoController.text,
          'rol_fk': rolSeleccionado!.rolId,
          'compania': 'ACP',
          'cliente_fk': cliente?.clienteId,
          'imagen': nombreImagen,
          'activo': activo,
        },
      );
      return true;
    } catch (e) {
      log('Error en crearPerfilDeUsuario() - $e');
      return false;
    }
  }

  Future<bool> editarPerfilDeUsuario(String userId) async {
    try {
      await supabase.from('perfil_usuario').update(
        {
          'nombre': nombreController.text,
          'apellido_paterno': apellidoPaternoController.text,
          'apellido_materno': apellidoMaternoController.text,
          'telefono': telefonoController.text,
          'rol_fk': rolSeleccionado!.rolId,
          'compania': 'ACP',
          'cliente_fk': cliente?.clienteId,
          'imagen': nombreImagen,
          'activo': activo,
        },
      ).eq('perfil_usuario_id', userId);
      return true;
    } catch (e) {
      log('Error en editarPerfilUsuario() - $e');
      return false;
    }
  }

  Future<void> initEditarUsuario(Usuario usuario) async {
    nombreController.text = usuario.nombre;
    apellidoPaternoController.text = usuario.apellidoPaterno;
    apellidoMaternoController.text = usuario.apellidoMaterno ?? '';
    correoController.text = usuario.email;
    telefonoController.text = usuario.telefono;
    rolSeleccionado = usuario.rol;
    activo = usuario.activo;
    nombreImagen = usuario.imagen;
    webImage = null;
    cliente = usuario.cliente;
    if (cliente != null) {
      await getCliente();
    }
  }

  Future<bool> updateActivado(Usuario usuario, bool value, int rowIndex) async {
    try {
      //actualizar usuario
      await supabase.from('perfil_usuario').update({'activo': value}).eq('perfil_usuario_id', usuario.id);
      rows[rowIndex].cells['activo']?.value = usuario.estatus;
      if (stateManager != null) stateManager!.notifyListeners();
      return true;
    } catch (e) {
      log('Error en updateActivado() - $e');
      return false;
    }
  }

  String generatePassword() {
    //Generar contrasena aleatoria
    final passwordGenerator = RandomPasswordGenerator();
    return passwordGenerator.randomPassword(
      letters: true,
      uppercase: true,
      numbers: true,
      specialChar: true,
      passwordLength: 8,
    );
  }

  String generateToken(String userId, String email) {
    //Generar token
    final jwt = JWT(
      {
        'user_id': userId,
        'email': email,
        'created': DateTime.now().toUtc().toIso8601String(),
      },
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );

    // Sign it (default with HS256 algorithm)
    return jwt.sign(SecretKey('secret'));
  }

  Future<bool> sendEmail(String email, String? password, String token, String type) async {
    //Mandar correo
    // final response = await http.post(
    //   Uri.parse(bonitaConnectionUrl),
    //   body: json.encode(
    //     {
    //       "user": "Web",
    //       "action": "bonitaBpmCaseVariables",
    //       'process': 'Alta_de_Usuario',
    //       'data': {
    //         'variables': [
    //           {
    //             'name': 'correo',
    //             'value': email,
    //           },
    //           {
    //             'name': 'password',
    //             'value': password,
    //           },
    //           {
    //             'name': 'token',
    //             'value': token,
    //           },
    //           {
    //             'name': 'type',
    //             'value': type,
    //           },
    //         ]
    //       },
    //     },
    //   ),
    // );
    // if (response.statusCode > 204) {
    //   return false;
    // }

    return true;
  }

  // Future<bool> sendUserToken() async {
  //   final password = generatePassword();

  //   //Cambiar contrasena
  //   if (usuarioEditado == null) return false;
  //   final res =
  //       await SupabaseQueries.tokenChangePassword(usuarioEditado!.id, password);
  //   if (res == false) return res;

  //   final token = generateToken(
  //     usuarioEditado!.id,
  //     correoController.text,
  //   );

  //   // Guardar token
  //   final bool tokenSaved = await SupabaseQueries.saveToken(
  //     usuarioEditado!.id,
  //     'token_ingreso',
  //     token,
  //   );

  //   if (!tokenSaved) return tokenSaved;

  //   final bool emailSent =
  //       await sendEmail(usuarioEditado!.email, password, token, 'alta');

  //   if (!emailSent) return emailSent;

  //   return true;
  // }

  Future<bool> borrarUsuario(String userId) async {
    try {
      final res = await supabase.rpc('borrar_usuario_id', params: {
        'user_id': userId,
      });
      usuarios.removeWhere((user) => user.id == userId);
      llenarPlutoGrid(usuarios);
      return res;
    } catch (e) {
      log('Error en borrarUsuario() - $e');
      return false;
    }
  }

  @override
  void dispose() {
    busquedaController.dispose();
    nombreController.dispose();
    correoController.dispose();
    apellidoPaternoController.dispose();
    apellidoMaternoController.dispose();
    telefonoController.dispose();
    codigoClienteController.dispose();
    sociedadClienteController.dispose();
    super.dispose();
  }
}
