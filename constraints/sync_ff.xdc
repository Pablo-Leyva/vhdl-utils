set_property DONT_TOUCH TRUE [get_cells -hier -filter {NAME=~*sync_ff}]
set_property ASYNC_REG  TRUE [get_cells -hier -filter {NAME=~*sync_ff/*data_sync_reg_s*}]

set_false_path -through [get_pins -filter {NAME=~*data_i} -of [get_cells -hier -filter {NAME=~*sync_ff}]]
