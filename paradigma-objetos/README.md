# Paradigma Orientado a Objetos (Wollok)

En este apartado se encuentran los archivos correspondientes al tercer paradigma de la cursada. Utilizamos **Wollok-TS CLI**, la extensión de **Wollok** para VS Code y el intérprete interactivo **REPL** para pruebas y ejecución.

- **Lenguaje:** Wollok

## Comandos Útiles

- Iniciar consola interactiva: `wollok repl <ruta-al-archivo.wlk>`
- Correr todos los tests automatizados: `wollok test`
- Correr un test específico: `wollok test "<nombre-del-test>"`

---

## Contenido de los Archivos

### 📖 Clases Teóricas y Conceptos

Archivos con definiciones, fundamentos y ejemplos de modelado vistos en clase:

- **[conceptos_iniciales.wlk](./teoria/01-introduccion/conceptos_iniciales.wlk)** : Fundamentos del paradigma: estado interno (`var`, `const`), identidad, métodos de acción vs. consulta, encapsulamiento, delegación y autorreferencia con `self`.
- **[polimorfismo.wlk](./teoria/02-polimorfismo/polimorfismo.wlk)** : Contratos implícitos, definición de interfaces comunes y polimorfismo entre objetos independientes.
- **[property_colecciones.wlk](./teoria/02-property-colecciones/property_colecciones.wlk)** : Uso de `property` para accesors automáticos, objetos bloque (`{ ... }`), aplicación con `apply()` y colecciones (`List`, `Set`) con mensajes declarativos (`filter`, `map`, `all`, `any`, `find`, `max`, `sum`, `fold`, `forEach`).

### 🧪 Práctica y Ejercicios

Resolución de ejercicios propuestos en clase junto a sus respectivos tests automatizados:

- **[01-afecciones](./ejercicios/01-afecciones/afecciones.wlk)** : Modelado de afecciones y medicamentos, delegación de responsabilidades y paso de `self` como parámetro en interacciones.
- **[01-lobo-yamilo](./ejercicios/01-lobo-yamilo/lobo_yamilo.wlk)** : Manejo de estado mutable, efectos de lado y consultas booleanas compuestas. Tests en **[lobo_yamilo_T.wtest](./ejercicios/01-lobo-yamilo/lobo_yamilo_T.wtest)**.
- **[01-tom-y-jerry](./ejercicios/01-tom-y-jerry/tom_y_jerry.wlk)** : Tratamiento polimórfico de presas (Jerry y Robot Ratón) y cálculo de persecuciones dinámicas. Tests en **[tom_y_jerry_T.wtest](./ejercicios/01-tom-y-jerry/tom_y_jerry_T.wtest)**.
- **[02-sueldo-pepe](./ejercicios/02-sueldo-pepe/sueldo_pepe.wlk)** : Delegación en múltiples familias de objetos polimórficos (categorías, bonos de presentismo y bonos de resultado) y diagrama de diseño en **[UML ejercicio pepe.svg](./ejercicios/02-sueldo-pepe/UML%20ejercicio%20pepe.svg)**. Tests en **[sueldo_pepe_T.wtest](./ejercicios/02-sueldo-pepe/sueldo_pepe_T.wtest)**.
- **[02-pokemon](./ejercicios/02-pokemon/pokemon.wlk)** : Manejo de conjuntos de pokemones en la pokebola de Ash y consultas sobre colecciones para estadísticas y rankings.