cmake_minimum_required(VERSION 3.10.2)

# Nombre de la librería que usaremos en Flutter
add_library(rentas_cpp SHARED
        rentas_estructuras.cpp
)

# Incluye las cabeceras (.h)
include_directories(.)