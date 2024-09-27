`include "CompUnsigned.v"
`include "divFreq.v"
`include "DIG_D_FF_1bit.v"

module top (
  input clk,
  input wire DL, DI, DD,
  output pwmmd,
  output wire m1r, m1d,
  output wire m2r, m2d,
  output pwmmi
);

  // División de frecuencia
  wire clk_out;
  divFreq freq_div (
    .CLK_IN(clk),
    .CLK_OUT(clk_out)
  );

  // Inicialización de duty cycle
  reg dutyb3, dutyb2, dutyb1, dutyb0;
  
  initial begin
    dutyb3 = 1'b1;
    dutyb2 = 1'b1;
    dutyb1 = 1'b0;
    dutyb0 = 1'b1;
  end

  // Inversión de las entradas
  wire DL_inv, DI_inv, DD_inv;
  assign DL_inv = ~DL;
  assign DI_inv = ~DI;
  assign DD_inv = ~DD;

  // Señales internas
  wire s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17;
  wire s5_not;

  // Comparadores usando CompUnsigned
  CompUnsigned #(
    .Bits(1)
  )
  CompUnsigned_i0 (
    .a(s1),
    .b(dutyb3),
    .less_than(s11)
  );

  CompUnsigned #(
    .Bits(1)
  )
  CompUnsigned_i1 (
    .a(s0),
    .b(dutyb2),
    .equal(s12),
    .less_than(s13)
  );

  CompUnsigned #(
    .Bits(1)
  )
  CompUnsigned_i2 (
    .a(s3),
    .b(dutyb1),
    .equal(s14),
    .less_than(s15)
  );

  CompUnsigned #(
    .Bits(1)
  )
  CompUnsigned_i3 (
    .a(s9),
    .b(dutyb0),
    .equal(s16),
    .less_than(s17)
  );

  // Lógica de salida pwmmd optimizada
  wire temp1 = (s12 & s11) | s13;
  wire temp2 = (temp1 & s14) | s15;
  wire temp3 = (temp2 & s16) | s17;
  assign pwmmd = temp3;

  // Lógica de control de contador y flip-flops
  assign s2 = (s0 ^ s1);
  assign s7 = (((s5 & s3) | (s3 & s4)) | ((s6 & s0) & s1));

  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i4 (
    .D(s8),
    .C(clk_out),
    .Q(s9),
    .notQ(s10)
  );

  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i5 (
    .D(s7),
    .C(clk_out),
    .Q(s3),
    .notQ(s6)
  );

  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i6 (
    .D(s2),
    .C(clk_out),
    .Q(s0),
    .notQ(s4)
  );

  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i7 (
    .D(s5),
    .C(clk_out),
    .Q(s1),
    .notQ(s5_not)  // Cambia el nombre de notQ
  );

  // Generación de señal intermedia
  assign s8 = ((s1 & (s0 & (s3 & s10))) | (((s4 | s6) | s5) & s9));

  // Lógica de control de motores
  assign m2r = (~DL_inv & ~DD_inv) | (DL_inv & DI_inv & DD_inv);
  assign m1r = (~DL_inv & ~DI_inv) | (~DL_inv & DD_inv);
  
  assign m2d = (DL_inv & ~DD_inv) | (~DL_inv & DI_inv & DD_inv);
  assign m1d = (DL_inv & ~DI_inv) | (DL_inv & DD_inv);
  
  // PWM para el motor izquierdo es el mismo que el derecho
  assign pwmmi = pwmmd;

endmodule























# Seguidor de Linea
![DIG_D_FF_1bit](https://github.com/user-attachments/assets/1e5b12f6-0bf6-4629-9852-088ec18c82d3)

![CompUnsigned](https://github.com/user-attachments/assets/27420eff-1be2-4268-bdc1-1d5f9cf7df4c)

# Introducción

En este proyecto se desarrolla un carro capaz de seguir una línea colocada en el suelo, se propone que este funcionamiento se de a partir de dos sensores infrarrojos, los cuales detectan la línea y posteriormente corrigen el rumbo del vehículo, añadido a esto, se plantea el uso de una fotoresistencia, la cuál al ser tapada invierte el sentido en el que se conduce el carro.

IMAGEN DEL CARRO

# Materiales

Para la realización del seguidor de línea se utilizaron diferente módulos y otros elementos que permiten el funcionamiento del vehículo.

## Tarjeta de Desarrollo BlackIce

El diseño se hizo a partir de la tarjeta de desarrollo BlackIce que cuenta con la FPGA ICE40HX4K.

IMAGEN DE LA TARJETA

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



