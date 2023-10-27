import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:acp_web/helpers/globals.dart';
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
  TextEditingController extController = TextEditingController();
  TextEditingController proveedorController = TextEditingController();
  TextEditingController nombreProveedorController = TextEditingController();
  TextEditingController cuentaProveedorController = TextEditingController();

  String? cuentasDropValue = '';

  String? imageName;
  Uint8List? webImage;
  List<Pais> paises = [];
  List<Rol> roles = [];
  // List<Sociedad> sociedades = [];
  List<Usuario> usuarios = [];
  List<Usuario> usuariosTesoreros = [];

  Pais? paisSeleccionado = currentUser!.pais;
  Rol? rolSeleccionado;
  // List<Sociedad> sociedadesSeleccionadas = [];

  bool isProveedor = false;
  bool isFinanzasLocal = false;

  int? proveedorId;
  String? responsableId;

  //EDITAR USUARIOS
  Usuario? usuarioEditado;

  //PANTALLA USUARIOS
  final busquedaController = TextEditingController();
  String orden = "usuario_id_secuencial";

  // Future<void> updateState() async {
  //   busquedaController.clear();
  //   await getRoles(notify: false);
  //   await getPaises(notify: false);
  //   await getSociedades(notify: false);
  //   await getUsuarios();
  // }

  void clearControllers({bool clearEmail = true, bool notify = true}) {
    nombreController.clear();
    if (clearEmail) correoController.clear();
    apellidosController.clear();
    telefonoController.clear();
    extController.clear();
    proveedorController.clear();
    nombreProveedorController.clear();
    cuentaProveedorController.clear();

    paisSeleccionado = currentUser!.pais;
    rolSeleccionado = null;
    // sociedadesSeleccionadas.clear();
    isProveedor = false;
    isFinanzasLocal = false;

    if (notify) notifyListeners();
  }

  // Future<void> setPaisSeleccionado(String pais) async {
  //   paisSeleccionado =
  //       paises.firstWhere((element) => element.nombrePais == pais);
  //   sociedades = paisSeleccionado!.sociedades!;
  //   sociedadesSeleccionadas.clear();
  //   await getUsuariosTesoreria();
  //   notifyListeners();
  // }

  // Future<void> setRolSeleccionado(String rol) async {
  //   rolSeleccionado = roles.firstWhere((element) => element.nombreRol == rol);
  //   if (rol == 'Proveedor') {
  //     isProveedor = true;
  //   } else {
  //     isProveedor = false;
  //     proveedorId = null;
  //   }
  //   if (rol == 'Finanzas Local') {
  //     isFinanzasLocal = true;
  //     await getUsuariosTesoreria();
  //   } else {
  //     isFinanzasLocal = false;
  //     responsableId = null;
  //   }
  //   notifyListeners();
  // }

  // void setResponsable(Usuario usuario) {
  //   responsableId = usuario.id;
  //   notifyListeners();
  // }

  // void setSociedades(List<Sociedad> nuevasSociedades) {
  //   sociedadesSeleccionadas = nuevasSociedades;
  // }

  // Future<void> getPaises({bool notify = true}) async {
  //   if (paises.isNotEmpty) return;
  //   final res = await supabase.rpc('get_paises').order(
  //         'nombre_pais',
  //         ascending: true,
  //       );

  //   paises = (res as List<dynamic>)
  //       .map((pais) => Pais.fromJson(jsonEncode(pais)))
  //       .toList();

  //   if (notify) notifyListeners();
  // }

  // Future<void> getRoles({bool notify = true}) async {
  //   if (roles.isNotEmpty) return;
  //   final res = await supabase
  //       .from('roles')
  //       .select('nombre_rol, id_rol_pk, permisos')
  //       .order(
  //         'nombre_rol',
  //         ascending: true,
  //       );

  //   roles = (res as List<dynamic>)
  //       .map((rol) => RolApi.fromJson(jsonEncode(rol)))
  //       .toList();

  //   if (!currentUser!.esAdministradorGeneral) {
  //     roles.removeWhere(
  //         (element) => element.nombreRol == 'Administrador General ARUX');
  //   }

  //   if (notify) notifyListeners();
  // }

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

  // Future<void> getUsuarios() async {
  //   try {
  //     final query = supabase.from('users').select();

  //     if (!currentUser!.esAdministradorGeneral) {
  //       query.eq('pais_fk', currentUser!.pais.idPaisPk);
  //     }

  //     final res = await query
  //         .like('nombre', '%${busquedaController.text}%')
  //         .order(orden, ascending: true);

  //     if (res == null) {
  //       log('Error en getUsuarios()');
  //       return;
  //     }
  //     usuarios = (res as List<dynamic>)
  //         .map((usuario) => Usuario.fromJson(jsonEncode(usuario)))
  //         .toList();

  //     rows.clear();
  //     for (Usuario usuario in usuarios) {
  //       rows.add(
  //         PlutoRow(
  //           cells: {
  //             'usuario_id_secuencial': PlutoCell(value: usuario.idSecuencial),
  //             'nombre':
  //                 PlutoCell(value: "${usuario.nombre} ${usuario.apellidos}"),
  //             'rol': PlutoCell(value: usuario.rol.nombreRol),
  //             'email': PlutoCell(value: usuario.email),
  //             'telefono': PlutoCell(value: usuario.telefono),
  //             'pais': PlutoCell(value: usuario.pais.nombrePais),
  //             'ausencia': PlutoCell(value: usuario.id),
  //             'acciones': PlutoCell(value: usuario.id),
  //           },
  //         ),
  //       );
  //     }
  //     if (stateManager != null) stateManager!.notifyListeners();
  //   } catch (e) {
  //     log('Error en getUsuarios() - $e');
  //   }

  //   notifyListeners();
  // }

  // Future<void> getProveedor() async {
  //   final res = await supabase
  //       .from('proveedores')
  //       .select('id_proveedor_pk, nombre_fiscal, cuenta_acreedor')
  //       .eq('codigo_acreedor', proveedorController.text);

  //   if (res == null) return;

  //   if ((res as List<dynamic>).length != 1) {
  //     proveedorId = null;
  //     nombreProveedorController.text = 'No se encontró';
  //     cuentaProveedorController.text = 'No se encontró';
  //   } else {
  //     final infoProveedor = res[0];
  //     proveedorId = infoProveedor['id_proveedor_pk'];
  //     nombreProveedorController.text = infoProveedor['nombre_fiscal'];
  //     cuentaProveedorController.text = infoProveedor['cuenta_acreedor'] ?? '';
  //   }
  // }

  // Future<void> getProveedorById(int id) async {
  //   final res = await supabase
  //       .from('proveedores')
  //       .select('codigo_acreedor, nombre_fiscal, cuenta_contable')
  //       .eq('id_proveedor_pk', id);

  //   if (res == null) return;

  //   if ((res as List<dynamic>).length != 1) {
  //     return;
  //   } else {
  //     final infoProveedor = res[0];
  //     proveedorController.text = infoProveedor['codigo_acreedor'];
  //     nombreProveedorController.text = infoProveedor['nombre_fiscal'];
  //     cuentaProveedorController.text = infoProveedor['cuenta_contable'] ?? '';
  //   }
  // }

  // Future<void> getUsuariosTesoreria() async {
  //   try {
  //     if (paisSeleccionado == null) return;
  //     final res = await supabase
  //         .from('users')
  //         .select()
  //         .eq('rol_fk', 3)
  //         .eq('pais->id_pais_pk', paisSeleccionado!.idPaisPk);

  //     if (res == null) {
  //       log('Error en getUsuariosTesoreria()');
  //       return;
  //     }

  //     usuariosTesoreros = (res as List<dynamic>)
  //         .map((usuario) => Usuario.fromJson(jsonEncode(usuario)))
  //         .toList();
  //   } catch (e) {
  //     log('Error en getUsuariosTesoreria() - $e');
  //   }
  // }

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

  // Future<bool> relacionarSociedades(String userId) async {
  //   try {
  //     for (final Sociedad sociedad in sociedadesSeleccionadas) {
  //       await supabase.from('usuario_sociedad').insert(
  //         {
  //           'usuario_fk': userId,
  //           'sociedad_fk': sociedad.idSociedadPk,
  //         },
  //       );
  //     }
  //     return true;
  //   } catch (e) {
  //     log('Error en relacionarSociedades() - $e');
  //     return false;
  //   }
  // }

  // Future<bool> editarSociedadesRelacionadas() async {
  //   if (usuarioEditado == null) return false;
  //   //Se inicializan los sociedades a agregar (todas)
  //   final List<Sociedad> sociedadesAgregadas = [...sociedadesSeleccionadas];
  //   //Se inicializan los sociedades a eliminar (todas)
  //   final List<Sociedad> sociedadesEliminadas = [...usuarioEditado!.sociedades];

  //   for (var sociedad in sociedadesSeleccionadas) {
  //     //seleccionados - usuario
  //     //[a,b,c] - [d] => [a,b,c] - [d]
  //     //[a,b,c] - [a,b] => [c] - []
  //     //[a,b,c] - [a,b,d] => [c] - [d]
  //     //[d] - [a,b] => [d] - [a,b]
  //     if (usuarioEditado!.sociedades.contains(sociedad)) {
  //       //Si lo contiene, se elimina de los sociedades a agregar
  //       sociedadesAgregadas.remove(sociedad);
  //       //Si lo contiene, se elimina de los sociedades a eliminar
  //       sociedadesEliminadas.remove(sociedad);
  //     }
  //   }

  //   for (final Sociedad sociedad in sociedadesAgregadas) {
  //     await supabase.from('usuario_sociedad').insert(
  //       {
  //         'usuario_fk': usuarioEditado!.id,
  //         'sociedad_fk': sociedad.idSociedadPk,
  //       },
  //     );
  //   }

  //   for (final Sociedad sociedad in sociedadesEliminadas) {
  //     await supabase
  //         .from('usuario_sociedad')
  //         .delete()
  //         .eq('usuario_fk', usuarioEditado!.id)
  //         .eq('sociedad_fk', sociedad.idSociedadPk);
  //   }

  //   usuarioEditado!.sociedades = [...sociedadesSeleccionadas];
  //   return true;
  // }

  // Future<Map<String, String>?> registrarUsuario() async {
  //   try {
  //     //Generar contrasena aleatoria
  //     final password = generatePassword();

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

  //     final token = generateToken(userId, correoController.text);

  //     final bool tokenSaved =
  //         await SupabaseQueries.saveToken(userId, 'token_ingreso', token);

  //     if (!tokenSaved) return {'Error': 'Error al guardar token'};

  //     final bool emailSent =
  //         await sendEmail(correoController.text, password, token, 'alta');

  //     if (!emailSent) return {'Error': 'Error al mandar email'};

  //     //retornar el id del usuario
  //     return {'userId': userId};
  //   } catch (e) {
  //     log('Error en registrarUsuario() - $e');
  //     return {'Error': 'Error al registrar usuario'};
  //   }
  // }

  // Future<bool> crearPerfilDeUsuario(String userId) async {
  //   if (rolSeleccionado == null || paisSeleccionado == null) {
  //     return false;
  //   }
  //   try {
  //     await supabase.from('perfil_usuario').insert(
  //       {
  //         'perfil_usuario_id': userId,
  //         'nombre': nombreController.text,
  //         'apellidos': apellidosController.text,
  //         'id_proveedor_fk': proveedorId,
  //         'cuentas': cuentasDropValue,
  //         'telefono': telefonoController.text,
  //         'imagen': imageName,
  //         'rol_fk': rolSeleccionado!.idRolPk,
  //         'pais_fk': paisSeleccionado!.idPaisPk,
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

  // Future<void> initEditarUsuario(Usuario usuario) async {
  //   usuarioEditado = usuario;
  //   nombreController.text = usuario.nombre;
  //   apellidosController.text = usuario.apellidos;
  //   correoController.text = usuario.email;
  //   telefonoController.text = usuario.telefono;
  //   extController.text = usuario.ext ?? '';
  //   paisSeleccionado = usuario.pais;
  //   buscarPais();
  //   rolSeleccionado = usuario.rol;
  //   imageName = usuario.imagen;
  //   sociedadesSeleccionadas = usuario.sociedades;
  //   webImage = null;
  //   if (usuario.rol.nombreRol == 'Proveedor') {
  //     isProveedor = true;
  //     proveedorId = usuario.idProveedorFk;
  //     await getProveedorById(proveedorId!);
  //   } else {
  //     isProveedor = false;
  //     proveedorId = null;
  //   }
  //   if (usuario.rol.nombreRol == 'Finanzas Local') {
  //     isFinanzasLocal = true;
  //     responsableId = usuario.responsableFk;
  //     await getUsuariosTesoreria();
  //   } else {
  //     isFinanzasLocal = false;
  //     responsableId = null;
  //   }
  // }

  // Future<bool> updateAusencia(Usuario usuario, bool value) async {
  //   try {
  //     await supabase
  //         .from('perfil_usuario')
  //         .update({'ausencia': value}).eq('perfil_usuario_id', usuario.id);

  //     usuario.ausencia = value;
  //     if (stateManager != null) stateManager!.notifyListeners();
  //     return true;
  //   } catch (e) {
  //     log('Error en updateAusencia() - $e');
  //     return false;
  //   }
  // }

  // Future<String?> updateActivado(Usuario usuario, bool value) async {
  //   try {
  //     //revisar que no sea el unico usuario con ese rol
  //     if (value == false) {
  //       final res1 = await supabase.rpc('contar_rol', params: {
  //         'id_rol': usuario.rol.idRolPk,
  //         'sociedades': currentUser!.sociedades
  //             .map((sociedad) => sociedad.idSociedadPk)
  //             .toList(),
  //       });

  //       if (res1 == null) {
  //         log('Error en updateActivado() - ${res1.error}');
  //         return 'Error al actualizar usuario';
  //       }

  //       if (res1['esUnico']) {
  //         return 'El usuario es el único con ese rol en el sistema';
  //       }
  //     }

  //     //actualizar usuario
  //     await supabase
  //         .from('perfil_usuario')
  //         .update({'activado': value}).eq('perfil_usuario_id', usuario.id);

  //     usuario.activado = value;
  //     if (stateManager != null) stateManager!.notifyListeners();
  //     return null;
  //   } catch (e) {
  //     log('Error en updateActivado() - $e');
  //     return 'Error al actualizar usuario';
  //   }
  // }

  // String generatePassword() {
  //   //Generar contrasena aleatoria
  //   final passwordGenerator = RandomPasswordGenerator();
  //   return passwordGenerator.randomPassword(
  //     letters: true,
  //     uppercase: true,
  //     numbers: true,
  //     specialChar: true,
  //     passwordLength: 8,
  //   );
  // }

  // String generateToken(String userId, String email) {
  //   //Generar token
  //   final jwt = JWT(
  //     {
  //       'user_id': userId,
  //       'email': email,
  //       'created': DateTime.now().toUtc().toIso8601String(),
  //     },
  //     issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
  //   );

  //   // Sign it (default with HS256 algorithm)
  //   return jwt.sign(SecretKey('secret'));
  // }

  // Future<bool> sendEmail(
  //     String email, String? password, String token, String type) async {
  //   //Mandar correo
  //   final response = await http.post(
  //     Uri.parse(bonitaConnectionUrl),
  //     body: json.encode(
  //       {
  //         "user": "Web",
  //         "action": "bonitaBpmCaseVariables",
  //         'process': 'Alta_de_Usuario',
  //         'data': {
  //           'variables': [
  //             {
  //               'name': 'correo',
  //               'value': email,
  //             },
  //             {
  //               'name': 'password',
  //               'value': password,
  //             },
  //             {
  //               'name': 'token',
  //               'value': token,
  //             },
  //             {
  //               'name': 'type',
  //               'value': type,
  //             },
  //           ]
  //         },
  //       },
  //     ),
  //   );
  //   if (response.statusCode > 204) {
  //     return false;
  //   }

  //   return true;
  // }

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
    extController.dispose();
    proveedorController.dispose();
    nombreProveedorController.dispose();
    cuentaProveedorController.dispose();
    super.dispose();
  }
}
