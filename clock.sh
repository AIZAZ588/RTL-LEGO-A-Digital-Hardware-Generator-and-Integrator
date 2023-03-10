#!/bin/bash
create "-f clock.sv" "-i clk reset en count_max_hrs clr_sec count_sec" "-ir None None None [5:0] None [5:0]" "-o clr_min count_min clr_hrs count_hrs" "-or None [5:0] None [5:0]";
plug "-f up_counter.sv"" -n Sec";
plug "-f up_counter.sv"" -n Min";
plug "-f up_counter.sv"" -n Hr";

#connect "-i Sec -ip clk en count_max clr count"
