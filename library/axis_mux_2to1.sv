module axis_mux_2to1
	#(	  
		parameter	WIDTH 		= 16
	)
	(  
	input logic 					sel,
	input logic		[WIDTH-1:0]		data_0,
	input logic						valid_0,
	output logic						ready_0,
	
	input logic		[WIDTH-1:0]		data_1,
	input logic						valid_1,
	output  logic						ready_1,
	
	output  logic		[WIDTH-1:0]		data,
	output  logic						valid,
	input  logic						ready
	
    );

always@*
begin
	case(sel)
	1'b0:
	begin
		data		= data_0;
		valid       = valid_0;
		ready_0     = ready;
		ready_1     = 0;
	end
	1'b1:
	begin
		data		= data_1;
		valid       = valid_1;
		ready_0     = 0;
		ready_1     = ready;
	end
	endcase
end
endmodule