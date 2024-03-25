import 'dart:convert';
import 'dart:developer';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/notificaciones/notificacion_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificacionesProvider extends ChangeNotifier {
  int notificacionesSinLeerCount = 0;

  List<Notificacion> notificacionesNoLeidas = [];
  //List<Notificacion> notificacionesLeidas = [];

  int numTodasNoLeidas = 0;
  int numFacturasNoLeidas = 0;
  int numNCNoLeidas = 0;
  int numPagosNoLeidas = 0;
  int numCancelacionesNoLeidas = 0;

  int numTodasLeidas = 0;
  int numFacturasLeidas = 0;
  int numNCLeidas = 0;
  int numPagosLeidas = 0;
  int numCancelacionesLeidas = 0;

  final myChannel = supabase.channel('notificaciones');

  NotificacionesProvider() {
    suscribirNotificaciones();
  }

  void suscribirNotificaciones() {
    myChannel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: 'notificaciones',
        filter: 'to=eq.${currentUser!.email}',
      ),
      (payload, [ref]) async {
        await updateState();
      },
    ).subscribe();
    log('Realtime de Notificaciones: Encendido');
  }

  Future<void> updateState() async {
    await getNotificaciones();
  }

  Future<void> getNotificaciones() async {
    final String? userEmail = supabase.auth.currentUser?.email;
    if (userEmail == null) return;

    try {
      final response = await supabase.from('notificaciones').select().eq('to', userEmail).order('fecha_recepcion', ascending: false);

      notificacionesNoLeidas = (response as List<dynamic>).map((cliente) => Notificacion.fromJson(jsonEncode(cliente))).toList();

      notifyListeners();
    } catch (e) {
      log('Error en getNotificaciones() $e');
    }
  }
}
