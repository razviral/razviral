#!/bin/bash

# --- SCRIPT DE INSTALACIÓN SOBERANO PARA FLUTTER EN VERCEL ---

# 1. Definir el directorio de instalación y la versión de Flutter
FLUTTER_DIR=".flutter-sdk"
FLUTTER_CHANNEL="stable"

# 2. Si la carpeta de Flutter no existe, la clona desde GitHub.
#    Usamos --depth 1 para una descarga mucho más rápida, ideal para CI.
if [ ! -d "$FLUTTER_DIR" ]
then
  echo "--- Clonando Flutter SDK ($FLUTTER_CHANNEL)... ---"
  git clone https://github.com/flutter/flutter.git --depth 1 --branch $FLUTTER_CHANNEL $FLUTTER_DIR
else
  echo "--- Flutter SDK ya existe. Saltando clonación. ---"
fi

# 3. Añade el ejecutable de Flutter al PATH del entorno de compilación actual.
#    Esto es CRUCIAL para que el comando 'flutter' sea encontrado.
export PATH="$PATH":"$PWD/$FLUTTER_DIR/bin"

# 4. Descarga las herramientas de desarrollo de Dart y otros binarios.
echo "--- Ejecutando 'flutter doctor'... ---"
flutter doctor

echo "--- Entorno de Flutter listo. ---"
