# Problema de Orientación con Intervalos de Tiempo (*OPTW*)

El modelo conocido como el *Problema de Orientación* (OP por sus siglas
en inglés), se basa en proponer una ruta en la cual se **maximice** la
satisfacción del usuario en su visita a los lugares propuestos por el
sistema. Estos lugares serán catalogados como **POIs** (*Points of
Interest*), los cuales cada uno de ellos tendrá una recompensa o un
puntaje cualitativo que se basará en la satisfacción de clientes pasados
obtenidos de las calificaciones de los lugares en Google Maps, el cual
varia de 0 a 5.

Sin embargo, con motivo de aproximarnos más a una situación realista, el
modelo que decidimos implementar es conocido como el **problema de
orientación con intervalos de tiempo**(OPTW) el cual considera el tiempo
que se desea pasar mínimamente en cada lugar además de los tiempos de
apertura y cierre de cada lugar (window intervals), lo cual nos aproxima
de mejor forma a una situación real.

La razón principal por la cual decidimos escoger este modelo por encima
de otros mas conocidos o utilizados en la industria-tal como el
Traveling Salesman Problem (TSP), se debe a que se aproxima más a la
situación de un turista promedio, el cual busca maximizar su experiencia
en vez de minimizar tiempos de traslado o costo.

Debido a que el cliente podría no visitar todos los lugares de interés,
ya sea por no querer sobrepasar su presupuesto o el tiempo de su
estancia en la ciudad, nos vemos obligados a agregar **restricciones**
al modelo base (OPTW), los cuales se describirán más adelante, tanto las
restricciones base como las que agregamos.

## Modelación Matemática del OPTW

En el OPTW, a cada vértice se le asigna una ventana de tiempo
$[O_i,C_i]$ y una visita a un vértice solo puede comenzar durante esta
ventana de tiempo. OPTW se puede formular como un problema entero mixto
con las siguientes variables de decisión: $x_ij = 1$ si una visita al
vértice $i$ es seguida por una visita al vértice $j – 0$ en caso
contrario; $y_i = 1$ si se visita el vértice $i – 0$ en caso contrario;
$s_i =$ el comienzo del servicio en el vértice $i$; $M$ una gran
constante.

$$\operatorname{Max} \sum_{i=2}^{N-1} \sum_{j=2}^N S_i x_{i j}$$

$$\sum_{j=2}^N x_{1 j}=\sum_{i=1}^{N-1} x_{i N}=1$$

$$\sum_{i=1}^{N-1} x_{i k}=\sum_{j=2}^N x_{k j} \leq 1 ; \quad \forall k=2, \ldots, N-1,$$

$$s_i+t_{i j}-s_j \leq M\left(1-x_{i j}\right) ; \quad \forall i, j=1, \ldots, N$$

$$\sum_{i=1}^{N-1} \sum_{j=2}^N t_{i j} x_{i j} \leq T_{\max },$$

$$O_i \leq s_i ; \quad \forall i=1, \ldots, N,$$

$$s_i \leq C_i ; \quad \forall i=1, \ldots, N,$$

$$x_{i j} \in\{0,1\} ; \quad \forall i, j=1, \ldots, N .$$

La función objetivo (7) maximiza la puntuación total recopilada. Las
restricciones (8) garantizan que el camino comienza en el vértice 1 y
termina en el vértice N. Las restricciones (9) determinan la
conectividad y aseguran que cada vértice se visita como máximo una vez.
Las restricciones (10) aseguran la línea de tiempo de la ruta y la
restricción (11) limita el presupuesto de tiempo. Las restricciones (12)
y (13) restringen el inicio del servicio al tiempo ventana. La ventana
de tiempo del vértice final N puede reemplazar la restricción\[18\].

# Adaptación del modelo matemático al contexto del problema

Para ver los resultados y capacidades de nuestro modelo adaptado al
problema introducido anteriormente, estableceremos un numero caso
hipotético de un cliente. Imaginemos que un turista de la ciudad de
México quiere realizar un viaje de **dos días a la ciudad de Puebla**,
donde se hospedará en el Hotel Gilfer, ubicado en el centro de la
ciudad. También sabemos previamente que tiene un presupuesto para gastar
de **\$800** y **\$600** por día, respectivamente. También supondremos
que el cliente no quiere estar todo el día conociendo la ciudad, por lo
que estableceremos un tiempo máximo de 8 horas para el primer día y de 6
para el segundo.

