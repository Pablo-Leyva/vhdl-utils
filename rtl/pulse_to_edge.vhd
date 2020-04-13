library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_to_edge is
generic (
    edge_g  : string := "RISING"
);
port (
    clk     : in  std_ulogic;
    rst     : in  std_ulogic;
    pulse_i : in  std_ulogic;
    level_o : out std_ulogic
);
end pulse_to_edge;

architecture behavioural of pulse_to_edge is

    signal pulse_s,
           level_s : std_ulogic := '0';
    signal edge_s  : std_ulogic := '0';

begin

    g_both_edge_detector : if edge_g="BOTH" generate
        edge_s <= pulse_i xor pulse_s;
    end generate;
    g_rising_edge_detector : if edge_g="RISING" generate
        edge_s <= pulse_i and not pulse_s; -- new sample 1 -> old sample 0
    end generate;
    g_falling_edge_detector : if edge_g="FALLING" generate
        edge_s <= not pulse_i and pulse_s; -- new sample 0 -> old sample 1
    end generate;

    p_edge_switch : process(clk)
    begin
        if rising_edge (clk) then

            if rst='1' then  pulse_s <= '0';
            else             pulse_s <= pulse_i; end if;

            if rst='1' then  level_s <= '0';
            elsif edge_s='1' level_s <= not level_s; end if;

        end if;
    end process p_edge_switch;

    level_o <= level_s;

end behavioural;
