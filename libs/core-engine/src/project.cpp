// libs/core-engine/src/project.cpp
#include "librazviral_api.h"
#include <vector> // Usaremos vectores para almacenar los clips en el futuro

// --- Definición Soberana del Aparato de Proyecto ---
// Esta es la implementación interna que el código Dart nunca verá.
struct RazviralProject {
    int version = 1;
    // En el futuro, aquí guardaremos la lista de imágenes, la ruta del audio, etc.
    // std::vector<std::string> media_clips;
    // std::string audio_path;
};

// --- Implementación de la API Pública ---

extern "C" API_EXPORT RazviralProject* razviral_project_alloc() {
    // --- OBSERVABILIDAD INTRÍNSECA ---
    printf("[core-engine::project]: Invocado razviral_project_alloc().\n");
    RazviralProject* project = new RazviralProject();
    printf("[core-engine::project]: Se ha alocado un nuevo proyecto en la memoria en la direccion: %p\n", (void*)project);
    fflush(stdout);
    return project;
}

extern "C" API_EXPORT void razviral_project_free(RazviralProject** project) {
    // --- OBSERVABILIDAD INTRÍNSECA ---
    printf("[core-engine::project]: Invocado razviral_project_free().\n");
    if (project && *project) {
        printf("[core-engine::project]: Liberando memoria para el proyecto en la direccion: %p\n", (void*)*project);
        delete *project;
        *project = nullptr;
        printf("[core-engine::project]: Memoria liberada exitosamente.\n");
    } else {
        printf("[core-engine::project]: Se intento liberar un proyecto nulo.\n");
    }
    fflush(stdout);
}
