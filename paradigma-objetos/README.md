# Paradigma Orientado a Objetos (Wollok)

En este apartado se encuentran los archivos correspondientes al tercer paradigma de la cursada. Utilizamos **Wollok-TS CLI**, la extensión de **Wollok** para VS Code y el intérprete interactivo **REPL** para pruebas y ejecución.

- **Lenguaje:** Wollok

## Comandos Útiles

- Iniciar consola interactiva: `wollok repl <archivo.wlk>`
- Correr tests automatizados: `wollok test`

---

## Contenido de los Archivos

### 📖 Clases Teóricas y Conceptos

Archivos con definiciones, modelado y conceptos vistos durante las clases:

- **[01_objetos_mensajes_y_estado.wlk](./clase-uno/afecciones/afecciones.wlk)** : Introducción a objetos, atributos (`var` y `const`), métodos de acción vs. consulta y autorreferencia con `self`.
- **[02_polimorfismo_y_delegacion.wlk](./clase-uno/tom-y-jerry/tomYJerry.wlk)** : Delegación de responsabilidades y polimorfismo entre objetos independientes.


### 🧪 Práctica y Tests

Resolución de ejercicios propuestos en clase junto a sus respectivas suites de pruebas automatizadas:

- **[01_test_lobo_yamilo.wtest](./clase-uno/lobo-yamilo/testLoboYamilo.wtest)** : Pruebas iniciales de envío de mensajes, acumulación de estado y assertions booleanas.
- **[02_test_tom_y_jerry.wtest](./clase-uno/tom-y-jerry/testTomYJerry.wtest)** : Tests de interacción polimórfica y cálculo de distancias entre múltiples objetos.
