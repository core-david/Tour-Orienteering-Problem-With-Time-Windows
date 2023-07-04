option optcr = 0.0001

set
i /1*11/;

Alias
(i,j,k);

Table
t(i,j)
    1   2     3   4   5     6   7   8     9   10  11
1   0   29    9   12  10    31  40  15    8   17  0
2   29  0     28  28  27    35  32  15    20  28  29  
3   9   28    0   3   3     26  36  15    11  12  9
4   12  28    3   0   5     26  38  15    11  12  12
5   10  27    3   5   0     25  36  16    10  10  10 
6   31  35    26  26  25    0   31  33    26  20  31
7   0   29    9   12  10    31  0   34    44  39  40   
8   15  15    15  15  16    33  34  0     16  25  15    
9   8   20    11  11  10    26  44  12    0   15  8
10  17  28    12  12  10    20  39  26    16  0   17
11  0   29    9   12  10    31  40  15    8   17  0;


Variable
z;

positive variable
s(i);

binary variable
x(i,j);

*Los valores para los nodos
parameter
r(i)/
1   0
2   4.7
3   4.7
4   4.7
5   4.5
6   3.9
7   4.6
8   4.6
9   4.5
10  4.3
11  0
/;


*tiempos de apertura
Parameter
O(i)/
1   0
2   540
3   0
4   0
5   600
6   420
7   600
8   0
9   540
10  600
11  0
/;

*tiempos que queremos pasar por lugar
Parameter
y(i)/
1   0
2   120
3   120
4   60
5   120
6   60
7   60
8   120
9   120
10  45
11  0
/;


*tiempos de cierre
Parameter
C(i)/
1   0
2   1020
3   1440
4   1440 
5   1260
6   1020
7   1020
8   1140
9   1020
10  1240
11  1140
/;

*Precio zona arqueologica
Parameter
P(i)/
1   0 
2   0
3   600
4   500
5   200
6   100
7   350
8   440
9   200
10  269
11  0
/;


Equations
obj
r1
r2
r3
r4
r5
r6
r7
r8
r9
r10;


obj..z=E= sum((i,j)$(ord(i) > 1 and ord(j) > 1 and ord(i) < card(i) and ord(j) <= card(j)),r(i) * x(i,j));

*Restriccion 1 -> Empieza en 1 y termina en N
r1.. sum(j$(ord(j) > 1), x('1',j)) =E=  1;
r2.. sum(i$(ord(i) < card(i)), x(i,'11')) =E= 1;

*Restriccion 2 -> Todo nodo visitado al menos una vez y conectividad
r3(k)$(ord(k) > 1 and ord(k) < card(k)).. sum(i$(ord(i) < card(i)),x(i,k)) - sum(j$(ord(j) > 1 and ord(j) <= card(j)),x(k,j)) =E= 0;
r4(k)$(ord(k) > 1 and ord(k) < card(k)).. sum(i$(ord(i) < card(i)),x(i,k)) =L= 1;
r5(k)$(ord(k) > 1 and ord(k) < card(k)).. sum(j$(ord(j) > 1 and ord(j) < card(j)),x(k,j)) =L= 1;

*Restriccion 3 
r6(i,j).. (s(i) + y(i) + t(i,j)  - s(j)) =L= 100000 * (1 - x(i,j));

*Restriccion 4 -> Limite de tiempo
r7.. sum((i,j)$(ord(i) < card(i) and ord(j) >= 1 and ord(j) <= card(j)),(t(i,j)  + y(i)) * x(i,j)) =L= 360;

*Restriccion 5 -> Restriccion apertura
r8(i).. O(i) =L= s(i);

*Restriccion 6 -> Restriccion cierre
r9(i).. s(i) =L= C(i);

*Restriccion de costo de transporte al moverse el usuario
r10.. sum((i,j)$(ord(i) < card(i) and ord(j) > 1 and ord(j) <= card(j)),t(i,j) * x(i,j) * 1.48) + sum((i,j)$(ord(i) < card(i) and ord(j) > 1 and ord(j) <= card(j)),P(i) * x(i,j))=L= 600;

 

model opwt /all/;
solve opwt using MIP max z;