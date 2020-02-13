`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:22 12/02/2019 
// Design Name: 
// Module Name:    cam_read 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module cam_read #(
		parameter AW = 17 // Cantidad de bits  de la direccion 
		)(
		input rst,					// Reset para todo el sistema 
		input pclk,					// señal PCLK: señal  de reloj de la camara 	
		input vsync,				// señal VSYNC:  
		input href,					// señal HREF, 
		input [7:0] px_data,		// D:datos de la camara
		input b_captura,			// Boton para tomar foto
		
		output reg [AW-1:0] mem_px_addr = 0,		// direccion en la memoria 
		output reg [7:0] mem_px_data = 0,			// datos de la camara iniciados en 0
		output reg px_wr = 0							// Control de escritura
   );
	
	reg [2:0] fsm_state=1;								// Controla los estados 
	reg old_vsync = 0;									// Valor anterior de VSYNC
	reg cont = 1'b0;										// captura de datos
	reg [15:0] cont_href=16'b0000000000000000;	// Contador de HREF
	reg [15:0] old_href=16'b0000000000000000;		// Valor anterior de HREF
	reg [15:0] cont_pixel=16'b0000000000000000;	// Contador de pixeles por linea
	reg [15:0] cont_pclk=16'b0000000000000000;	// Contador PCLK totales
	
	always@(posedge pclk) begin						// Flancos de subida PCLK
		
		if (rst)
		begin
			mem_px_addr=0;									// Reinicia el valor de la direccion
			fsm_state=1;									// Envía al primer estado
			old_vsync=0;									// Asigna cero al valor anterior de VSYNC
			
		end else 
		
		// Maquina de estados 	
		case(fsm_state) 					
			
		1:		// Valores iniciales
			begin
				cont_href[15:0]=16'h0000;
				mem_px_addr=0;
				if(old_vsync && !vsync) fsm_state=2;
			end
		2:		// Contador HREF
			begin
				if(!old_href && href) begin
						cont_href = cont_href +1;
						cont_pixel=0;
						fsm_state=3;
						mem_px_data[7:2] = {px_data[7:5],px_data[2:0]};
						px_wr = 0;
						cont = ~cont;
						cont_pclk = cont_pclk + 1;
					
				end 
				else if(vsync) 
						fsm_state=1;
				else if(b_captura)
						fsm_state = 4;
			end
			
		3:		// Captura de datos
		begin
			if(href) begin  
				// contador de pixeles
				if (cont==0)
				begin
					mem_px_data[7:2] = {px_data[7:5],px_data[2:0]};
					px_wr = 0;
					cont_pclk = cont_pclk + 1;
				end
				else 
				begin
					mem_px_data[1:0] = {px_data[4:3]};
					px_wr = 1;
					if(mem_px_addr < 76800)
						mem_px_addr = mem_px_addr + 1;
					cont_pixel = cont_pixel +1;
					
				end
				cont = ~cont;
				
			end else

				fsm_state=2;

			
				
		end
		
		4:		// Mostrar imagen	
		if(b_captura)
		begin
			px_wr = 0;
			
		end
		else
			fsm_state = 1;
			
		
		endcase
		
		old_vsync = vsync;
	end

endmodule