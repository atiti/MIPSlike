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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROMv2 is
	 generic ( addr_width : integer := 12;
				  data_width : integer := 32 
	 );
    port ( CLK,EN : in  STD_LOGIC;
           ADDR : in  std_logic_vector(addr_width-1 downto 0);
           DATA : out  std_logic_vector(data_width-1 downto 0)
    );       
end ROMv2;

architecture Behavioral of ROMv2 is
	type rom_type is array (0 to 2**addr_width-1) of std_logic_vector(data_width-1 downto 0);
  constant IROM : rom_type := (
"""
footer = """
  );  
  signal tmpaddr : std_logic_vector(addr_width-1 downto 0);
  signal rdata : std_logic_vector ((data_width-1) downto 0);
begin
    tmpaddr <= "00" & ADDR(11 downto 2);
    rdata <= IROM(to_integer(unsigned(tmpaddr)));

    process (CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (EN = '1') then
                DATA <= rdata;
            end if;
        end if;
    end process;

end Behavioral;
"""

fd = open(sys.argv[1], "r")
buff = fd.read().split("\n")
fd.close()

fd = open(sys.argv[2], "w")
fd.write(header)
cnt2 = 0
for line in buff:
	if line:
		fd.write("\""+line+"\",\n")
		cnt2 += 1

num_bits = 12
left = (2**num_bits - 1) - cnt2+1
for i in range(0,left):
	fd.write("\"00000000000000000000000000000000\"");
	if (i < left-1):
		fd.write(",\n");


fd.write(footer)
fd.close()
print "Done."



