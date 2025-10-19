# libs/core-engine/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project(core_engine CXX)

# Creamos una librería compartida a partir de todos nuestros archivos fuente.
# Esto es escalable.
add_library(core_engine SHARED
    src/main.cpp
    src/project.cpp
)
