// .docs/000-blueprint-razviral.md
# 🚀 Project Blueprint: razviral

| Versión | Estado      | Última Actualización | Propietario      |
| :------ | :---------- | :------------------- | :--------------- |
| v0.6    | En Progreso | 19 de octubre de 2025  | RaZ WriTe        |

## 1. Visión del Proyecto y Propuesta de Valor

**El Problema:** La creación de contenido de video corto para redes sociales es un motor clave para la viralización de música, pero las herramientas existentes son complejas o ineficientes en dispositivos de gama baja.

**Nuestra Solución (razviral):** Una aplicación móvil nativa de **rendimiento excepcional y simplicidad radical**, diseñada con un único propósito: permitir a los usuarios crear videos musicales cortos y atractivos a partir de sus fotos y clips en menos de 30 segundos, utilizando exclusivamente el catálogo musical de **RaZ WriTe**.

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

#### 3.3. Core Engine (Procesamiento de Video): `librazviral` (C++ & FFmpeg)
*   **Decisión:** Toda la lógica de manipulación de video se encapsulará en una librería nativa escrita en **C++17**, utilizando **FFmpeg**.
*   **Justificación:** El renderizado de video es una tarea intensiva. C++ nos da el control de bajo nivel necesario, y **FFmpeg es el estándar de facto de la industria**.

### 3.4. Servicio de Catálogo Musical (Propiedad de RaZ WriTe)
*   **Decisión:** La biblioteca de música será gestionada a través de un servicio de catálogo centralizado. Para el MVP, será un archivo `catalog.json` alojado en un repositorio público de GitHub.
*   **Justificación:**
    *   **Control Total:** Al ser propietario de la música (RaZ WriTe), eliminamos los problemas de licenciamiento.
    *   **Arquitectura Simplificada:** La aplicación podrá descargar los archivos de audio y el `core-engine` los incrustará directamente en el video.
    *   **Agilidad:** Actualizar las canciones es tan simple como modificar el `catalog.json`.


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


---
INICIO DE IDEA

para los usuarios de picativos de redes sociales les es dificil manejar los aplicativos como tik tok, facebook, instagram para hacer videos con musica y postearlos en redes sociales e incluo compartirlos via whatsapp o en viarlos como email. debemos crear un aplicativo para celilares de alto performance y suma simplicidad que permita a los usarios escoger de 1 a 6 fotografías o videod o ambas y desde una bibnlioteca de xanciones definida por nosotros, que tomara la canciones desde spotify o desde la biblioteca de musicas de tik tok o de meta o de x, escigiendo las fotos o videos desde si celular se creará el video facilmente que pasara las fotos con algunos efectos, e incluso textos y laspublicara tanto en histries como en el perfil. nuestro foco es hacer vitales las canciones registradas en spotify para ue tengan mas usos. ahora buscaras en los repositorios proyectos similares de los cuales analizaremos y extraeremos las funcionalidades, estructuras y stack tecnologico y lo optimizaremos. de la misma forma analizaremos aplicativos como tik tok lite, intagram, whatsapp, facebook lite y x para ver la correcta forma de integrarlos. lo primero que harenos sera crear un documenyo en la carpeta .docs de nuestro proyecto definiendolo, estilo blueprint vivo que iremos puliendo. hahora tae a contextos aplicativos con sus url para que comencemos a analizarlos y diseccionarlos. busca desde donde podemos bajar el codigo fuente de aplcativosantes mencionados

