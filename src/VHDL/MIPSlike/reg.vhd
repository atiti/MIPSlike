library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.ALL;

entity reg is
    generic ( bit_width : natural := 32 );
    port ( clk,clear,load : in std_logic;
           data_in : in std_logic_vector(bit_width-1 downto 0);
           data_out : out std_logic_vector(bit_width-1 downto 0)
    );
end reg;
         
architecture behavioral of reg is
  signal data_tmp : std_logic_vector(bit_width-1 downto 0);
begin
  process(data_in, clk, clear, load)
  begin
     if clear='1' then
       data_tmp <= (data_tmp'range => '0');
     elsif clk='0' and clk'event then
       if load='1' then
         data_tmp <= data_in;
        end if;
     end if;
  end process;

  data_out <= data_tmp;
end behavioral;



