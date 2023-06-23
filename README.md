This project arises from the interest to plan the best possible experience of a tourist visiting a new city given a budget and daily time limit. 

The mathematical modeling is an adaptation of the one presented in the paper "The orienteering proble: A survey" 

Link to the article: https://www.sciencedirect.com/science/article/abs/pii/S0377221710002973

# Tour Orienteering Problem with Time Windows (TOPTW)

The model known as the **Orienteering Problem (OP)**, is based on proposing a route that **maximizes** the User satisfaction in their visit to the places proposed by the system. These places will be cataloged as **POIs (Points of Interest)**, each of which will have a reward or a qualitative score that will be based on the satisfaction of past customers obtained from the qualifications of the places in Google Maps, which ranges from 0 to 5.

However, in order to get closer to a realistic situation, the model that we decided to implement is known as the **problem of orientation with time intervals (OPTW)** which considers the time that you want to spend minimally in each place in addition to the times of opening and closing of each place (window intervals), which brings us closer to in a better way to a real situation.

# Mathematical modeling of the TOPTW

## Función objetivo

$${Max} \sum_{i=2}^{N-1} \sum_{j=2}^N S_i x_{i j}$$


What this function is doing is multiplying the score obtained from the qualifications of the place in google maps by 1 or 0 depending on whether it is visit the place or not, it does this for each vertex($x_{i,j}$) in our graph.


## Sets

Sets are used to represent and manage information on the nodes that are part of the problem, allowing its use in equations, variables and parameters of the model. Additionally, it use aliases for the set $i$, in this case $j$ and $k$, which allow more flexible manipulation of variables and parameters in The equations. Aliases can be used in situations where we need to refer to the same elements of the original set in different contexts, such as when defining routes from one place to another on a route optimization problem. In this way, the set original and its aliases allow a more complete and efficient representation of the relationships and constraints in the optimization model.

In our problem we use the following set $i = 1... 12$, there are 10 possible places to visit, the hotel or place where we are hosting and one more dummy vertex. We add the dummy vertex because the base model returns a path from vertex 1 to vertex N, but we want it to return to vertex 1, that is, to close the route. To achieve the above mentioned we add a dummy vertex, This means that it is a vertex that does not exist, but it helps us to that vertex N has the values ​​of vertex 1, so when one arrives to vertex N, it is as if it had reached vertex 1.

## Parameters

We call parameters the values ​​we know before solving the problem, for our particular case, we are going to occupy knowing the reward values ​​of each place; opening and closing times of the establishments; the minimum elapsed time that the client want to be in the place and the cost of visiting it. We are handling the unit of minutes when we are talking about time and Mexican pesos when we talk about the cost.

<div class="center">

<div id="tab:internacionales NR 2022">

|            **Place**            | **Score**      | **Opening**  | **Closing**| **Stay**     | **Cost**  |
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
|          Dummy vertex           |       0        |      0       |    1440    |      0       |     0     |

The opening, closing and place stay are given in the 24-hour system converted into minutes.

</div>

</div>

The reward in the dummy vertex is 0 so that it is not considered in our objective function, since this vertex will always be visited by the formulation of the model, but since this place does not exist, we do not want to add something to the objective function. When a place has a value of 0 in the opening column, represents that you can visit any time of day, in the case of the closing column, the dummy vertex has a value of 1440 that in hours are 24, which indicates that it is open all day, in the case of the hotel this value does not matter because as we always go from it, and the model says that we will always reach vertex N, then the value that vertex N takes (vertex dummy) represents the value of the hotel, that is, we can reach any time to the hotel. In the stay and cost column, both the dummy variable such as the hotel take values ​​of 0, as the variable does not exist, it does not make sense to assign a cost or a time of stay.

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

Table of time cost between the chosen places in minutes

</div>

</div>

This table shows the travel time in minutes between the different places we select. It is important to note that the dummy vertex (in this case, 12) has the same values ​​as vertex one, this is done in order to achieve that when you get from any vertex to the dummy vertex be the same as arriving from any vertex to vertex 1. Effectively closing the route.

