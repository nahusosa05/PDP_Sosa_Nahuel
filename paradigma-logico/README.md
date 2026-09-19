# Paradigma Lógico (Prolog)

En este apartado se encuentran los archivos correspondientes al segundo paradigma de la cursada. Utilizamos **SWI-Prolog** para la carga de bases de conocimiento, resolución por unificación y consultas interactivas.

- **Lenguaje:** Prolog

## Comandos Útiles

- Iniciar intérprete interactivo cargando un archivo: `swipl -s <archivo.pl>`
- Recargar el archivo actual dentro de la consola: `make.`
- Salir de la consola de Prolog: `halt.`

---

## Contenido de los Archivos

### 📖 Clases Teóricas y Conceptos

Archivos teóricos con axiomas, predicados y reglas desarrollados en clase:

- **[01_introduccion_logico.pl](./Teoría/01_introduccion_logico.pl)** : Hechos, reglas, variables, principio de universo cerrado y consultas individuales/existenciales.
- **[02_inversibilidad_forall.pl](./Teoría/02_inversibilidad_forall.pl)** : Inversibilidad de predicados, ligación de variables, negación por falla (`not/1`) y cuantificación universal (`forall/2`).
- **[03_individuos_compuestos.pl](./Teoría/03_individuos_compuestos.pl)** : Modelado con functores (individuos compuestos) y polimorfismo lógico.
- **[04_recursividad_y_EC.pl](./Teoría/04_recursividad_y_EC.pl)** : Predicados recursivos sobre relaciones directas/indirectas, caso base y listas.

### 📝 Práctica y Parciales

Resolución de ejercicios tipo parcial con sus enunciados correspondientes en `/practica-parciales`:

- **[bondis](./practica-parciales/bondis/bondis.pl)** : Modelado de recorridos, líneas de transporte y combinaciones de viaje.
- **[mudanza](./practica-parciales/mudanza/mundaza.pl)** : Asignación de cargas, capacidad de vehículos y restricciones lógicas.
- **[ratatouille](./practica-parciales/ratatouille/ratatouille.pl)** : Relaciones culinarias, platos, categorías y validación de habilidades de chefs.
- **[sueldos](./practica-parciales/sueldos/sueldos.pl)** : Cálculo de remuneraciones, horas trabajadas, bonos y correcciones de modelado.
- **[sueños](./practica-parciales/sueños/sueños.pl)** : Ambiciones de personajes, tipos de dificultad y condiciones de cumplimiento.
- **[turf](./practica-parciales/turf/turf.pl)** : Caballos, jockeys, apuestas y resultados de carreras.
- **[vacaciones](./practica-parciales/vacaciones/vacaciones.pl)** : Destinos turísticos, atracciones, tours y preferencias de viajeros.