module axis_mux_4to1
	#(	  
		parameter	WIDTH 		= 16
	)
	(  
	input logic		[1:0]			sel,
	input logic		[WIDTH-1:0]		data_0,
	input logic						valid_0,
	output logic						ready_0,
	
	input logic		[WIDTH-1:0]		data_1,
	input logic						valid_1,
	output logic						ready_1,
	
	input logic		[WIDTH-1:0]		data_2,
	input logic						valid_2,
	output logic						ready_2,
	
	input logic		[WIDTH-1:0]		data_3,
	input logic						valid_3,
	output logic						ready_3,
	
	output logic		[WIDTH-1:0]		data,
	output logic					valid,
	input logic logic						ready
	
    );

always@*
begin
	case(sel)
	2'b0:
	begin
		data		= data_0;
		valid       = valid_0;
		
		ready_0     = ready;
		ready_1     = 0;
		ready_2     = 0;
		ready_3     = 0;
	end
	2'b1:
	begin
		data		= data_1;
		valid       = valid_1;
		
		ready_0     = 0;
		ready_1     = ready;
		ready_2     = 0;
		ready_3     = 0;
	end
	2'b2:
	begin
		data		= data_2;
		valid       = valid_2;
		
		ready_0     = 0;
		ready_1     = 0;
		ready_2     = ready;
		ready_3     = 0;
	end
	2'b3:
	begin
		data		= data_3;
		valid       = valid_3;
		
		ready_0     = 0;
		ready_1     = 0;
		ready_2     = 0;
		ready_3     = ready;
	end
	endcase
end
endmodule