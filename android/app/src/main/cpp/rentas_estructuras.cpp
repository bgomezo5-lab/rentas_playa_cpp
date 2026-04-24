#include "rentas_estructuras.h"
#include <stdlib.h>
#include <string.h>

extern "C" {
// Función para crear un nuevo nodo en memoria dinámica
NodoPropiedad* crearNodo(int id, const char* nombre, float precio) {
    // Reservamos memoria
    NodoPropiedad* nuevo = (NodoPropiedad*)malloc(sizeof(NodoPropiedad));

    // Llenamos los datos
    nuevo->dato.id = id;
    strncpy(nuevo->dato.nombre, nombre, 99);
    nuevo->dato.precioPorNoche = precio;

    // El siguiente siempre empieza en NULL
    nuevo->siguiente = NULL;

    return nuevo;
}
}