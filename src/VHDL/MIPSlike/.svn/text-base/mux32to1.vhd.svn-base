library ieee;
use ieee.std_logic_1164.all;

entity mux32to1 is
    generic ( bit_width : integer := 32 );
    port (I0,I1,I2,I3,I4,I5,I6,I7 : in std_logic_vector(bit_width-1 downto 0);
          I8,I9,I10,I11,I12,I13,I14,I15 : in std_logic_vector(bit_width-1 downto 0);
          I16,I17,I18,I19,I20,I21,I22,I23 : in std_logic_vector(bit_width-1 downto 0);
          I24,I25,I26,I27,I28,I29,I30,I31 : in std_logic_vector(bit_width-1 downto 0);
          S : in std_logic_vector (4 downto 0);
          O : out std_logic_vector(bit_width-1 downto 0));
end mux32to1;

architecture archi of mux32to1 is
begin
    process (S,I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13,I14,I15,I16,I17,I18,I19,I20,I21,I22,I23,I24,I25,I26,I27,I28,I29,I30,I31)
    begin
      case S is 
         when "00000" => O <= I0;
         when "00001" => O <= I1;
         when "00010" => O <= I2;
         when "00011" => O <= I3;
         when "00100" => O <= I4;
         when "00101" => O <= I5;
         when "00110" => O <= I6;
         when "00111" => O <= I7;
         when "01000" => O <= I8;
         when "01001" => O <= I9;
         when "01010" => O <= I10;
         when "01011" => O <= I11;
         when "01100" => O <= I12;
         when "01101" => O <= I13;
         when "01110" => O <= I14;
         when "01111" => O <= I15;
         when "10000" => O <= I16;
         when "10001" => O <= I17;
         when "10010" => O <= I18;
         when "10011" => O <= I19;
         when "10100" => O <= I20;
         when "10101" => O <= I21;
         when "10110" => O <= I22;
         when "10111" => O <= I23;
         when "11000" => O <= I24;
         when "11001" => O <= I25;
         when "11010" => O <= I26;
         when "11011" => O <= I27;
         when "11100" => O <= I28;
         when "11101" => O <= I29;
         when "11110" => O <= I30;
         when "11111" => O <= I31;
         when others => O <= I0;
      end case;
    end process;
end archi;


