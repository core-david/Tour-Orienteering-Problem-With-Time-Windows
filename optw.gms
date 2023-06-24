option optcr = 0.0001

* Here the size of the set represents the number of nodes of our graph or in this
* particular case it represents the places available to visit.
set
i /1*12/;

Alias
(i,j,k);


* Table with the time it takes to go from one place to other, the table is symmetrical,
* meaning that we consider that the time it takes from A to B is the same as if we go from B to A.
* The last node is a dummy one.
Table
t(i,j)
    1   2   3   4   5   6   7   8   9   10  11  12
1   0   29  23  9   12  10  16  10  9   25  31  0
2   29  0   15  28  28  27  30  26  28  14  35  29
3   23  15  0   19  21  22  23  19  21  8   34  23
4   9   28  19  0   3   3   10  8   1   22  26  9
5   12  28  21  3   0   5   6   7   2   22  26  12
6   10  27  22  3   5   0   5   8   6   23  25  10
7   16  30  23  10  6   5   0   10  8   26  21  16
8   10  26  19  8   7   8   10  0   7   27  29  10
9   9   28  21  1   2   6   8   7   0   21  27  9
10  25  14  8   22  22  23  26  27  21  0   32  25
11  31  35  34  26  26  25  21  29  27  32  0   31
12  0   29  23  9   12  10  16  10  9   25  31  0; 

* This is the variable we want to maximize.
Variable
z;

* This variable is used to register and determine the hour we visit a node.
positive variable
s(i);

* x_ij = 1 if a visit to vertex 'i' is followed by a visit to vertex j,
* x_ij = 0 otherwise
binary variable
x(i,j);

* The score of each of the nodes.
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
12  0
/;


* Opening Time
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
12  0
/;

* Minimun Time we want to spend at each node
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
12  0
/;


* Closing time
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
12  1440
/;

* Cost in mexican pesos to visit each place
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
12  0
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

* The function to maximize, it sums all the scores of the places visited. 
obj..z=E= sum((i,j)$(ord(i) > 1 and ord(j) > 1 and ord(i) < card(i) and ord(j) <= card(j)),r(i) * x(i,j));

* Restriction 1 -> Starts at node 1 and ends at node N, in this case the N node is a dummy node representing the first node
* converting from an OPTW to a tour OPTW.
r1.. sum(j$(ord(j) > 1), x('1',j)) =E=  1;
r2.. sum(i$(ord(i) < card(i)), x(i,'12')) =E= 1;

* Restriction 2 -> Every node is visited at least one and it ensures connectivity between all nodes.
r3(k)$(ord(k) > 1 and ord(k) < card(k)).. sum(i$(ord(i) < card(i)),x(i,k)) - sum(j$(ord(j) > 1 and ord(j) <= card(j)),x(k,j)) =E= 0;
r4(k)$(ord(k) > 1 and ord(k) < card(k)).. sum(i$(ord(i) < card(i)),x(i,k)) =L= 1;
r5(k)$(ord(k) > 1 and ord(k) < card(k)).. sum(j$(ord(j) > 1 and ord(j) < card(j)),x(k,j)) =L= 1;

* Restriction 3 -> ensures the chronology of the path. We had to add a yi parameter to consider the minimum stay time that you want to spend per place.
r6(i,j).. (s(i) + y(i) + t(i,j)  - s(j)) =L= 100000 * (1 - x(i,j));

* Restriccion 4 -> Time limit
r7.. sum((i,j)$(ord(i) < card(i) and ord(j) >= 1 and ord(j) <= card(j)),(t(i,j)  + y(i)) * x(i,j)) =L= 480;

* Restriccion 5 -> Opening restriction
r8(i).. O(i) =L= s(i);

* Restriccion 6 -> Closing restriction
r9(i).. s(i) =L= C(i);

* New Restriction -> Money budget = cost per place + cost of transport to each place
r10.. sum((i,j)$(ord(i) < card(i) and ord(j) > 1 and ord(j) <= card(j)),t(i,j) * x(i,j) * 1.48) + sum((i,j)$(ord(i) < card(i) and ord(j) > 1 and ord(j) <= card(j)),P(i) * x(i,j))=L= 800;

 

model opwt /all/;
solve opwt using MIP max z;