library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity edge_to_pulse is
generic (
    edge_g  : string := "BOTH"
);
port (
    clk     : in  std_ulogic;
    rst     : in  std_ulogic;
    input_i : in  std_ulogic;
    pulse_o : out std_ulogic
);
end edge_to_pulse;

architecture behavioural of edge_to_pulse is

    signal input_s : std_ulogic := '0';
    signal pulse_s : std_ulogic := '0';

begin

    g_both_edge_detector : if edge_g="BOTH" generate
        pulse_s <= input_i xor input_s;
    end generate;
    g_rising_edge_detector : if edge_g="RISING" generate
        pulse_s <= input_i and not input_s; -- new sample 1 -> old sample 0
    end generate;
    g_falling_edge_detector : if edge_g="FALLING" generate
        pulse_s <= not input_i and input_s; -- new sample 0 -> old sample 1
    end generate;

    p_pulse_generator : process(clk)
    begin
        if rising_edge (clk) then

            if rst='1' then
                input_s <= '0';
                pulse_o <= '0';
            else
                input_s <= input_i;
                pulse_o <= pulse_s;
            end if;

        end if;
    end process p_pulse_generator;

end behavioural;
