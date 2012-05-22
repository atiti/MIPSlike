library ieee;
use ieee.std_logic_1164.all;

entity mux8to1 is
    port (A, B, C, D, E, F, G, H : in std_logic;
          S : in std_logic_vector (2 downto 0);
          O : out std_logic);
end mux8to1;

architecture archi of mux8to1 is
begin
    process (A, B, C, D, E, F, G, H, S)
    begin
      case s is 
         when "000" => O <= A;
         when "001" => O <= B;
         when "010" => O <= C;
         when "011" => O <= D;
         when "100" => O <= E;
         when "101" => O <= F;
         when "110" => O <= G;
         when "111" => O <= H;
         when others => O <= A;
      end case;
    end process;
end archi;

