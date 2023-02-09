module axis_mux_2to1
	#(	  
		parameter	WIDTH 		= 16
	)
	(  
	input logic		[2:0]			sel,
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

	input logic		[WIDTH-1:0]		data_4,
	input logic						valid_4,
	output logic						ready_4,
	
	input logic		[WIDTH-1:0]		data_5,
	input logic						valid_5,
	output logic						ready_5,

	input logic		[WIDTH-1:0]		data_6,
	input logic						valid_6,
	output logic						ready_6,
	
	input logic		[WIDTH-1:0]		data_7,
	input logic						valid_7,
	output logic						ready_7,

	output logic		[WIDTH-1:0]		data,
	output logic					valid,
	input logic						ready
	
    );

always@*
begin
	case(sel)
	3'b0:
	begin
		data		= data_0;
		valid       = valid_0;
		
		ready_0     = ready;
		ready_1     = 0;
		ready_2     = 0;
		ready_3     = 0;
		ready_4     = 0;
		ready_5     = 0;
		ready_6     = 0;
		ready_7     = 0;
	end
	3'b1:
	begin
		data		= data_1;
		valid       = valid_1;
		
		ready_0     = 0;
		ready_1     = ready;
		ready_2     = 0;
		ready_3     = 0;
		ready_4     = 0;
		ready_5     = 0;
		ready_6     = 0;
		ready_7     = 0;
	end
	3'b2:
	begin
		data		= data_2;
		valid       = valid_2;
		
		ready_0     = 0;
		ready_1     = 0;
		ready_2     = ready;
		ready_3     = 0;
		ready_4     = 0;
		ready_5     = 0;
		ready_6     = 0;
		ready_7     = 0;
	end
	3'b3:
	begin
		data		= data_3;
		valid       = valid_3;
		
		ready_0     = 0;
		ready_1     = 0;
		ready_2     = 0;
		ready_3     = ready;
		ready_4     = 0;
		ready_5     = 0;
		ready_6     = 0;
		ready_7     = 0;
	end
	3'b4:
	begin
		data		= data_4;
		valid       = valid_4;
		
		ready_0     = 0;
		ready_1     = 0;
		ready_2     = 0;
		ready_3     = 0;
		ready_4     = ready;
		ready_5     = 0;
		ready_6     = 0;
		ready_7     = 0;
	end
	3'b5:
	begin
		data		= data_5;
		valid       = valid_5;
		
		ready_0     = 0;
		ready_1     = 0;
		ready_2     = 0;
		ready_3     = 0;
		ready_4     = 0;
		ready_5     = ready;
		ready_6     = 0;
		ready_7     = 0;
	end
	3'b6:
	begin
		data		= data_6;
		valid       = valid_6;
		
		ready_0     = 0;
		ready_1     = 0;
		ready_2     = 0;
		ready_3     = 0;
		ready_4     = 0;
		ready_5     = 0;
		ready_6     = ready;
		ready_7     = 0;
	end
	3'b7:
	begin
		data		= data_7;
		valid       = valid_7;
		
		ready_0     = 0;
		ready_1     = 0;
		ready_2     = 0;
		ready_3     = 0;
		ready_4     = 0;
		ready_5     = 0;
		ready_6     = 0;
		ready_7     = ready;
	end
	endcase
end
endmodule