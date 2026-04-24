#ifndef RENTAS_ESTRUCTURAS_H
#define RENTAS_ESTRUCTURAS_H

// Definimos la estructura de la propiedad
struct Propiedad {
    int id;
    char nombre[100];
    float precioPorNoche;
};

// Definimos el Nodo (La Estructura Autorreferenciada)
struct NodoPropiedad {
    Propiedad dato;
    struct NodoPropiedad* siguiente; // El puntero que pide el profe
};

#endif