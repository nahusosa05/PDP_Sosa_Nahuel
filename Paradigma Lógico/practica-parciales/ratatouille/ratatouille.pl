% viveEn(Rata, Restaurante).
viveEn(remy, gusteaus).
viveEn(emile, chezMilleBar).
viveEn(django, pizzeriaJeSuis).

% sabeCocinar(Nombre, Plato, Experiencia(1-10) )

% Linguini sabe cocinar ratatouille (tiene una experiencia de 3) y también sabe cocinar sopa con una experiencia de 5.
sabeCocinar(linguini, ratatouille, 3).
sabeCocinar(linguini, sopa, 5).

% Colette sabe cocinar salmón asado con una experiencia de 9.
sabeCocinar(collete, salmonAsado, 9).

% Horst sabe cocinar ensalada rusa con una experiencia de 8.
sabeCocinar(horst, ensaladaRusa, 8).

% trabajaEn(Persona, Restaurante).
trabajaEn(linguini, gusteaus).
trabajaEn(collete, gusteaus).
trabajaEn(horst, gusteaus).
trabajaEn(skinner, gusteaus).
trabajaEn(amelie, cafeDes2Moulins).

/*
    ==================================
                PUNTO 1
    ==================================
    Saber [si un plato está en el menú de un restaurante], que es cuando alguno de los empleados lo sabe cocinar.
*/

hayPlatoEnMenu(Plato, Restaurante) :-
    sabeCocinar(Persona, Plato, _),
    trabajaEn(Persona, Restaurante).

/*
    ==================================
                PUNTO 2
    ==================================
    Saber quién cocina bien un determinado plato, que es verdadero para una persona si su experiencia preparando 
    ese plato es mayor a 7, ó si tiene un tutor que cocina bien el plato. 
    Nos contaron que Linguini tiene como tutor a toda rata que viva en el lugar donde trabaja, además que Amelie 
    es la tutora de Skinner. También se sabe que remy cocina bien cualquier plato que exista, y el resto de las ratas 
    no cocina bien nada.
*/

% Caso 1: Una persona cocina bien si tiene experiencia > 7
cocinaBien(Cocinero, Plato) :-
    sabeCocinar(Cocinero, Plato, Experiencia),
    Experiencia > 7.

% Caso 2: Cocina bien si su tutor cocina bien ese plato.
cocinaBien(Cocinero, Plato) :-
    tutor(Cocinero, Tutor),
    cocinaBien(Tutor, Plato).

% Caso 3: Remy cocina bien cualquier plato que exista.
cocinaBien(remy, Plato) :-
    sabeCocinar(_, Plato, _).

% Tutores
tutor(linguini, Rata) :-
    trabajaEn(linguini, Lugar),
    viveEn(Rata, Lugar).
tutor(skinner, amelie).

/*
    ==================================
                PUNTO 3
    ==================================
    Saber si alguien es chef de un restó. Los chefs son, de los que trabajan en el restó, 
    aquellos que cocinan bien todos los platos del menú ó entre todos los platos que sabe 
    cocinar suma una experiencia de al menos 20.
*/

/* 
    esChef(Cocinero, Resto) :-
        trabajaEn(Cocinero, Resto),
        forall(hayPlatoEnMenu(Plato,Resto), cocinaBien(Cocinero, Plato)).

    esChef(Cocinero, Resto) :-
        trabajaEn(Cocinero, Resto),
        experienciaTotal(Cocinero, Total),
        Total >= 20.
*/

esChef(Cocinero, Resto) :-
    trabajaEn(Cocinero, Resto),
    condicionChef(Cocinero, Resto).

% Caso 1: trabajan en el restó cocinan bien todos los platos del menú"
condicionChef(Cocinero, Resto) :-
    forall(hayPlatoEnMenu(Plato,Resto), cocinaBien(Cocinero, Plato)).

% Caso 2: "Trabajan en el restó y entre todos los platos que sabe cocinar suma una experiencia de al menos 20"
condicionChef(Cocinero, _) :-
    experienciaTotal(Cocinero, Total),
    Total >= 20.

experienciaTotal(Cocinero, Total) :-
    /*
        [findall(1, 2, 3)]
        1. Busco La experiencia de cada plato.
        2. ¿Con qué criterio busco? Con que sepa cocinarlo.
        3. Lista donde guardo las experiencias.
    */
    findall(Experiencia, sabeCocinar(Cocinero, _, Experiencia), ListaExperiencias ),

    % Sumo la lista de números y se guardan en Total.
    sum_list(ListaExperiencias, Total).
    
