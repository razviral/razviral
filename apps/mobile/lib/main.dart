// apps/mobile/lib/main.dart
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'core_engine_bridge.dart';

void main() {
  final coreEngine = CoreEngineBridge();

  // --- PRUEBA DEL HITO 1 ---
  coreEngine.sayHello();

  // --- PRUEBA DEL HITO 2 ---
  print("\n--- INICIANDO PRUEBA DEL HITO 2: GESTION DE MEMORIA ---");
  Pointer<RazviralProject> projectHandle = coreEngine.createProject();
  print("[main.dart]: Se recibio el handle del proyecto: ${projectHandle.address}");

  // Simulamos hacer trabajo con el proyecto
  print("[main.dart]: ...trabajando con el proyecto...");

  // Liberamos la memoria
  coreEngine.freeProject(projectHandle);
  print("--- PRUEBA DEL HITO 2 COMPLETADA ---\n");


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Razviral',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Razviral - Hito 2'),
        ),
        body: const Center(
          child: Text(
            'Prueba de alocación/liberación completada. Revisa la consola.',
          ),
        ),
      ),
    );
  }
}
