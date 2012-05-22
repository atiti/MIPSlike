#!/usr/bin/env python

import os, string, sys


if len(sys.argv) < 2:
	print "Usage: rommaker [inp.hex] [output.vhd]"
	sys.exit(0)

header = """--
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
"""
footer = """		when others => data <= "00000000000000000000000000000000";
	end case;
end process;

end rtl;
"""

fd = open(sys.argv[1], "r")
buff = fd.read().split("\n")
fd.close()

fd = open(sys.argv[2], "w")
fd.write(header)
cnt = 0
for line in buff:
	if line:
		regnum = str(bin(cnt))[2:]
		if len(regnum) < 32:
			regnum = (32-len(regnum))*"0" + regnum
		wline = "\t\twhen \""+regnum+"\" => data <= \""+line+"\";"
		fd.write(wline+"\n")
		cnt = cnt + 4	

fd.write(footer)
fd.close()
print "Done."



