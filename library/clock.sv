module clock (
input	logic		clk,
input	logic		reset,
input	logic		en,
input	logic		[31:0]		count_max,
input	logic		[31:0]		count_max_hrs,
output	logic		clr_sec,
output	logic		[31:0]		count_sec,
output	logic		clr_min,
output	logic		[31:0]		count_min,
output	logic		clr_hrs,
output	logic		[31:0]		count_hrs
);


up_counter up_counter_sec
(
.clk 				(clk),
.reset 				(reset),
.en 				(en),
.clr 				(clr_sec),
.count_max 				(count_max),
.count 				(count_sec)
);



up_counter up_counter_min
(
.clk 				(clk),
.reset 				(reset),
.en 				(clr_sec),
.count_max 				(count_max),
.clr 				(clr_min),
.count 				(count_min)
);



up_counter up_counter_hrs
(
.clk 				(clk),
.reset 				(reset),
.en 				(clr_min),
.count_max 				(count_max_hrs),
.clr 				(clr_hrs),
.count 				(count_hrs)
);

endmodule