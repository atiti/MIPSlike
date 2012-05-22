library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;


entity decoder is
    generic ( bit_width : integer := 32;
              num_vals : integer := 5 );
    port (I: in std_logic_vector(num_vals-1 downto 0);
          en : in std_logic;
          O : out std_logic_vector(bit_width-1 downto 0));
end decoder;

architecture archi of decoder is
begin
  process(I,en) is
  begin
    if en = '1' then
      O <= (O'range => '0');
      O(conv_integer(I)) <= '1';
    else
      O <= (O'range => '0');
    end if;  
  end process;
end archi;



