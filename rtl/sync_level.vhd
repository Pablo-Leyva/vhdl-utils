library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_level is
generic ( n_stages_g : positive := 2 );
port (
    aclk     : in   std_ulogic;
    arst     : in   std_ulogic := '0';
    alevel_i : in   std_ulogic;

    bclk     : in   std_ulogic;
    brst     : in   std_ulogic := '0';
    blevel_o : out  std_ulogic
);
end sync_level;

architecture behavioural of sync_level is

    signal level_s : std_ulogic := '0';

    attribute ASYNC_REG : string;
    attribute ASYNC_REG of level_s : signal is "TRUE"; 

begin

    proc_latch_input : process(aclk)
    begin
        if rising_edge (aclk) then

            if arst='1' then level_s <= '0';
            else             level_s <= alevel_i; end if;

        end if;
    end process proc_latch_input;

    inst_sync_ff : entity work.sync_ff
    generic map ( n_stages_g => n_stages_g )
    port map (
        clk    => bclk,
        rst    => brst,
        data_i => level_s,
        data_o => blevel_o
    );

end behavioural;