## Función objetivo

$$\operatorname{Max} \sum_{i=2}^{N-1} \sum_{j=2}^N S_i x_{i j}$$

La función objetivo se mantiene igual a la formulación base del OPTW.

Lo que está haciendo esta función es multiplicar el puntaje obtenido de
las calificaciones del lugar en google maps por 1 o 0 dependiendo si se
visita el lugar o no, esto lo hace por cada vértice($x_{i,j}$) en
nuestro grafo.

## Conjuntos

Los conjuntos se utilizan para representar y manejar la información
sobre los nodos que son parte del problema, permitiendo su uso en
ecuaciones, variables y parámetros del modelo. Adicionalmente, se
utilizan alias para el conjunto $i$, en este caso $j$ y $k$, que
permiten una manipulación más flexible de las variables y parámetros en
las ecuaciones. Los alias pueden ser usados en situaciones donde
necesitamos referirnos a los mismos elementos del conjunto original en
contextos diferentes, como por ejemplo, al definir rutas de un lugar a
otro en un problema de optimización de ruta. De esta manera, el conjunto
original y sus alias permiten una representación más completa y eficaz
de las relaciones y restricciones en el modelo de optimización.

En nuestro problema utilizamos el siguiente conjunto $i = 1... 12$, ya
que son 10 lugares posibles a visitar, el hotel o lugar donde nos
estamos hospedando mas un vértice dummy. El vértice dummy lo agregamos
debido a que el modelo base nos arroja una ruta del vértice 1 al vértice
N, pero nosotros queremos que regrese al vértice 1, es decir, que cierre
la ruta. Para lograr lo anterior mencionado agregamos un vértice dummy,
esto quiere decir que es un vértice que no existe, pero nos sirve para
que el vértice N tenga los valores del vértice 1, así cuando uno llegue
al vértice N, es como si hubiera llegado al vértice 1.

## Parámetros

Denominamos parámetros a los valores que conocemos antes de resolver el
problema, para nuestro caso particular, vamos a ocupar conocer los
valores de la recompensa de cada lugar; los tiempos de apertura y cierre
de los establecimientos; el tiempo mínimo transcurrido que el cliente
quiera estar en el lugar y el costo de visitarlo. Estamos manejando la
unidad de minutos cuando estamos hablando de tiempo y de pesos mexicanos
cuando hablamos del costo.

<div class="center">

<div id="tab:internacionales NR 2022">

|            **Lugar**            | **Recompensa** | **Apertura** | **Cierre** | **Estancia** | **Costo** |
|:-------------------------------:|:--------------:|:------------:|:----------:|:------------:|:---------:|
|              Hotel              |       0        |      0       |     0      |      0       |     0     |
|       San Andrés Cholula        |      4.7       |     540      |    1020    |     120      |     0     |
|         Jardín de Arte          |      4.6       |     360      |    1200    |      60      |    80     |
|        Zócalo de Puebla         |      4.7       |      0       |    1440    |     120      |    50     |
|      Callejón de los Sapos      |      4.7       |      0       |    1440    |      60      |    300    |
| Mercado de Artesanías El Parian |      4.5       |     600      |    1260    |     120      |    20     |
|  Zona Histórica de los Fuertes  |      4.7       |     540      |    1020    |      60      |     0     |
|       Capilla del Rosario       |      4.7       |     600      |    1080    |      30      |    35     |
|          Museo Amparo           |      4.7       |     600      |    1080    |      90      |    80     |
| Museo Internacional del Barroco |      4.7       |     600      |    1140    |      90      |    25     |
|  Parque Del Cerro de Amalucan   |      3.9       |     420      |    1020    |      60      |    50     |
|          Vértice Dummy          |       0        |      0       |    1440    |      0       |     0     |

Parámetros utilizados en el modelo. Los tiempos de apertura,cierre y
estancia de lugar están dados en el sistema de 24 horas convertidos en
minutos.

</div>

</div>

