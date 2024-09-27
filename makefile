
uno:
	yosys -p "synth_ice40 -top top -json top.json" top.v
dos:
	nextpnr-ice40 --hx4k --package tq144 --json top.json --pcf top.pcf --asc top.pnr
tres:
	icepack top.pnr top.bin
cargar:
	stty -F /dev/ttyACM0 raw
	cat top.bin > /dev/ttyACM0
