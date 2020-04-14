library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_pulse is
generic ( n_stages_g : positive := 2 );
port (
    aclk     : in   std_ulogic;
    arst     : in   std_ulogic;
    apulse_i : in   std_ulogic;

    bclk     : in   std_ulogic;
    brst     : in   std_ulogic;
    bpulse_o : out  std_ulogic
);
end sync_pulse;

architecture behavioural of sync_pulse is

    signal alevel_s, blevel_s : std_ulogic := '0';

begin

    inst_pulse_to_edge : entity work.pulse_to_edge
    generic map ( edge_g => "RISING" )
    port map(
        clk     => aclk,
        rst     => arst,
        pulse_i => apulse_i,
        level_o => alevel_s
    );

    inst_sync_ff : entity work.sync_ff
    generic map ( n_stages_g => n_stages_g )
    port map (
        clk    => bclk,
        rst    => brst,
        data_i => alevel_s,
        data_o => blevel_s
    );

    inst_edge_to_pulse : entity work.edge_to_pulse
    generic map ( edge_g => "RISING" )
    port map(
        clk     => bclk,
        rst     => brst,
        input_i => blevel_s,
        pulse_o => bpulse_o
    );

end behavioural;
