import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:acp_web/functions/phone_format.dart';
import 'package:acp_web/helpers/constants.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/helpers/supabase/queries.dart';
import 'package:acp_web/models/models.dart';
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
  TextEditingController apellidosController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  bool activo = true;

  List<Pais> paises = [];
  List<Rol> roles = [];
  List<Sociedad> sociedades = [];
  List<Usuario> usuarios = [];

  Pais? paisSeleccionado;
  Rol? rolSeleccionado;
  Sociedad? sociedadSeleccionada;

  //EDITAR USUARIOS
  Usuario? usuarioEditado;

  //PANTALLA USUARIOS
  final busquedaController = TextEditingController();
  String orden = "usuario_id_secuencial";

  Future<void> updateState() async {
    busquedaController.clear();
    await getRoles(notify: false);
    await getPaises(notify: false);
    // await getSociedades(notify: false);
    await getUsuarios();
  }

  void clearControllers({bool clearEmail = true, bool notify = true}) {
    nombreController.clear();
    if (clearEmail) correoController.clear();
    apellidosController.clear();
    telefonoController.clear();

    paisSeleccionado = null;
    rolSeleccionado = null;
    sociedadSeleccionada = null;

    if (notify) notifyListeners();
  }

  void setPaisSeleccionado(String pais) async {
    paisSeleccionado = paises.firstWhere((element) => element.nombre == pais);
    sociedades = paisSeleccionado!.sociedades;
    sociedadSeleccionada = null;
    notifyListeners();
  }

  void setRolSeleccionado(String rol) async {
    rolSeleccionado = roles.firstWhere((element) => element.nombre == rol);
    notifyListeners();
  }

  void setSociedad(String sociedad) {
    sociedadSeleccionada = sociedades.firstWhere((element) => element.nombre == sociedad);
    notifyListeners();
  }

  Future<void> getPaises({bool notify = true}) async {
    if (paises.isNotEmpty) return;
    final res = await supabase.rpc('get_paises').order(
          'nombre',
          ascending: true,
        );

    paises = (res as List<dynamic>).map((pais) => Pais.fromJson(jsonEncode(pais))).toList();

    if (notify) notifyListeners();
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

  // Future<void> getSociedades({bool notify = true, bool refresh = false}) async {
  //   if (sociedades.isNotEmpty && !refresh) return;
  //   final res = await supabase
  //       .from('sociedades')
  //       .select()
  //       .eq('pais_fk', currentUser!.pais.idPaisPk)
  //       .order('sociedad');

  //   sociedades = (res as List<dynamic>)
  //       .map((sociedad) => Sociedad.fromJson(jsonEncode(sociedad)))
  //       .toList();

  //   if (notify) notifyListeners();
  // }

  Future<void> getUsuarios() async {
    try {
      final query = supabase.from('users').select();

      final res = await query.like('nombre', '%${busquedaController.text}%').order(orden, ascending: true);

      if (res == null) {
        log('Error en getUsuarios()');
        return;
      }

      usuarios = (res as List<dynamic>).map((usuario) => Usuario.fromJson(jsonEncode(usuario))).toList();

      rows.clear();
      for (Usuario usuario in usuarios) {
        rows.add(
          PlutoRow(
            cells: {
              'usuario_id_secuencial': PlutoCell(value: usuario.idSecuencial),
              'nombre': PlutoCell(value: usuario.nombre),
              'apellido': PlutoCell(value: usuario.apellidos),
              'telefono': PlutoCell(value: formatPhone(usuario.telefono)),
              'rol': PlutoCell(value: usuario.rol.nombre),
              'compania': PlutoCell(value: usuario.rol.nombre),
              'email': PlutoCell(value: usuario.email),
              'sociedad': PlutoCell(value: usuario.sociedad.nombre),
              'pais': PlutoCell(value: usuario.pais.nombre),
              'activo': PlutoCell(value: usuario.estatus),
              'acciones': PlutoCell(value: usuario.id),
            },
          ),
        );
      }
      if (stateManager != null) stateManager!.notifyListeners();
    } catch (e) {
      log('Error en getUsuarios() - $e');
    }

    notifyListeners();
  }

  // Future<void> selectImage() async {
  //   final ImagePicker picker = ImagePicker();

  //   final XFile? pickedImage = await picker.pickImage(
  //     source: ImageSource.gallery,
  //   );

  //   if (pickedImage == null) return;

  //   final String fileExtension = p.extension(pickedImage.name);
  //   const uuid = Uuid();
  //   final String fileName = uuid.v1();
  //   imageName = 'avatar-$fileName$fileExtension';

  //   webImage = await pickedImage.readAsBytes();

  //   notifyListeners();
  // }

  // void clearImage() {
  //   webImage = null;
  //   imageName = null;
  //   notifyListeners();
  // }

  // Future<String?> uploadImage() async {
  //   if (webImage != null && imageName != null) {
  //     await supabase.storage.from('avatars').uploadBinary(
  //           imageName!,
  //           webImage!,
  //           fileOptions: const FileOptions(
  //             cacheControl: '3600',
  //             upsert: false,
  //           ),
  //         );

  //     return imageName;
  //   }
  //   return null;
  // }

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
    if (rolSeleccionado == null || paisSeleccionado == null || sociedadSeleccionada == null) {
      return false;
    }
    try {
      await supabase.from('perfil_usuario').insert(
        {
          'perfil_usuario_id': userId,
          'nombre': nombreController.text,
          'apellidos': apellidosController.text,
          'telefono': telefonoController.text,
          'pais_fk': paisSeleccionado!.paisId,
          'rol_fk': rolSeleccionado!.rolId,
          'sociedad_fk': sociedadSeleccionada!.sociedadId,
          'compania_fk': 1,
          'activo': activo,
        },
      );
      return true;
    } catch (e) {
      log('Error en crearPerfilDeUsuario() - $e');
      return false;
    }
  }

  // Future<bool> editarPerfilDeUsuario(String userId) async {
  //   try {
  //     await supabase.from('perfil_usuario').update(
  //       {
  //         'nombre': nombreController.text,
  //         'apellidos': apellidosController.text,
  //         'id_proveedor_fk': proveedorId,
  //         'responsable_fk': responsableId,
  //         'cuentas': cuentasDropValue,
  //         'telefono': telefonoController.text,
  //         'ext': extController.text,
  //         'imagen': imageName,
  //         'rol_fk': rolSeleccionado!.idRolPk,
  //         'pais_fk': paisSeleccionado!.idPaisPk,
  //       },
  //     ).eq('perfil_usuario_id', userId);
  //     return true;
  //   } catch (e) {
  //     log('Error en editarPerfilUsuario() - $e');
  //     return false;
  //   }
  // }

  // void buscarPais() {
  //   final tempPais =
  //       paises.firstWhere((element) => element == paisSeleccionado);
  //   paisSeleccionado = tempPais;
  //   if (paisSeleccionado == null) return;
  //   if (paisSeleccionado!.sociedades == null) return;
  //   sociedades = paisSeleccionado!.sociedades!;
  // }

  Future<void> initEditarUsuario(Usuario usuario) async {
    usuarioEditado = usuario;
    nombreController.text = usuario.nombre;
    apellidosController.text = usuario.apellidos;
    correoController.text = usuario.email;
    telefonoController.text = usuario.telefono;
    paisSeleccionado = usuario.pais;
    rolSeleccionado = usuario.rol;
    sociedadSeleccionada = usuario.sociedad;
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

  @override
  void dispose() {
    busquedaController.dispose();
    nombreController.dispose();
    correoController.dispose();
    apellidosController.dispose();
    telefonoController.dispose();
    super.dispose();
  }
}
