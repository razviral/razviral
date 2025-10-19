# 🚀 Project Blueprint: razviral

| Versión | Estado      | Última Actualización | Propietario      |
| :------ | :---------- | :------------------- | :--------------- |
| v0.5    | En Progreso | 19 de octubre de 2025  | Arquitectura SW |

## 1. Visión del Proyecto y Propuesta de Valor

**El Problema:** La creación de contenido de video corto para redes sociales (como TikTok, Instagram Reels) es un motor clave para la viralización de música y marcas personales. Sin embargo, las herramientas existentes pueden ser complejas, estar sobrecargadas de funciones o ser poco eficientes en dispositivos de gama baja. Además, la integración y el uso de música con licencia es un proceso fragmentado y restringido a los ecosistemas de cada red social.

**Nuestra Solución (razviral):** Una aplicación móvil nativa, de **rendimiento excepcional y simplicidad radical**, diseñada con un único propósito: permitir a los usuarios crear videos musicales cortos y atractivos a partir de sus fotos y clips en menos de 30 segundos.

**Propuesta de Valor Única (UVP):**
*   **Simplicidad Extrema:** Un flujo de "seleccionar -> elegir música -> compartir" sin distracciones.
*   **Alto Rendimiento:** Una experiencia fluida y rápida incluso en dispositivos de gama media-baja, gracias a un motor de renderizado nativo.
*   **Foco en la Viralización Musical:** El objetivo principal es actuar como una plataforma de lanzamiento para que canciones (inicialmente de una biblioteca curada y licenciada) ganen tracción en todas las redes sociales simultáneamente.

---

## 2. Casos de Uso Clave (MVP)

### 👤 Persona Principal: "Carlos, el Creador Ocasional"
*   **Bio:** Un estudiante universitario o joven profesional que disfruta compartiendo momentos de su vida en redes sociales. No es un editor de video profesional, pero quiere que su contenido se vea bien. Valora la rapidez y la facilidad de uso por encima de todo.
*   **Objetivo:** Crear un video corto para sus historias de Instagram con las fotos de su último viaje y una canción que está de moda.

### ✅ Caso de Uso 1: Creación Rápida de Video Musical

*   **Precondición:** Carlos tiene entre 1 y 6 fotos o videos cortos en la galería de su teléfono.
*   **Flujo de Pasos:**
    1.  Carlos abre `razviral` y pulsa el botón "Crear Nuevo Video".
    2.  La aplicación le muestra su galería de medios. Selecciona 5 fotos.
    3.  La aplicación le presenta una biblioteca de canciones curada. Escucha y selecciona una pista.
    4.  `razviral` genera automáticamente una vista previa del video, aplicando una transición suave (ej. cross-fade) entre las fotos, sincronizada con el ritmo de la música.
    5.  (Opcional) Carlos añade un texto simple sobre el video.
    6.  Carlos pulsa "Renderizar y Compartir".
    7.  La aplicación renderiza el video en alta calidad en segundo plano, mostrando una barra de progreso.
    8.  Al finalizar, se abre la hoja de compartición nativa de su sistema operativo (iOS/Android), permitiéndole enviar el video a Instagram, TikTok, WhatsApp, etc.
*   **Resultado Exitoso:** Carlos ha publicado un video de aspecto profesional en sus redes en menos de un minuto.

---

## 3. Arquitectura y Decisiones Tecnológicas

La arquitectura de `razviral` es **híbrida y desacoplada**, diseñada para maximizar el rendimiento en el procesamiento de video y la velocidad de desarrollo en la interfaz de usuario.

### 3.1. Gestión del Workspace: Monorepo con Nx

*   **Decisión:** Utilizar un único repositorio (monorepo) gestionado con la herramienta **Nx**.
*   **Justificación:**
    *   **Heterogeneidad:** Nuestro proyecto combina tecnologías muy dispares (Flutter/Dart, C++, etc.). Nx nos permite gestionarlas bajo un mismo techo.
    *   **Caché de Computación:** La compilación de C++ es lenta. La caché de Nx acelerará drásticamente los ciclos de desarrollo y la Integración Continua (CI), evitando recompilaciones innecesarias.
    *   **Grafo de Dependencias:** Nx entiende que la `mobile-app` depende del `core-engine`, permitiendo automatizaciones inteligentes (ej: si el motor cambia, se deben ejecutar las pruebas de la app).
    *   **Consistencia:** Centraliza los scripts, la configuración de linting y las pruebas en un solo lugar.

