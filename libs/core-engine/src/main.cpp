// libs/core-engine/src/main.cpp
#include "librazviral_api.h"
#include <stdio.h>

// Función de prueba del Hito 1
extern "C" API_EXPORT void hello_from_cpp() {
    // --- OBSERVABILIDAD INTRÍNSECA ---
    printf("[core-engine]: Se ha invocado la funcion 'hello_from_cpp'.\n");
    printf("[core-engine]: Esta es una prueba exitosa del puente FFI.\n");
    fflush(stdout); // CORRECCIÓN: Usamos las funciones del namespace global.
}