La recompensa en el vértice dummy es de 0 para que no sea considerada en
nuestra función objetivo, ya que este vértice siempre sera visitado por
la formulación del modelo, pero como no existe este lugar no queremos
agregar algo a la función objetivo. Cuando un lugar tiene un valor de 0
en la columna de apertura, representa que se puede visitar a cualquier
hora del día, en el caso de la columna de cierre, el vértice dummy tiene
un valor de 1440 que en horas son 24, lo que indica que esta abierto
todo el día, en el caso del hotel este valor no importa porque como
siempre vamos a partir de el, y el modelo dice que siempre vamos a
llegar al vértice N, entonces el valor que toma el vértice N (vértice
dummy) representa el valor del hotel, es decir que podemos llegar a
cualquier hora al hotel. En la columna de estancia y costo, tanto la
variable dummy como el hotel toman valores de 0, en el caso de la
variable como no existe no tiene sentido asignar un costo ni un tiempo
de estancia.

<div class="center">

<div id="tab:internacionales NR 2022">

| **Lugar** | **1** | **2** | **3** | **4** | **5** | **6** | **7** | **8** | **9** | **10** | **11** | **12** |
|:---------:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:------:|:------:|:------:|
|     1     |   0   |  29   |  23   |   9   |  12   |  10   |  16   |  10   |   9   |   25   |   31   |   0    |
|     2     |  29   |   0   |  15   |  28   |  28   |  27   |  30   |  26   |  28   |   14   |   35   |   29   |
|     3     |  23   |  15   |   0   |  19   |  21   |  22   |  23   |  19   |  21   |   8    |   34   |   23   |
|     4     |   9   |  28   |  19   |   0   |   3   |   3   |  10   |   8   |   1   |   22   |   26   |   9    |
|     5     |  12   |  28   |  21   |   3   |   0   |   5   |   6   |   7   |   2   |   22   |   26   |   12   |
|     6     |  10   |  27   |  22   |   3   |   5   |   0   |   5   |   8   |   6   |   23   |   25   |   10   |
|     7     |  16   |  30   |  23   |  10   |   6   |   5   |   0   |  10   |   8   |   26   |   21   |   16   |
|     8     |  10   |  26   |  19   |   8   |   7   |   8   |  10   |   0   |   7   |   27   |   29   |   10   |
|     9     |   9   |  28   |  21   |   1   |   2   |   6   |   8   |   7   |   0   |   21   |   27   |   9    |
|    10     |  25   |  14   |   8   |  22   |  22   |  23   |  26   |  27   |  21   |   0    |   32   |   25   |
|    11     |  31   |  35   |  34   |  26   |  26   |  25   |  21   |  29   |  27   |   32   |   0    |   31   |
|    12     |   0   |  29   |  23   |   9   |  12   |  10   |  16   |  10   |   9   |   25   |   31   |   0;   |

Tabla de costo de tiempo entre los lugares escogidos en minutos

</div>

</div>

Esta tabla muestra el tiempo en minutos de traslado entre los distintos
lugares que seleccionamos. Es importante notar que el vértice dummy (en
este caso el 12) tiene los mismos valores que el vértice uno, esto es
para lograr que cuando se llegue de cualquier vértice al vértice dummy
sea lo mismo de llegar de cualquier vértice al vértice 1. Efectivamente
cerrando la ruta.

## Variables

Para implementar correctamente el modelo utilizamos dos variables,
primero utilizamos una variable de tipo binaria. Esta variable va a
resultar en 1 si se va visitar del nodo i al nodo j o en 0 si no se va a
visitar del nodo i al nodo j. $$x_{(i,j)}$$

La otra variable a usar será de tipo continua positiva. La variable s(i)
se usara para registrar y determinar el horario exacto en el que se
visitara el lugar, el cual sera restringido por los horarios de apertura
y cierre de dicho establecimiento.

$$s(i)$$

## Restricciones

1\) $$\sum_{j=2}^N x_{1 j}=\sum_{i=1}^{N-1} x_{i N}=1$$ La primera
restricción del modelo garantiza que se empiece en el vértice 1 y
termine en el vértice N. Esta restricción se mantuvo igual que en el
modelo base, aunque con una modificación al número de elementos totales,
esto es porque el modelo asegura que se va a acabar en el vértice N,
pero nosotros queremos acabar en el vértice 1, por lo que se agrega un
vértice dummy, esto se elaboro en la sección de conjuntos.

