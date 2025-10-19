// apps/mobile/lib/spotify_service.dart
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyService {
  // --- DEBES REEMPLAZAR ESTOS VALORES ---
  static const String _clientId = "TU_CLIENT_ID_DE_SPOTIFY";
  static const String _redirectUrl = "https://razviral.app/callback";
  // NOTA: Debes añadir esta Redirect URI en la configuración de tu app en el dashboard de Spotify.

  // Conexión y Autenticación
  Future<bool> connect() async {
    try {
      // --- OBSERVABILIDAD INTRÍNSECA ---
      print('[SpotifyService]: Intentando conectar a Spotify...');
      final bool result = await SpotifySdk.connectToSpotifyRemote(
        clientId: _clientId,
        redirectUrl: _redirectUrl,
      );
      print('[SpotifyService]: Conexion exitosa: $result');
      return result;
    } on PlatformException catch (e) {
      print('[SpotifyService]: ERROR de Plataforma al conectar: ${e.message}');
      return false;
    }
  }

  // Reproducir una canción
  Future<void> play(String spotifyUri) async {
    try {
      // --- OBSERVABILIDAD INTRÍNSECA ---
      print('[SpotifyService]: Solicitando reproduccion para URI: $spotifyUri');
      await SpotifySdk.play(spotifyUri: spotifyUri);
      print('[SpotifyService]: Comando de reproduccion enviado.');
    } on PlatformException catch (e) {
      print('[SpotifyService]: ERROR de Plataforma al reproducir: ${e.message}');
    }
  }

  // Obtener token de autenticación (para futuras llamadas a la API)
  Future<String?> getAuthenticationToken() async {
    try {
      final token = await SpotifySdk.getAuthenticationToken();
      print('[SpotifyService]: Token de autenticacion obtenido.');
      return token;
    } on PlatformException catch (e) {
      print('[SpotifyService]: ERROR al obtener token: ${e.message}');
      return null;
    }
  }
}