## Variables

In the model there are two variables, a variable of binary type. The first variable will result in 1 if node i to node j is going to be visited or 0 if it is not going to
visit from node i to node j.

$$x_{(i,j)}$$

The other variable to use will be of continuous positive type. The variable s(i) will be used to record and determine the exact time in which visit the place, which will be restricted by opening hours and closure of said establishment.

$$s(i)$$

## Restrictions

1\) $$\sum_{j=2}^N x_{1 j}=\sum_{i=1}^{N-1} x_{i N}=1$$ 
The first model constraint guarantees that we start at vertex 1 and terminate at vertex N. This constraint remained the same as in the base model, although with a modification to the number of total elements, this is because the model ensures that it will end at vertex N, but we want to end up at vertex 1, so we add a dummy vertex, this was elaborated in the sets section.

2\) $$\sum_{i=1}^{N-1} x_{i k}=\sum_{j=2}^N x_{k j} \leq 1 ; \quad \forall k=2, \ldots, N-1,$$
This constraint ensures the connectivity of the vertices as well as that only visit once. We did not make any modifications to this restriction.

3\) $$s_i+t_{i j}+ y_i-s_j \leq M\left(1-x_{i j}\right) ; \quad \forall i, j=1, \ldots, N$$
This constraint ensures the chronology of the path, we had to add a parameter $y_i$ to consider the minimum stay time to be you want to go through place.

4\) $$\sum_{i=1}^{N-1} \sum_{j=2}^N t_{i j} x_{i j} \leq T_{\max },$$
This constraint ensures that the constraint of the time budget, we did not make any modifications to this restriction.

5\) $$O_i \leq s_i ; \quad \forall i=1, \ldots, N,$$
Ensures that the time a place is reached is greater than or equal to the time the place opens, you can't get to a place if it's not there yet open. We did not make any changes to this restriction.

6\) $$s_i \leq C_i ; \quad \forall i=1, \ldots, N,$$ 
Ensures that the time a place is reached is less than or equal to the time the place closes. We did not make any modifications to this restriction.

7\) $$x_{i, j} \in\{0,1\} ; \quad \forall i, j=1, \ldots, N .$$ 
This constraint tells us that the variable $x_{i,j}$ is a binary variable, can only take the values ​​0 (not visited) or 1 (visited) of the node $i$ to node $j$. $i$ and $j$ take from 1 to the total number of vertices.

8\) $$\sum_{i=1}^{N-1} \sum_{j=2}^N t_{i,j} x_{i j} * 1.48 + \sum_{i=1}^{N-1} \sum_{j=2}^N P_{i} x_{i j} \leq \textit{Budget}$$
We add this restriction to consider the total budget of the person. Within the constraint we are considering the cost of the transportation, this is assuming that the person arrived at the tourist place with a sedan car, which is calculated by multiplying the driving time transport by a constant 'C' that we obtained through a relation, it is later explained how it was obtained, and finally it is multiplied by the variable $x_{i,j}$, that is, if it was visited or not, if it is not visited a place variable is 0, so all multiplication will be 0. In addition to considering the cost of visiting each location, this is done in the second part of the sum, where the cost of visiting the place by the variable $x_{i,j}$, that is, if the place was visited or not.

To arrive at the constant 'C', we start by taking the measurements of time between the longest distance and the time it takes to get there, to from this we make a rule of 3 to find how many kilometers they would be traveled in 60 minutes, ended up being 59km. after by An internet search found that approximately one sedan car
spends an average of 7 liters of gasoline per 100 kilometers.
We return to make a rule of 3 to find how many liters are spent in 59km which ended up being 3.92 liters. Having the number of liters spent for 60 minutes we make a last rule of 3 to findhow many liters are spent per minute, gave us the result of 0.0653 liters. After another search we found that the price of the gasoline per liter is 22.65 pesos and multiplying these last two values ​​we conclude that the weights per minute constant is of 1.48, for which this value is multiplied by the transport time between nodes.
The data of the previous relation is from 2023.



















