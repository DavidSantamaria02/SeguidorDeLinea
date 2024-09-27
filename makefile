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

uno:
	yosys -p "synth_ice40 -top top -json top.json" top.v
dos:
	nextpnr-ice40 --hx4k --package tq144 --json top.json --pcf top.pcf --asc top.pnr
tres:
	icepack top.pnr top.bin
cargar:
	stty -F /dev/ttyACM0 raw
	cat top.bin > /dev/ttyACM0
