
## Testbench

Para el testbench, se utilizaron como parámetros las variables `DL`, `DI` y `DD`, que corresponden a las entradas del sensor de luz y a los sensores de seguimiento de línea ubicados a la izquierda y a la derecha. Decidimos probar todas las 8 combinaciones posibles de señales:

| DL | DI | DD |
|----|----|----|
| 0  | 0  | 0  |
| 0  | 0  | 1  |
| 0  | 1  | 0  |
| 0  | 1  | 1  |
| 1  | 0  | 0  |
| 1  | 0  | 1  |
| 1  | 1  | 0  |
| 1  | 1  | 1  |



Además, incluimos un reloj (`clk`), probando cada una de las combinaciones de los tres primeros parámetros en tres ocasiones, lo que resultó en un total de 24 ciclos de `clk`. Esto se hizo para garantizar un número suficiente de muestras con el `clk` y así evaluar las dos salidas PWM.

Las salidas generadas son dos PWM, uno para cada motor, junto con cuatro señales que controlan los motores: `m1r` (motor uno en reversa), `m1d` (motor uno hacia adelante), `m2r` (motor dos en reversa) y `m2d` (motor dos hacia adelante). Para esta prueba, se utilizó un duty cycle de 9, lo que significa que los PWM estarán activos un poco más de la mitad del tiempo (de ahí la elección de 24 muestras).

Los resultados se presentan a continuación:

![image](https://github.com/user-attachments/assets/b3caf328-0dea-43d9-a2d5-d476a053f90d)


Se puede observar el funcionamiento lógico interno: cuando se activa el `DL`, los motores giran en reversa; por defecto, los motores avanzan. Al activar el `DI`, el motor izquierdo se apaga, mientras que al activar el `DD`, el motor derecho se apaga. Además, se puede notar que los PWM estuvieron activos durante 16 de los 24 ciclos.



# Contador de 4 bits FF tipo D

| estado anterior |    | estado nuevo / flip-flops   |
|-----------------|----|----------------------------|





| q0 | q1 | q2 | q3 |    | q0+ / D0 | q1+ / D1 | q2+ / D2 | q3+ / D3 |
|----|----|----|----|----|---------|---------|---------|---------|
| 0  | 0  | 0  | 0  |    |   0     |   0     |   0     |   1     |
| 0  | 0  | 0  | 1  |    |   1     |   0     |   0     |   0     |
| 0  | 0  | 1  | 0  |    |   0     |   1     |   0     |   0     |
| 0  | 0  | 1  | 1  |    |   1     |   1     |   0     |   0     |
| 0  | 1  | 0  | 0  |    |   0     |   0     |   1     |   0     |
| 0  | 1  | 0  | 1  |    |   1     |   0     |   1     |   0     |
| 0  | 1  | 1  | 0  |    |   0     |   1     |   1     |   0     |
| 0  | 1  | 1  | 1  |    |   1     |   1     |   1     |   0     |
| 1  | 0  | 0  | 0  |    |   0     |   0     |   0     |   1     |
| 1  | 0  | 0  | 1  |    |   1     |   0     |   0     |   0     |
| 1  | 0  | 1  | 0  |    |   0     |   1     |   0     |   0     |
| 1  | 0  | 1  | 1  |    |   1     |   1     |   0     |   0     |
| 1  | 1  | 0  | 0  |    |   0     |   0     |   1     |   0     |
| 1  | 1  | 0  | 1  |    |   1     |   0     |   1     |   0     |
| 1  | 1  | 1  | 0  |    |   0     |   1     |   1     |   0     |
| 1  | 1  | 1  | 1  |    |   1     |   1     |   1     |   0     |




# D0 bit menos significativo

| q0 q1 | q2 q3 (0-0) | q2 q3 (0-1) | q2 q3 (1-1) | q2 q3 (1-0) |
|-------|-------------|-------------|-------------|-------------|
| 0-0   |             |             |             |             |
| 0-1   |             | 1           |             |             |
| 1-1   | 1           | 1           | 1           |             |
| 1-0   | 1           | 1           | 1           | 1           |

### Fórmulas

D0  

math
D0 = Q0 * Q2 + 0 * Q1 + Q0 * Q3 + Q0 * Q1 * Q2 * Q3


 ## D1

| q0 q1 | q2 q3 (0-0) | q2 q3 (0-1) | q2 q3 (1-1) | q2 q3 (1-0) |
|-------|-------------|-------------|-------------|-------------|
| 0-0   | 1           | 1           | 1           |             |
| 0-1   | 1           |             | 1           |             |
| 1-1   | 1           | 1           | 1           | 1           |
| 1-0   | 1           | 1           | 1           | 1           |

### Fórmulas

**D1 =**

math
D1 = Q1 * Q2 + Q1 * Q3 + Q1 * Q2 * Q3



---

## D2

| q0 q1 | q2 q3 (0-0) | q2 q3 (0-1) | q2 q3 (1-1) | q2 q3 (1-0) |
|-------|-------------|-------------|-------------|-------------|
| 0-0   |             | 1           |             | 1           |
| 0-1   |             | 1           |             | 1           |
| 1-1   |             | 1           |             | 1           |
| 1-0   |             | 1           |             | 1           |

### Fórmulas

D2 =**





## D3

| q0 q1 | q2 q3 (0-0) | q2 q3 (0-1) | q2 q3 (1-1) | q2 q3 (1-0) |
|-------|-------------|-------------|-------------|-------------|
| 0-0   | 1           |             |             | 1           |
| 0-1   | 1           |             |             | 1           |
| 1-1   | 1           |             |             | 1           |
| 1-0   | 1           |             |             | 1           |

### Fórmula

**D3 =**