### 3.2. Frontend (Interfaz de Usuario): Flutter

*   **Decisión:** Desarrollar la aplicación de cara al usuario con **Flutter**.
*   **Opciones Evaluadas:**
    | Criterio              | Flutter                                            | React Native                                 | Nativo (Kotlin/Swift)                        |
    | --------------------- | -------------------------------------------------- | -------------------------------------------- | -------------------------------------------- |
    | **Rendimiento UI**      | **Excelente (compila a nativo, motor Skia)**       | Bueno (puente JS)                            | Excelente                                    |
    | **Interoperabilidad Nativa** | **Excelente (dart:ffi para C/C++)**            | Bueno (Módulos Nativos)                      | N/A                                          |
    | **Velocidad Desarrollo**  | Muy Alta (base de código única, Hot Reload)        | Alta (base de código única)                  | Lenta (dos bases de código separadas)        |
    | **Ecosistema**          | Maduro y en crecimiento                            | Muy Maduro                                   | El más maduro                                |
*   **Justificación:** Flutter es la opción superior para `razviral` por su **excelente rendimiento gráfico** y, crucialmente, por su mecanismo **`dart:ffi` (Foreign Function Interface)**. Este nos permite llamar a funciones de nuestra librería nativa en C++ con una sobrecarga mínima, como si fueran funciones de Dart. Es la combinación perfecta de desarrollo rápido de UI y potencia nativa sin compromisos.

### 3.3. Core Engine (Procesamiento de Video): `librazviral` (C++ & FFmpeg)

*   **Decisión:** Toda la lógica de manipulación de video (decodificación, aplicación de efectos, renderizado) se encapsulará en una librería nativa (`.dll`, `.so`, `.dylib`) escrita en **C++17**, utilizando **FFmpeg** como su principal dependencia.
*   **Opciones Evaluadas:**
    | Criterio               | C++ y FFmpeg                                      | Librería de Video en Dart/Flutter             | Servicio en la Nube (Cloud)                  |
    | ---------------------- | ------------------------------------------------- | --------------------------------------------- | -------------------------------------------- |
    | **Rendimiento Crudo**    | **Óptimo (control total de memoria y CPU)**       | Limitado (abstracciones de Dart)              | Dependiente de la red y el costo del servidor |
    | **Capacidades**        | Ilimitadas (acceso a todo el poder de FFmpeg)     | Limitadas a lo que el paquete ofrezca        | Escalable, pero con mayor latencia          |
    | **Complejidad**        | **Alta**                                          | Baja                                          | Media (gestión de APIs, colas, etc.)         |
    | **Coste**              | 0 (código se ejecuta en el dispositivo)           | 0                                             | **Alto** (coste por minuto de renderizado)      |
*   **Justificación:** El renderizado de video es una tarea extremadamente intensiva. Ejecutarla en el dispositivo del usuario (`on-device`) elimina los costos de servidor y la latencia de red. C++ nos da el control de bajo nivel necesario para optimizar cada ciclo de CPU, y **FFmpeg es el estándar de facto de la industria**, una base probada, robusta y extremadamente potente. Esta decisión es la clave para cumplir nuestra promesa de "alto rendimiento".

---

## 4. Diseño de la API del Core Engine (`librazviral`)

La comunicación entre Flutter y el Core Engine se realizará a través de una API en C limpia y estable.

