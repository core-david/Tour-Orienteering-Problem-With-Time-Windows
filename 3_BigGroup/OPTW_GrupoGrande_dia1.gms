option optcr = 0.0001

set
i /1*17/;

Alias
(i,j,k);

Table
t(i,j)
    1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17
1   0   29  23  9   12  10  16  10  9   25  31  40  15  7   8   17  0
2   29  0   15  28  28  27  30  26  28  14  35  32  15  25  20  28  29 
3   23  15  0   19  21  22  23  19  21  8   34  31  5   19  14  22  23  
4   9   28  19  0   3   3   10  8   1   22  26  36  15  4   11  12  9
5   12  28  21  3   0   5   6   7   2   22  26  38  15  9   11  12  12
6   10  27  22  3   5   0   5   8   6   23  25  36  16  3   10  10  10
7   16  30  23  10  6   5   0   10  8   26  21  38  18  7   9   5   16  
8   10  26  19  8   7   8   10  0   7   27  29  39  18  4   11  12  10
9   9   28  21  1   2   6   8   7   0   21  27  37  13  9   11  12  9
10  25  14  8   22  22  23  26  27  21  0   32  28  6   19  17  24  25
11  31  35  34  26  26  25  21  29  27  32  0   31  33  23  26  20  31
12  0   29  23  9   12  10  16  10  9   25  31  0   34  43  44  39  40   
13  15  15  5   15  15  16  18  18  13  6   33  34  0   19  16  25  15    
14  7   25  19  4   9   3   7   4   9   19  23  43  17  0   10  12  7  
15  8   20  14  11  11  10  9   11  11  17  26  44  12  9   0   15  8
16  17  28  22  12  12  10  5   12  12  24  20  39  26  15  16  0   17
17  0   29  23  9   12  10  16  10  9   25  31  40  15  7   8   17  0;


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
3   4.6
4   4.7
5   4.7
6   4.5
7   4.7
8   4.7
9   4.7
10  4.7
11  3.9
12  4.6
13  4.6
14  4.6
15  4.5
16  4.3
17  0
/;


*tiempos de apertura
Parameter
O(i)/
1   0
2   540
3   360
4   0
5   0
6   600
7   540
8   600
9   600
10  600
11  420
12  600
13  0
14  540
15  540
16  600
17  0
/;

*tiempos que queremos pasar por lugar
Parameter
y(i)/
1   0
2   120
3   60
4   120
5   60
6   120
7   60
8   30
9   90
10  90
11  60
12  60
13  120
14  60
15  120
16  45
17  0
/;


*tiempos de cierre
Parameter
C(i)/
1   0
2   1020
3   1200
4   1440
5   1440 
6   1260
7   1020
8   1080
9   1080
10  1140
11  1020
12  1020
13  1140
14  1200
15  1020
16  1240
17  1140
/;

*Precio zona arqueologica
Parameter
P(i)/
1   0 
2   0
3   100
4   600
5   500
6   200
7   0
8   100
9   100
10  50
11  100
12  350
13  440
14  200  
15  200
16  269
17  0
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
r2.. sum(i$(ord(i) < card(i)), x(i,'17')) =E= 1;

*Restriccion 2 -> Todo nodo visitado al menos una vez y conectividad
r3(k)$(ord(k) > 1 and ord(k) < card(k)).. sum(i$(ord(i) < card(i)),x(i,k)) - sum(j$(ord(j) > 1 and ord(j) <= card(j)),x(k,j)) =E= 0;
r4(k)$(ord(k) > 1 and ord(k) < card(k)).. sum(i$(ord(i) < card(i)),x(i,k)) =L= 1;
r5(k)$(ord(k) > 1 and ord(k) < card(k)).. sum(j$(ord(j) > 1 and ord(j) < card(j)),x(k,j)) =L= 1;

*Restriccion 3 
r6(i,j).. (s(i) + y(i) + t(i,j)  - s(j)) =L= 100000 * (1 - x(i,j));

*Restriccion 4 -> Limite de tiempo
r7.. sum((i,j)$(ord(i) < card(i) and ord(j) >= 1 and ord(j) <= card(j)),(t(i,j)  + y(i)) * x(i,j)) =L= 480;

*Restriccion 5 -> Restriccion apertura
r8(i).. O(i) =L= s(i);

*Restriccion 6 -> Restriccion cierre
r9(i).. s(i) =L= C(i);

*Restriccion de costo de transporte al moverse el usuario
r10.. sum((i,j)$(ord(i) < card(i) and ord(j) > 1 and ord(j) <= card(j)),t(i,j) * x(i,j) * 1.48) + sum((i,j)$(ord(i) < card(i) and ord(j) > 1 and ord(j) <= card(j)),P(i) * x(i,j))=L= 800;

 

model opwt /all/;
solve opwt using MIP max z;