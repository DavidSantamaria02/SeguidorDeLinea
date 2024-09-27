



# Seguidor de Linea


# Introducción

En este proyecto se desarrolla un carro capaz de seguir una línea colocada en el suelo, se propone que este funcionamiento se de a partir de dos sensores infrarrojos, los cuales detectan la línea y posteriormente corrigen el rumbo del vehículo, añadido a esto, se plantea el uso de una fotoresistencia, la cuál al ser tapada invierte el sentido en el que se conduce el carro.




# Materiales

Para la realización del seguidor de línea se utilizaron diferente módulos y otros elementos que permiten el funcionamiento del vehículo.

## Tarjeta de Desarrollo BlackIce

El diseño se hizo a partir de la tarjeta de desarrollo BlackIce que cuenta con la FPGA ICE40HX4K.

![image](https://github.com/user-attachments/assets/c71cb7c6-21da-4410-9309-141949c394ce)

## Módulo L298N

El L298N es un módulo controlador de motores que permite controlar el movimiento de motores eléctricos de corriente continua (DC) o motores paso a paso. Funciona como un puente H dual, lo que significa que puede controlar dos motores de manera independiente, permitiendo que giren tanto hacia adelante como hacia atrás.

![image](https://github.com/user-attachments/assets/e0d84b45-2e77-4aed-8f20-39a9b1770606)


## Sensores de Infrarrojo

Un sensor infrarrojo (IR) es un dispositivo que detecta la radiación infrarroja emitida por objetos o superficies. Estos sensores funcionan capturando la luz en la parte infrarroja del espectro electromagnético, que no es visible para el ojo humano, pero que todos los objetos emiten como radiación de calor.

Estos sensores se utilizaron para detectar la línea entre ellos y así mantener el curso del carro sobre esta.

![image](https://github.com/user-attachments/assets/ce3f1db3-5f10-4fc1-ba6d-90ddadca1249)

## Sensor de Fotoresistencia

Un sensor de fotoresistencia, también conocido como LDR (Light Dependent Resistor) o resistor dependiente de la luz, es un componente electrónico cuya resistencia varía en función de la cantidad de luz que recibe. A medida que aumenta la luz, la resistencia del sensor disminuye, y cuando la luz disminuye, la resistencia aumenta.

![image](https://github.com/user-attachments/assets/3f42e251-b678-4bf1-9a8f-d2820c976b83)

## Motores DC

Para las llantas del carro se utilizaron motores DC los cuales son compatibles con el módulo L298N.

![image](https://github.com/user-attachments/assets/f739cca5-b28f-450c-8637-e712c6d8d4c7)


# Diseño

## Diagrama de Flujo
![Start](https://github.com/user-attachments/assets/ff9b4ad5-76c6-4847-8069-e7edb7c43c44)

## Diseño Integrado
![top](https://github.com/user-attachments/assets/4803faf4-6ec4-41db-82f6-d686d2cfbc01)

## Divisor de Frecuencia

![divFreq](https://github.com/user-attachments/assets/56a8f01d-add8-4178-ac94-06d316995b8f)

# Testbench

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

![DIG_D_FF_1bit](https://github.com/user-attachments/assets/1e5b12f6-0bf6-4629-9852-088ec18c82d3)


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

D2 =Q2∗Q3+Q2∗Q3





## D3

| q0 q1 | q2 q3 (0-0) | q2 q3 (0-1) | q2 q3 (1-1) | q2 q3 (1-0) |
|-------|-------------|-------------|-------------|-------------|
| 0-0   | 1           |             |             | 1           |
| 0-1   | 1           |             |             | 1           |
| 1-1   | 1           |             |             | 1           |
| 1-0   | 1           |             |             | 1           |

### Fórmula

**D3 = =Q3


## Calculadora Duty

| Parámetro               | Valor         |
|-------------------------|---------------|
| **duty que quiere**      | 30%           |
| **valor exacto**         | 4.5           |
| **valor a poner**        | 5             |
| **valor a poner (en binario)** | 0.101   |

---

## Comparación de valores

![CompUnsigned](https://github.com/user-attachments/assets/27420eff-1be2-4268-bdc1-1d5f9cf7df4c)

| Numero A | a0 | a1 | a2 | a3 | Numero B (DUTY) | B0 | B1 | B2 | B3 | A0 < B0 | A1 < B1 | A2 < B2 | A3 < B3 | A < B | PMW30 |
|----------|----|----|----|----|-----------------|----|----|----|----|---------|---------|---------|---------|-------|-------|
| **Fila 1**  | 0  | 0  | 0  | 0  | **Fila 1**     | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     | 30%   |
| **Fila 2**  | 0  | 0  | 0  | 1  | **Fila 2**     | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 3**  | 0  | 0  | 1  | 0  | **Fila 3**     | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 4**  | 0  | 0  | 1  | 1  | **Fila 4**     | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 5**  | 0  | 1  | 0  | 0  | **Fila 5**     | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 6**  | 0  | 1  | 0  | 1  | **Fila 6**     | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 7**  | 0  | 1  | 1  | 0  | **Fila 7**     | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 8**  | 0  | 1  | 1  | 1  | **Fila 8**     | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 9**  | 1  | 0  | 0  | 0  | **Fila 9**     | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 10** | 1  | 0  | 0  | 1  | **Fila 10**    | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 11** | 1  | 0  | 1  | 0  | **Fila 11**    | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 12** | 1  | 0  | 1  | 1  | **Fila 12**    | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 13** | 1  | 1  | 0  | 0  | **Fila 13**    | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 14** | 1  | 1  | 0  | 1  | **Fila 14**    | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 15** | 1  | 1  | 1  | 0  | **Fila 15**    | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |
| **Fila 16** | 1  | 1  | 1  | 1  | **Fila 16**    | 0  | 0  | 1  | 1  | 0       | 1       | 0       | 1       | 1     |       |

Para duty 30%:

| q0 q1 |       (0-0) |       (0-1) |       (1-1) |       (1-0) |
|-------|-------------|-------------|-------------|-------------|
| 0-0   | 1           |   1         | 1           | 1           |
| 0-1   | 1           |             |             | 0           |
| 1-1   |             |             |             |             |
| 1-0   |             |             |             |             |

PWM = ~(a0*a2+a0*a1)



| Numero A | a0 | a1 | a2 | a3 | Numero B (DUTY) | B0 | B1 | B2 | B3 | A0 < B0 | A1 < B1 | A2 < B2 | A3 < B3 | A < B | PMW30 |
|----------|----|----|----|----|-----------------|----|----|----|----|---------|---------|---------|---------|-------|-------|

| **Fila 1**  | 0  | 0  | 0  | 0  | **Fila 1**     | 1  | 0  | 1  | 1  |         |         |         |         | 1     | 70%   |
| **Fila 2**  | 0  | 0  | 0  | 1  | **Fila 2**     | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 3**  | 0  | 0  | 1  | 0  | **Fila 3**     | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 4**  | 0  | 0  | 1  | 1  | **Fila 4**     | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 5**  | 0  | 1  | 0  | 0  | **Fila 5**     | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 6**  | 0  | 1  | 0  | 1  | **Fila 6**     | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 7**  | 0  | 1  | 1  | 0  | **Fila 7**     | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 8**  | 0  | 1  | 1  | 1  | **Fila 8**     | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 9**  | 1  | 0  | 0  | 0  | **Fila 9**     | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 10** | 1  | 0  | 0  | 1  | **Fila 10**    | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 11** | 1  | 0  | 1  | 0  | **Fila 11**    | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 12** | 1  | 0  | 1  | 1  | **Fila 12**    | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 13** | 1  | 1  | 0  | 0  | **Fila 13**    | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 14** | 1  | 1  | 0  | 1  | **Fila 14**    | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 15** | 1  | 1  | 1  | 0  | **Fila 15**    | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |
| **Fila 16** | 1  | 1  | 1  | 1  | **Fila 16**    | 1  | 0  | 1  | 1  |         |         |         |         | 1     |       |

Para duty 30%:

| q0 q1 |       (0-0) |       (0-1) |       (1-1) |       (1-0) |
|-------|-------------|-------------|-------------|-------------|
| 0-0   | 1           |   1         | 1           | 1           |
| 0-1   | 1           |  1          | 1           | 1           |
| 1-1   |             |             |             |             |
| 1-0   | 1           | 1           |             |   1         |

PWM = ~(a0*a2+a0*a1)


#Conclusiones

1. El uso de la FPGA permite un control más preciso y rápido de los motores, gestionando de forma eficiente la respuesta a los datos obtenidos por los sensores infrarrojos. Esto resulta en una mejor capacidad de seguimiento de la línea, con menos oscilaciones y una mayor estabilidad en la trayectoria del robot.
2. Utilizar una FPGA en el proyecto no solo permite una implementación eficiente del algoritmo de control, sino que también ofrece la flexibilidad para modificar y escalar el diseño en el futuro. Se pueden añadir más sensores o implementar algoritmos más complejos sin necesidad de un rediseño completo del hardware, facilitando futuras mejoras o adaptaciones del sistema.
3. Es de suma importancia la planeación adecuada del trabajo incluso antes de empezar a programarlo, esta anticipación puede ayudar a reducir en gran medida el tiempo de realización de cualquier proyecto.


   

