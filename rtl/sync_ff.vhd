library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_ff is
generic ( n_stages_g : positive := 2 );
port (
    clk    : in   std_ulogic;
    rst    : in   std_ulogic;
    data_i : in   std_ulogic;
    data_o : out  std_ulogic
);
end sync_ff;

architecture behavioural of edge_to_pulse is

    signal data_sync_reg_s : std_ulogic_vector(n_stages_g-1 downto 0) := (others => '0');

begin

    data_sync_reg_s(0) <= data_i;

    proc_sync : process(clk)
    begin
        if rising_edge (clk) then

            if rst='1' then
                data_sync_reg_s <= (others => '0');
            else
                for i in 0 to n_stages_g-2 loop
                    data_sync_reg_s(i+1) <= data_sync_reg_s(i);
                end loop;
            end if;

        end if;
    end process proc_sync;

    data_o <= data_sync_reg_s(n_stages_g-1);

end sync_ff;
