--
--  rom.vhd
--
--  generic VHDL version of ROM
--
--      DONT edit this file!
--      it is automatically generated
--

library ieee;
use ieee.std_logic_1164.all;

entity rom is
port (
	clk         : in std_logic;
	address     : in std_logic_vector(31 downto 0);
	q           : out std_logic_vector(31 downto 0)
);
end rom;

architecture rtl of rom is

	signal areg     : std_logic_vector(31 downto 0);
	signal data     : std_logic_vector(31 downto 0);
begin
	process(clk) begin
	if rising_edge(clk) then
		areg <= address;
	end if;

	end process;

	q <= data;

	process(areg) begin

	case areg is
		when "00000000000000000000000000000000" => data <= "00100000010000100000000000000000";
		when "00000000000000000000000000000100" => data <= "00100000011000110000000000000100";
		when "00000000000000000000000000001000" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000000001100" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000000010000" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000000010100" => data <= "10101100011000100000000000000000";
		when "00000000000000000000000000011000" => data <= "00100000100001000000000000000011";
		when "00000000000000000000000000011100" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000000100000" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000000100100" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000000101000" => data <= "00000000011001000001000000100000";
		when "00000000000000000000000000101100" => data <= "10001100011001010000000000000000";
		when "00000000000000000000000000110000" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000000110100" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000000111000" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000000111100" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000001000000" => data <= "00000000010001010001000000100000";
		when "00000000000000000000000001000100" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000001001000" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000001001100" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000001010000" => data <= "00000000000000000100100000100000";
		when "00000000000000000000000001010100" => data <= "10101100011000100000000000000000";
		when others => data <= "00000000000000000000000000000000";
	end case;
end process;

end rtl;