/*
    ==================================
                PUNTO 4
    ==================================
    Deducir cuál es la persona encargada de cocinar un plato en un restaurante, que es 
    quien más experiencia tiene preparándolo en ese lugar. 
    Nota: si sos la única persona que cocina el plato, sos el encargado, dado que tenés más 
    experiencia cocinando el plato que las demás personas. 
 
    Después de pasar un rato en la cocina, conseguimos un poco más de información sobre los 
    platos! También aprendimos la importancia y la información que se necesita para cada tipo de 
    plato. 
    En resumen todo plato se cataloga como entrada, principal o postre. De toda entrada se debe 
    aclarar la lista de ingredientes que la componen, de cada plato principal su acompañamiento 
    y el tiempo (en minutos) que demora y de cada postre las calorías que aportan. 
*/

encargadoDe(Cocinero, Plato, Resto) :-
    experienciaCocinero(Cocinero, Plato, Resto, Exp),
    forall(experienciaCocinero(_, Plato, Resto, OtraExp), Exp >= OtraExp).

experienciaCocinero(Cocinero, Plato, Resto, Exp) :-
    trabajaEn(Cocinero, Resto),
    sabeCocinar(Cocinero, Plato, Exp).

/*
    ==================================
                PUNTO 5
    ==================================
     Si un plato es saludable (si tiene menos de 75 calorías). 
        ●  En las entradas, cada ingrediente suma 15 calorías. 
        ●  Los platos principales suman 5 calorías por cada minuto de cocción. Las guarniciones 
           agregan a la cuenta total: las papas fritas 50 y el puré 20, mientras que la ensalada no 
           aporta calorías. 
        ●  De los postres ya conocemos su cantidad de calorías. 
*/

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])). 
plato(bifeDeChorizo, principal(pure, 20)). 
plato(frutillasConCrema, postre(265)). 

esSaludable(NombrePlato) :-
    plato(NombrePlato, TipoPlato),
    calorias(TipoPlato, TotalCalorias),
    TotalCalorias < 75.

% 1. Entradas
calorias(entrada(Ingredientes), TotalCalorias) :-
    length(Ingredientes, Cantidad),
    TotalCalorias is Cantidad * 15.

% 2. Platos principales
calorias(principal(Guarnicion, Minutos), TotalCalorias) :-
    caloriasGuarnicion(Guarnicion, CaloriasGuarnicion),
    TotalCalorias is (Minutos * 5) + CaloriasGuarnicion.

% 3. Postres
calorias(postre(Calorias), Calorias).

caloriasGuarnicion(pure, 20).
caloriasGuarnicion(papasFritas, 50).
caloriasGuarnicion(ensalada, 0).

/*
    En este punto se vió los temas de Pattern Matching, Functores y Poliformismo ya que a cada plato se le 
    da su especial trato. Si mañana traen otro tipo de plato, solo hay que agregar cómo se calculan las calorías 
    del nuevo plato.
*/

/*
    ==================================
                PUNTO 6
    ==================================
    Un restaurante recibe mayor reputación si un crítico le escribe una reseña positiva. 
    Queremos saber si algún crítico le hizo una reseña positiva a algún restaurante.  
    Cada crítico maneja su propio criterio, pero todos están de acuerdo en lo mismo: el lugar 
    no debe tener ratas viviendo en él.  
        ●  Anton Ego espera, además, que en el lugar sean especialistas preparando ratatouille. 
           Un restaurante es especialista en aquellos platos que todos sus chefs saben cocinar 
           bien. 
        ●  Cormillot requiere que todos los platos que saben cocinar los empleados del 
           restaurante sean saludables. 
        ●  Martiniano es jerarquista, así que requiere que exista sólo un chef en el restaurante. 
        ●  Gordon Ramsey no le da una crítica positiva a ningún restaurante 
*/

hizoReseniaPositva(Critico, Resto) :-
    restaurante(Resto),
    not(viveEn(_, Resto)),
    criterioCritico(Critico, Resto).

restaurante(Resto) :- trabajaEn(_, Resto).

criterioCritico(antonEgo, Resto) :-
    esEspecialista(Resto, ratatoullie).

criterioCritico(cormillot, Resto) :-
    todosPlatosSaludables(Resto).

criterioCritico(martiniano, Resto) :-
    esChef(Cocinero, Resto),
    not((esChef(OtroCocinero, Resto), OtroCocinero \= Cocinero)).

esEspecialista(Resto, NombrePlato) :-
    forall(esChef(Cocinero, Resto), cocinaBien(Cocinero, NombrePlato)).

todosPlatosSaludables(Resto) :-
    forall(hayPlatoEnMenu(Plato, Resto), esSaludable(Plato)).

