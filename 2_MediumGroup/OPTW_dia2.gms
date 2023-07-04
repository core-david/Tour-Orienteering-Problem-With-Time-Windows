option optcr = 0.0001

set
i /1*7/;

Alias
(i,j,k);


Table
t(i,j)
    1   2   3   4   5   6   7
1   0   23  9   10  9   31  0   
2   23  0   19  22  21  34  23        
3   9   19  0   3   1   26  9               
4   10  22  3   0   6   25  10                            
5   9   21  1   6   0   27  9                                      
6   31  34  26  25  27  0   31   
7   0   23  9   10  9   31  0;

Variable
z;

positive variable
s(i);

binary variable
x(i,j);

*Los valores para los nodos
parameter
r(i)/
1  0
2  4.6
3  4.7
4  4.5
5  4.7
6  3.9
7  0
/;


*tiempos de apertura
Parameter
O(i)/
1   0
2   360
3   0
4   600
5   600
6   420
7   0
/;

*tiempos que queremos pasar por lugar
Parameter
y(i)/
1   0
2   60
3   120
4   120
5   90
6   60
7   0
/;


*tiempos de cierre
Parameter
C(i)/
1   0
2   1200
3   1440
4   1260
5   1080
6   1020
7   1440
/;

*Precio zona arqueologica
Parameter
P(i)/
1   0 
2   100
3   600
4   200
5   100
6   100
7   0
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
r2.. sum(i$(ord(i) < card(i)), x(i,'7')) =E= 1;

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

                                      