2\)
$$\sum_{i=1}^{N-1} x_{i k}=\sum_{j=2}^N x_{k j} \leq 1 ; \quad \forall k=2, \ldots, N-1,$$
Esta restricción asegura la conectividad de los vértices así como que
solo se visiten una sola vez. No hicimos ninguna modificación a esta
restricción.

3\)
$$s_i+t_{i j}+ y_i-s_j \leq M\left(1-x_{i j}\right) ; \quad \forall i, j=1, \ldots, N$$
Esta restricción asegura la cronología del camino. Tuvimos que agregar
un parámetro $y_i$ para considerar el tiempo de estancia mínimo que se
desea pasar por lugar.

4\) $$\sum_{i=1}^{N-1} \sum_{j=2}^N t_{i j} x_{i j} \leq T_{\max },$$
Esta restricción asegura que se cumpla con la restricción del
presupuesto del tiempo. No hicimos ninguna modificación a esta
restricción.

5\) $$O_i \leq s_i ; \quad \forall i=1, \ldots, N,$$ Esta restricción
asegura que la hora en que se llega a un lugar sea mayor o igual a la
hora que abre el lugar, no se puede llegar a un lugar si todavía no esta
abierto. No hicimos ninguna modificación a esta restricción.

6\) $$s_i \leq C_i ; \quad \forall i=1, \ldots, N,$$ Esta restricción
asegura que la hora en que se llega a un lugar sea menor o igual a la
hora que cierra el lugar. No hicimos ninguna modificación a esta
restricción.

7\) $$x_{i, j} \in\{0,1\} ; \quad \forall i, j=1, \ldots, N .$$ Esta
restricción nos dice que la variable $x_{i,j}$ es una variable binaria,
solo puede tomar los valores 0(no se visita) o 1 (se visita) del nodo
$i$ al nodo $j$. $i$ y $j$ toman del 1 hasta el número total de
vértices.

8\)
$$\sum_{i=1}^{N-1} \sum_{j=2}^N t_{i,j} x_{i j} * 1.48 + \sum_{i=1}^{N-1} \sum_{j=2}^N P_{i} x_{i j} \leq \textit{Presupuesto Total}$$
Esta restricción la añadimos para considerar el presupuesto total de la
persona. Dentro de la restricción estamos considerando el costo del
transporte, esto es asumiendo que la persona llego al lugar turístico
con un coche sedan, el cual se calcula multiplicando el tiempo de
transporte por una constate ’C’ que obtuvimos mediante una relación, mas
adelante se explica a detalle como se obtuvo, y por ultimo se multiplica
por la variable $x_{i,j}$, es decir, si se visito o no, si no se visita
un lugar la variable es 0, por lo que toda la multiplicación será 0.
Además de considerar el costo de visitar cada lugar, esto se hace en la
segunda parte de la suma, en donde se multiplica el costo de visitar el
lugar por la variable $x_{i,j}$, es decir si se visito o no el lugar.

Para llegar a la constante ’C’, empezamos tomando las medidas de tiempo
entre la distancia más larga y el tiempo que toma para llegar ahí, a
partir de esto hacemos una regla de 3 para encontrar cuantos kilómetros
se recorrerían en 60 minutos, terminaron siendo 59km. Después mediante
una búsqueda de internet encontramos que aproximadamente un carro sedan
gasta en promedio 7 litros de gasolina por cada 100 kilómetros. Volvemos
a hacer una regla de 3 para encontrar cuantos litros se gastan en 59km
los cuales acabaron siendo 3.92 litros. Al tener la cantidad de litros
gastados por 60 minutos hacemos una última regla de 3 para encontrar
cuantos litros se gastan por minuto, nos dio el resultado de 0.0653
litros. Después de otra búsqueda encontramos que el precio de la
gasolina por litro es de 22.65 pesos y multiplicando estos últimos dos
valores llegamos a la conclusión que la constante de pesos por minuto es
de 1.48, por lo cual se multiplica este valor al tiempo de transporte
entre nodos.




















