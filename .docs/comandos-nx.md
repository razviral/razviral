https://nx.dev/docs/reference/nx-commands

https://nx.dev/docs/guides/adopting-nx/adding-to-monorepo#_top

pnpm nx-cloud login

pnpm nx graph

npx create-nx-workspace@latest razviral

pnpm nx generate @nx/workspace:project libs/core-engine

pnpm nx generate @nx/workspace:project apps/mobile

# MANIFIESTO DE INICIALIZACIÓN DEL WORKSPACE v1.0
## Protocolo de Comandos Soberanos para el Ecosistema razviral

### **Filosofía Raíz**

Este documento es la **guía táctica y soberana** para la construcción del workspace de `razviral` desde un estado virgen. Cada comando y cada paso manual aquí descritos están diseñados para forjar la base de nuestro ecosistema híbrido, asegurando que cada módulo nazca en **perfecta armonía arquitectónica**. La ejecución de este protocolo en orden es **innegociable** para garantizar la consistencia y la estabilidad del entorno de desarrollo.

---

### **0. 📜 Prerrequisitos del Entorno de Desarrollo**

Antes de ejecutar cualquier comando, el entorno del desarrollador **DEBE** tener instaladas y configuradas las siguientes herramientas:

*   **Node.js y pnpm:** Para la gestión del workspace de Nx.
*   **SDK de Flutter:** Para la creación y compilación de la aplicación móvil.
*   **Toolchain de C++:**
    *   **CMake:** Para la gestión del sistema de compilación del `core-engine`.
    *   **Un compilador de C++:** (Ej. Build Tools for Visual Studio en Windows, GCC/Clang en Linux, Xcode Command Line Tools en macOS).

---

### **1. 🏛️ Creación del Workspace Soberano**

Este paso crea el contenedor del monorepo.

#### **Comando Soberano:**

```bash
# Ejecutar en el directorio donde residirá el proyecto
npx create-nx-workspace razviral --preset=apps --packageManager=pnpm --nxCloud=skip
Justificación: Usamos el preset apps para obtener un lienzo en blanco, perfectamente adaptado a nuestra arquitectura heterogénea. Se omite Nx Cloud para la configuración inicial local.
2. 💉 Inyección de Dependencias Esenciales
El workspace mínimo requiere herramientas adicionales para gestionar nuestros módulos no estándar.
Comando Soberano:
code
Bash
# Navegar a la raíz del nuevo workspace
cd razviral

# Instalar el plugin que contiene el ejecutor de comandos genéricos
pnpm add -D @nx/workspace
3. 🏗️ Estructuración Manual de Módulos
Aquí nos desviamos de los generadores estándar. Creamos la estructura de nuestros módulos y le enseñamos a Nx a reconocerlos explícitamente.
Protocolo de Creación:
Crear Directorios:
code
Bash
mkdir libs\core-engine
mkdir apps\mobile
Definir el core-engine para Nx:
Crear el archivo libs/core-engine/project.json con el siguiente contenido:
code
JSON
{
  "name": "core-engine",
  "$schema": "../../node_modules/nx/schemas/project-schema.json",
  "sourceRoot": "libs/core-engine/src",
  "projectType": "library",
  "targets": {
    "build": {
      "executor": "@nx/run-commands",
      "options": {
        "commands": [
          "cmake -S libs/core-engine -B libs/core-engine/build",
          "cmake --build libs/core-engine/build"
        ],
        "parallel": false
      },
      "outputs": ["{workspaceRoot}/libs/core-engine/build"]
    }
  }
}
Definir la mobile-app para Nx:
Crear el archivo apps/mobile/project.json con el siguiente contenido:
code
JSON
{
  "name": "mobile",
  "$schema": "../../node_modules/nx/schemas/project-schema.json",
  "sourceRoot": "apps/mobile/lib",
  "projectType": "application",
  "targets": {
    "build": {
      "executor": "@nx/run-commands",
      "options": {
        "cwd": "apps/mobile",
        "command": "flutter build apk --debug"
      },
      "outputs": ["{workspaceRoot}/apps/mobile/build"]
    }
  }
}
4. 🛠️ Configuración y Verificación del Workspace
Estos pasos finalizan la configuración y validan que el ecosistema esté operativo.
Protocolo de Configuración y Verificación:
Actualizar nx.json para ser Explícito: Reemplazar el contenido de nx.json en la raíz con esta configuración moderna y explícita:
code
JSON
{
  "$schema": "./node_modules/nx/schemas/nx-schema.json",
  "defaultBase": "main",
  "tasksRunnerOptions": {
    "default": {
      "runner": "nx/tasks-runners/default",
      "options": {
        "cacheableOperations": ["build"]
      }
    }
  },
  "plugins": [
    {
      "plugin": "@nx/workspace/plugin",
      "options": {}
    }
  ]
}
Inicializar el core-engine (C++):
Crear libs/core-engine/CMakeLists.txt.
Crear libs/core-engine/src/main.cpp (usando las plantillas de nuestro blueprint).
Inicializar la App Móvil (Flutter):
code
Bash
# Ejecutar desde la raíz del workspace
cd apps/mobile
flutter create . --project-name=razviral_mobile
cd ../..
Verificación Soberana del Workspace:
code
Bash
# 1. Visualizar el grafo de dependencias. Deberían aparecer 'core-engine' y 'mobile'.
pnpm nx graph

# 2. Compilar el motor nativo por primera vez.
pnpm nx run core-engine:build

# 3. Re-compilar y verificar la caché de Nx. Debería ser instantáneo.
pnpm nx run core-engine:build

---


