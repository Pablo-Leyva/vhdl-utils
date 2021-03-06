library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_ff is
generic ( n_stages_g : positive := 2 );
port (
    clk    : in   std_ulogic;
    rst    : in   std_ulogic := '0';
    data_i : in   std_ulogic;
    data_o : out  std_ulogic
);
end sync_ff;

architecture behavioural of sync_ff is

    signal data_sync_reg_s : std_ulogic_vector(n_stages_g-1 downto 0) := (others => '0');

--    attribute ASYNC_REG : string;
--    attribute ASYNC_REG of data_sync_reg_s : signal is "TRUE";

begin

    data_sync_reg_s(0) <= data_i;

    gen_shift : for i in 0 to n_stages_g-2 generate
        proc_sync : process(clk)
        begin
            if rising_edge (clk) then
                data_sync_reg_s(i+1) <= data_sync_reg_s(i);
            end if;
        end process proc_sync;
    end generate;

    data_o <= data_sync_reg_s(n_stages_g-1);

end behavioural;
