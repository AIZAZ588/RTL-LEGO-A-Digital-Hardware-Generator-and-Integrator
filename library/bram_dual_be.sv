module bram_dual_be			// Readfirst mode with byte enable
	#(
		parameter NB_COL = 4,                       		// Specify number of columns (number of bytes)
		parameter COL_WIDTH = 8,                  			// Specify column width (byte width, typically 8 or 9)
		parameter RAM_DEPTH = 512,                  		// Specify RAM depth (number of entries)
		parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE", 	// Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
		parameter INIT_FILE = "",                       	// Specify name/location of RAM initialization file if using one (leave blank if not)
		parameter INIT_START_ADDR 	= 0,
		parameter INIT_END_ADDR		= RAM_DEPTH-1
	)
(
  input logic		[clogb2(RAM_DEPTH-1)-1:0] addra,   // Port A address bus, width determined from RAM_DEPTH
  input logic		[clogb2(RAM_DEPTH-1)-1:0] addrb,   // Port B address bus, width determined from RAM_DEPTH
  input logic		[(NB_COL*COL_WIDTH)-1:0] dina,   // Port A RAM Input data
  input logic		[(NB_COL*COL_WIDTH)-1:0] dinb,   // Port B RAM Input data
  input logic		clka,                            // Port A clock
  input logic		clkb,                            // Port B clock
  input logic		[NB_COL-1:0] wea,                // Port A write enable
  input logic		[NB_COL-1:0] web,                // Port B write enable
  input logic		ena,                             // Port A RAM Enable, for additional power savings, disable port when not in use
  input logic		enb,                             // Port B RAM Enable, for additional power savings, disable port when not in use
  input logic		rsta,				 // Port A output reset (does not affect memory contents)
  input logic		rstb,                            // Port B output reset (does not affect memory contents)
  input logic		regcea,                          // Port A output register enable
  input logic		regceb,                          // Port B output register enable
  output logic 	[(NB_COL*COL_WIDTH)-1:0] douta, // Port A RAM output data
  output logic 	[(NB_COL*COL_WIDTH)-1:0] doutb // Port B RAM output data
);
  reg [(NB_COL*COL_WIDTH)-1:0] ram_name [RAM_DEPTH-1:0];
  reg [(NB_COL*COL_WIDTH)-1:0] ram_data_a = {(NB_COL*COL_WIDTH){1'b0}};
  reg [(NB_COL*COL_WIDTH)-1:0] ram_data_b = {(NB_COL*COL_WIDTH){1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, ram_name, INIT_START_ADDR, INIT_END_ADDR);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          ram_name[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
    end
  endgenerate

  always @(posedge clka)
    if (ena) begin
      ram_data_a <= ram_name[addra];
    end

  always @(posedge clkb)
    if (enb) begin
      ram_data_b <= ram_name[addrb];
    end

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always @(posedge clka)
         if (ena)
           if (wea[i])
             ram_name[addra][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= dina[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
       always @(posedge clkb)
         if (enb)
           if (web[i])
             ram_name[addrb][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= dinb[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
  end
  endgenerate

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign douta = ram_data_a;
       assign doutb = ram_data_b;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [(NB_COL*COL_WIDTH)-1:0] douta_reg = {(NB_COL*COL_WIDTH){1'b0}};
      reg [(NB_COL*COL_WIDTH)-1:0] doutb_reg = {(NB_COL*COL_WIDTH){1'b0}};

      always @(posedge clka)
        if (rsta)
          douta_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (regcea)
          douta_reg <= ram_data_a;

      always @(posedge clkb)
        if (rstb)
          doutb_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (regceb)
          doutb_reg <= ram_data_b;

      assign douta = douta_reg;
      assign doutb = doutb_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input logic integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
endmodule							
							