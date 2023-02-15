module aizaz (
input	logic		clk,
input	logic		reset,

);


up_counter cout_sec
(
.clk			(),
.reset			(),
.en			(),
.count_max			(),
.clr			(),
.count			()
);



up_counter cout_min
(
.clk			(),
.reset			(),
.en			(),
.count_max			(),
.clr			(),
.count			()
);



up_counter cout_hra
(
.clk			(),
.reset			(),
.en			(),
.count_max			(),
.clr			(),
.count			()
);

endmodule