```c
/**
 * @file librazviral_api.h
 * @brief Contrato de la API pública para el motor de renderizado de razviral.
 */

// Handle opaco para gestionar un proyecto de video. El frontend nunca ve el contenido.
typedef struct RazviralProject RazviralProject;

/**
 * @brief Crea un nuevo proyecto y devuelve un handle.
 * @return Un puntero al proyecto o NULL si falla la alocación.
 */
RazviralProject* razviral_project_alloc();

/**
 * @brief Libera toda la memoria y recursos asociados a un proyecto.
 * @param project Puntero al handle del proyecto. Se establecerá a NULL tras la liberación.
 */
void razviral_project_free(RazviralProject** project);

/**
 * @brief Añade un clip de imagen o video al timeline del proyecto.
 * @param project El handle del proyecto.
 * @param file_path Ruta absoluta al archivo de imagen o video.
 * @return 0 si tiene éxito, un código de error negativo en caso contrario.
 */
int razviral_project_add_media(RazviralProject* project, const char* file_path);

/**
 * @brief Establece la pista de audio para el proyecto.
 * @param project El handle del proyecto.
 * @param audio_path Ruta absoluta al archivo de audio.
 * @return 0 si tiene éxito, un código de error negativo en caso contrario.
 */
int razviral_project_set_audio(RazviralProject* project, const char* audio_path);

/**
 * @brief Renderiza el proyecto final a un archivo de salida. Esta es una operación bloqueante.
 * @param project El handle del proyecto.
 * @param output_path Ruta absoluta donde se guardará el video renderizado (ej. MP4).
 * @param progress_callback Un puntero a una función en Dart que será llamada periódicamente
 *                          con el progreso del renderizado (0-100).
 * @return 0 si tiene éxito, un código de error negativo en caso contrario.
 */
int razviral_project_render(RazviralProject* project, const char* output_path, void (*progress_callback)(int percentage));
5. Riesgos y Desafíos Identificados
⚖️ Licenciamiento de Música (CRÍTICO/BLOQUEADOR):
Desafío: No es legal ni técnicamente trivial usar canciones de plataformas como Spotify para embeberlas en un video. Sus APIs son para streaming, no para descarga y re-codificación.
Mitigación: Para el MVP, no se integrará con Spotify. Se comenzará con una biblioteca de música libre de derechos (ej. Epidemic Sound, Artlist) con la que se pueda obtener una licencia comercial explícita para este caso de uso. La exploración de acuerdos con sellos discográficos es una tarea de negocio a largo plazo.
⚙️ Rendimiento en Dispositivos de Gama Baja:
Desafío: El renderizado de video puede agotar la batería y la memoria en teléfonos más antiguos.
Mitigación: Optimización meticulosa en el código C++. Uso de perfiles de codificación de hardware (VideoToolbox en iOS, MediaCodec en Android) cuando sea posible. Pruebas exhaustivas en un rango amplio de dispositivos físicos.
🧩 Complejidad de la Interfaz Nativa (FFI):
Desafío: La comunicación entre Dart y C++ (FFI) requiere una gestión cuidadosa de la memoria, los tipos de datos y los hilos para evitar crashes y fugas de memoria.
Mitigación: Mantener la superficie de la API en C lo más simple posible. Implementar pruebas unitarias y de integración robustas para el core-engine de forma aislada.
🔄 Dependencia de APIs de Terceros (Redes Sociales):
Desafío: La forma de compartir contenido en Instagram, TikTok, etc., puede cambiar sin previo aviso, rompiendo nuestra integración.
Mitigación: Utilizar siempre los SDKs oficiales de compartición. Para el MVP, apoyarse principalmente en la hoja de compartición nativa del sistema operativo, que es una API más estable y universal.
6. Hoja de Ruta del Desarrollo (Roadmap MVP)
El objetivo del Producto Mínimo Viable (MVP) es validar el flujo de creación principal y la propuesta de valor de rendimiento/simplicidad.
🎯 Funcionalidades del MVP:

Configuración del Workspace de Monorepo con Nx.

Esqueleto de la aplicación Flutter (apps/mobile).

Esqueleto de la librería C++ (libs/core-engine) con configuración de compilación.

Hito 1: El Puente Funciona.

Implementar una función hello_world() en C++ y llamarla exitosamente desde Flutter vía FFI.

Hito 2: Lógica del Core Engine.

Implementar razviral_project_alloc y razviral_project_free.

Implementar razviral_project_add_media para imágenes estáticas.

Implementar razviral_project_set_audio.

Implementar razviral_project_render usando FFmpeg para crear un video a partir de una secuencia de imágenes y una pista de audio.

Hito 3: UI del MVP.

Pantalla de selección de medios de la galería.

Pantalla de selección de música (de una lista local predefinida).

Pantalla de vista previa y renderizado con una barra de progreso.

Hito 4: Lanzamiento.

Integración final y pruebas end-to-end.

Preparación para despliegue en TestFlight / Google Play Beta.
❌ Fuera del Alcance del MVP:
Soporte para videos como entrada (solo imágenes inicialmente).
Efectos, filtros o transiciones complejas.
Superposición de texto o stickers.
Integración directa con APIs de redes sociales o Spotify.
Cuentas de usuario o almacenamiento en la nube.
