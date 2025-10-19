// apps/mobile/lib/core_engine_bridge.dart
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart'; // CORRECCIÓN: Importar para tener acceso a malloc.

// --- DEFINICIONES NATIVAS ---

// 1. Representación del struct opaco.
// CORRECCIÓN: Se añade la palabra clave 'final' para cumplir con los requisitos de 'Opaque'.
final class RazviralProject extends Opaque {}

// 2. Firmas de las funciones en C
typedef HelloWorldFunc = Void Function();
typedef ProjectAllocFunc = Pointer<RazviralProject> Function();
typedef ProjectFreeFunc = Void Function(Pointer<Pointer<RazviralProject>>);

// 3. Firmas de las funciones en Dart
typedef HelloWorld = void Function();
typedef ProjectAlloc = Pointer<RazviralProject> Function();
typedef ProjectFree = void Function(Pointer<Pointer<RazviralProject>>);

// --- CLASE DEL PUENTE ---

class CoreEngineBridge {
  static const String _libName = 'core_engine';
  late final DynamicLibrary _dylib;

  // Funciones enlazadas
  late final HelloWorld _helloFromCpp;
  late final ProjectAlloc _projectAlloc;
  late final ProjectFree _projectFree;

  CoreEngineBridge() {
    print('[FFI Bridge]: Inicializando...');
    _dylib = Platform.isAndroid
        ? DynamicLibrary.open('lib$_libName.so')
        : DynamicLibrary.open('$_libName.dll');
    print('[FFI Bridge]: Libreria nativa cargada.');

    // Enlazar funciones
    _helloFromCpp = _dylib.lookup<NativeFunction<HelloWorldFunc>>('hello_from_cpp').asFunction();
    _projectAlloc = _dylib.lookup<NativeFunction<ProjectAllocFunc>>('razviral_project_alloc').asFunction();
    _projectFree = _dylib.lookup<NativeFunction<ProjectFreeFunc>>('razviral_project_free').asFunction();
    print('[FFI Bridge]: Todas las funciones han sido enlazadas. Puente listo.');
  }

  // --- API PÚBLICA EN DART ---

  void sayHello() {
    print('[FFI Bridge]: Invocando a hello_from_cpp()...');
    _helloFromCpp();
  }

  Pointer<RazviralProject> createProject() {
    print('[FFI Bridge]: Solicitando alocacion de nuevo proyecto...');
    return _projectAlloc();
  }

  void freeProject(Pointer<RazviralProject> project) {
    print('[FFI Bridge]: Solicitando liberacion de proyecto...');
    // Para pasar un puntero a un puntero, necesitamos un intermediario en la memoria.
    // Usamos 'calloc' que es una alternativa segura que también inicializa la memoria.
    final Pointer<Pointer<RazviralProject>> projectPtr = calloc<Pointer<RazviralProject>>();
    projectPtr.value = project;
    _projectFree(projectPtr);
    calloc.free(projectPtr); // Liberamos el puntero intermediario.
  }
}