1. Proyectos Open-Source para Edición de Video e Integración
He buscado en repositorios como GitHub para encontrar proyectos que nos permitan entender la base tecnológica para crear videos a partir de imágenes y audio.
FFmpeg (https://ffmpeg.org/): Este es el estándar de oro. No es una aplicación en sí, sino un framework multimedia extremadamente potente y de código abierto. Es capaz de decodificar, codificar, transcodificar, multiplexar, demultiplexar, transmitir, filtrar y reproducir prácticamente cualquier cosa que los humanos y las máquinas hayan creado en formato de audio y video. La mayoría de las aplicaciones de edición de video, incluidas las de gigantes como YouTube y TikTok, utilizan FFmpeg bajo el capó para el procesamiento de medios. Analizar su documentación y librerías "wrapper" para móviles (existen para Android e iOS) será fundamental para nuestra funcionalidad central de creación de videos.
Shotcut (https://github.com/mltframework/shotcut): Es un editor de video de código abierto y multiplataforma. Aunque es una aplicación de escritorio, su código fuente puede ser una referencia valiosa para entender cómo se gestiona una línea de tiempo, se aplican filtros y transiciones, y se renderiza el video final. Está construido sobre el MLT Multimedia Framework, que también es de código abierto.
VLC (https://github.com/videolan/vlc): Si bien es conocido como un reproductor multimedia, la biblioteca subyacente de VLC, libVLC, es increíblemente poderosa y puede ser integrada en otras aplicaciones para manejar medios. Su base de código es un excelente ejemplo de manejo de una amplia variedad de códecs y formatos de manera eficiente en plataformas móviles.

---

APARATO 1: Blueprint Estratégico Actualizado
code
Markdown
// .docs/000-blueprint-razviral.md
*Sección 3.3, 3.4 y 5 actualizadas para reflejar el uso del catálogo musical de RaZ WriTe.*

---

### 3.3. Core Engine (Procesamiento de Video): `librazviral` (C++ & FFmpeg)

*   **Decisión:** Toda la lógica de manipulación de video se encapsulará en una librería nativa escrita en **C++17**, utilizando **FFmpeg**.
*   **Justificación:** El renderizado de video es una tarea intensiva. C++ nos da el control de bajo nivel necesario para optimizar cada ciclo de CPU, y **FFmpeg es el estándar de facto de la industria**.

### 3.4. Servicio de Catálogo Musical (Propiedad de RaZ WriTe)

*   **Decisión:** La biblioteca de música será gestionada a través de un servicio de catálogo centralizado. Para el MVP, este servicio será un archivo `catalog.json` alojado en un repositorio público de GitHub.
*   **Justificación:**
    *   **Control Total:** Al ser propietario de la música (RaZ WriTe), eliminamos los problemas de licenciamiento.
    *   **Arquitectura Simplificada:** La aplicación podrá descargar los archivos de audio (`.mp3`) y el `core-engine` los incrustará directamente en el video renderizado.
    *   **Agilidad:** Actualizar las canciones disponibles es tan simple como modificar el `catalog.json`.

---
## 5. Riesgos y Desafíos Identificados

⚖️ **~~Licenciamiento de Música~~ (RESUELTO):**
*   **Resolución:** El proyecto utilizará exclusivamente el catálogo musical del propietario (RaZ WriTe), convirtiendo el mayor riesgo en una ventaja estratégica.

⚙️ **Rendimiento en Dispositivos de Gama Baja:**
*   **Mitigación:** Optimización meticulosa en C++, uso de codificación por hardware y pruebas exhaustivas.

🧩 **Complejidad de la Interfaz Nativa (FFI):**
*   **Mitigación:** Mantener una API en C simple y cubrirla con pruebas unitarias robustas.

---

// .docs/000-blueprint-razviral.md (Revisión v0.7)

## 1. Visión del Proyecto y Propuesta de Valor

**El Problema:** Los fans de la música y los creadores de contenido quieren usar las canciones de sus artistas favoritos en sus videos para redes sociales, pero el proceso puede tener fricción. Para un artista como **RaZ WriTe**, lograr que su música sea seleccionada y se viralice en plataformas como TikTok e Instagram es un desafío constante.

**Nuestra Solución (razviral):** Una aplicación móvil nativa que actúa como un **acelerador de viralización musical**. Su único propósito es eliminar todas las barreras para que un usuario pueda crear un video atractivo con una canción de **RaZ WriTe** (obtenida directamente de **Spotify** o bibliotecas de sonidos de redes sociales) y compartirlo en segundos.

**Propuesta de Valor Única (UVP):**
*   **Creación Instantánea:** Un flujo optimizado para crear un video con fotos/clips, música, efectos y texto en menos de 30 segundos.
*   **Integración Directa con el Ecosistema Musical:** La app se conecta a Spotify para usar las canciones de RaZ WriTe, impulsando directamente sus reproducciones y su presencia en la plataforma.
*   **Optimizado para Compartir:** El video resultante está diseñado para ser compartido fácilmente en todas las plataformas de video corto (Stories, Reels, TikToks), con un llamado a la acción para que otros usen el sonido.

---

### 3.4. Integración con Plataformas Musicales (Spotify)

*   **Decisión:** El corazón de la aplicación será la integración con el SDK de Spotify. La música no se alojará de forma independiente; se utilizará la infraestructura de Spotify.
*   **Justificación:**
    *   **Impulso Directo a las Métricas:** Cada previsualización o uso de una canción a través de la app puede contribuir a las métricas de streaming de RaZ WriTe en Spotify, que es el objetivo principal del negocio.
    *   **Fuente Única de Verdad:** Se utiliza siempre la versión oficial de la canción, con su carátula y metadatos correctos, directamente desde el catálogo de Spotify.
    *   **Experiencia de Usuario Familiar:** Los usuarios interactúan con un catálogo que ya conocen y confían.

---

## 5. Riesgos y Desafíos Identificados

⚖️ **Limitación del SDK de Spotify (CRÍTICO):**
*   **Desafío:** Los SDKs de Spotify están diseñados para **hacer streaming (reproducir) audio, no para descargarlo**. No es técnicamente posible (ni legalmente permitido por sus Términos de Servicio) tomar el audio de Spotify, guardarlo como un archivo .mp3 y "fusionarlo" (muxing) en un archivo de video final.
*   **Mitigación Estratégica:** Debemos cambiar el flujo de la aplicación.
    1.  El usuario selecciona sus fotos/videos.
    2.  El usuario **autentica su cuenta de Spotify** dentro de `razviral`.
    3.  La app muestra el catálogo de RaZ WriTe. El usuario selecciona una canción y la app la **reproduce** para la vista previa mientras edita.
    4.  **Opción A (MVP):** La app renderiza un **video SILENCIOSO** con las imágenes, animaciones y textos. Al compartirlo en TikTok o Instagram, se le instruye al usuario para que "añada el sonido" buscando la canción de RaZ WriTe directamente en la biblioteca de esa red social.
    5.  **Opción B (Avanzado):** Investigar si las APIs de compartición de TikTok/Instagram permiten "pre-seleccionar" un sonido. La app pasaría el video y un identificador de la canción para que la red social complete la unión.

⚙️ **Rendimiento en Dispositivos de Gama Baja:** (Sigue siendo válido)
*   **Mitigación:** Optimización en C++ y uso de codificación por hardware.

🧩 **Complejidad de la Interfaz Nativa (FFI):** (Sigue siendo válido)
*   **Mitigación:** Mantener una API en C simple y cubrirla con pruebas.

---

## 6. Hoja de Ruta del Desarrollo (Roadmap MVP Re-enfocado)

🎯 **Funcionalidades del MVP:**
*   **Hito 1: El Puente Funciona y Spotify Autentica.**
    *   Implementar la llamada `hello_world()` desde Flutter a C++ vía FFI.
    *   **Integrar el `spotify_sdk` en Flutter para autenticar exitosamente a un usuario con su cuenta de Spotify.**
*   **Hito 2: Lógica del Core Engine (Básica).**
    *   Implementar `razviral_project_alloc` y `razviral_project_free`.
    *   Implementar `razviral_project_add_media` para imágenes estáticas.
    *   Implementar `razviral_project_render` para crear un **video silencioso** a partir de una secuencia de imágenes.
*   **Hito 3: UI del MVP.**
    *   Pantalla de inicio con botón "Conectar con Spotify".
    *   Pantalla de selección de medios de la galería.
    *   Pantalla de selección de música que **lista las canciones de RaZ WriTe desde Spotify y las reproduce para la vista previa**.
    *   Pantalla de renderizado y compartición que guía al usuario sobre cómo añadir la música en la red social de destino.

    ---

    
