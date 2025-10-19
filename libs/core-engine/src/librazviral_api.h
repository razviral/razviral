// libs/core-engine/src/librazviral_api.h
#ifndef LIBRAZVIRA_API_H
#define LIBRAZVIRA_API_H

// --- OBSERVABILIDAD INTRÍNSECA ---
// En C, usaremos un simple printf para los logs, asegurando la compatibilidad.
#include <stdio.h>

// Handle opaco. El código de Flutter sabrá que existe, pero no podrá ver su contenido.
// Esto nos da la libertad de cambiar la implementación interna en C++ sin romper el código de Dart.
struct RazviralProject;
typedef struct RazviralProject RazviralProject;

// Definimos la visibilidad de la API para la librería dinámica (.dll)
#if defined(_WIN32)
    #define API_EXPORT __declspec(dllexport)
#else
    #define API_EXPORT
#endif

// Aseguramos que los nombres de las funciones no sean alterados por el compilador de C++
#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Crea un nuevo proyecto de video y devuelve un handle.
 * @return Un puntero al proyecto o NULL si falla la alocación de memoria.
 */
API_EXPORT RazviralProject* razviral_project_alloc();

/**
 * @brief Libera toda la memoria y recursos asociados a un proyecto.
 * @param project Puntero al puntero del handle del proyecto. Se establecerá a NULL tras la liberación.
 */
API_EXPORT void razviral_project_free(RazviralProject** project);

#ifdef __cplusplus
}
#endif

#endif // LIBRAZVIRA_API_H
