`timescale 1ns/1ps
`include "top.v"

`timescale 1ns / 1ps

module top_tb;

// Entradas del testbench (señales de prueba)
reg clk;
reg DL, DI, DD;

// Salidas del módulo 'top'
wire pwmmd;
wire m1r, m1d;
wire m2r, m2d;
wire pwmmi;

// Instanciar el módulo a probar
top uut (
    .clk(clk),
    .DL(DL),
    .DI(DI),
    .DD(DD),
    .pwmmd(pwmmd),
    .m1r(m1r),
    .m1d(m1d),
    .m2r(m2r),
    .m2d(m2d),
    .pwmmi(pwmmi)
);

// Generador de reloj
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Reloj con período de 10 ns
end

// Proceso de simulación
initial begin
    // Inicializar las entradas
    DL = 0; DI = 0; DD = 0;
    
    // Mostrar las señales de salida en cada cambio
    $monitor("Time: %0dns, DL: %b, DI: %b, DD: %b, pwmmd: %b, m1r: %b, m1d: %b, m2r: %b, m2d: %b, pwmmi: %b", 
             $time, DL, DI, DD, pwmmd, m1r, m1d, m2r, m2d, pwmmi);
    
    // Aplicar diferentes combinaciones de entradas
    #10 DL = 0; DI = 0; DD = 0;
	#10 DL = 0; DI = 0; DD = 1;
	#10 DL = 0; DI = 1; DD = 0;
	#10 DL = 0; DI = 1; DD = 1;
	#10 DL = 1; DI = 0; DD = 0;
	#10 DL = 1; DI = 0; DD = 1;
	#10 DL = 1; DI = 1; DD = 0;
	#10 DL = 1; DI = 1; DD = 1;
    #10 DL = 0; DI = 0; DD = 0;
	#10 DL = 0; DI = 0; DD = 1;
	#10 DL = 0; DI = 1; DD = 0;
	#10 DL = 0; DI = 1; DD = 1;
	#10 DL = 1; DI = 0; DD = 0;
	#10 DL = 1; DI = 0; DD = 1;
	#10 DL = 1; DI = 1; DD = 0;
	#10 DL = 1; DI = 1; DD = 1;
    #10 DL = 0; DI = 0; DD = 0;
	#10 DL = 0; DI = 0; DD = 1;
	#10 DL = 0; DI = 1; DD = 0;
	#10 DL = 0; DI = 1; DD = 1;
	#10 DL = 1; DI = 0; DD = 0;
	#10 DL = 1; DI = 0; DD = 1;
	#10 DL = 1; DI = 1; DD = 0;
	#10 DL = 1; DI = 1; DD = 1;
    
    // Terminar la simulación después de algunos ciclos
    #50 $finish;
end

endmodule
