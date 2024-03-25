import 'dart:convert';
import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/models.dart';

class SupabaseQueries {
  static Future<Usuario?> getCurrentUserData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final PostgrestFilterBuilder query = supabase.from('users').select().eq('perfil_usuario_id', user.id);

      final res = await query;

      final userProfile = res[0];
      userProfile['id'] = user.id;
      userProfile['email'] = user.email!;

      final usuario = Usuario.fromJson(jsonEncode(userProfile));

      return usuario;
    } catch (e) {
      log('Error en getCurrentUserData() - $e');
      return null;
    }
  }

  static Future<void> getSociedades() async {
    try {
      if (currentUser?.cliente != null) {
        final sociedades = await supabase.rpc("sociedades_cliente", params: {"clienteid": currentUser!.cliente!.clienteId});
        listaSociedades = (sociedades as List<dynamic>).map((sociedad) => Sociedad.fromJson(jsonEncode(sociedad))).toList();
        if (listaSociedades!.length >= 2) {
          listaSociedades!.insert(0, Sociedad(clave: "Todas", sociedadId: 0, nombre: "Todas"));
        }
      } else {
        final sociedades = await supabase.from("sociedad").select();
        listaSociedades = (sociedades as List<dynamic>).map((sociedad) => Sociedad.fromJson(jsonEncode(sociedad))).toList();
        listaSociedades!.insert(0, Sociedad(clave: "Todas", sociedadId: 0, nombre: "Todas"));
      }

      currentUser!.sociedadSeleccionada = listaSociedades!.first;
    } catch (e) {
      log('Error en getSociedades() - $e');
    }
  }

  static Future<Configuration?> getDefaultTheme(int themeId) async {
    try {
      final res = await supabase.from('theme').select('light, dark').eq('id', themeId);

      return Configuration.fromJson(jsonEncode(res[0]));
    } catch (e) {
      log('Error en getDefaultTheme() - $e');
      return null;
    }
  }

  static Future<Configuration?> getUserTheme() async {
    try {
      if (currentUser == null) return null;
      final res = await supabase.from('perfil_usuario').select('configuracion').eq('perfil_usuario_id', currentUser!.id);
      return Configuration.fromJson(jsonEncode(res[0]['configuracion']));
    } catch (e) {
      log('Error en getUserTheme() - $e');
      return null;
    }
  }

  static Future<bool> tokenChangePassword(String id, String newPassword) async {
    try {
      final res = await supabase.rpc('token_change_password', params: {
        'user_id': id,
        'new_password': newPassword,
      });

      if (res['data'] == true) {
        return true;
      }
    } catch (e) {
      log('Error en tokenChangePassword() - $e');
    }
    return false;
  }

  static Future<bool> saveToken(
    String userId,
    String tokenType,
    String token,
  ) async {
    try {
      await supabase.from('token').upsert({'user_id': userId, tokenType: token});
      return true;
    } catch (e) {
      log('Error en saveToken() - $e');
    }
    return false;
  }
}
