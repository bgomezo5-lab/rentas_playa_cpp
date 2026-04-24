cmake_minimum_required(VERSION 3.10.2)

# Nombre de la librería que crearemos
project(rentas_estructuras VERSION 1.0.0 LANGUAGES CXX)

# Añade el archivo fuente de C++ (asegúrate de crear este .cpp luego)
add_library(rentas_estructuras SHARED
        rentas_estructuras.cpp
)

# Establece las propiedades de la librería
set_target_properties(rentas_estructuras PROPERTIES
        PUBLIC_HEADER rentas_estructuras.h
)