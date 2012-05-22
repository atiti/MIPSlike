----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:15:37 03/02/2012 
-- Design Name: 
-- Module Name:    hello_world - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hello_world is
    Port ( clk : in  STD_LOGIC;
           led : out  STD_LOGIC);
end hello_world;

architecture rtl of hello_world is

	  constant CLK_FREQ : integer := 50000000;
	  constant BLINK_FREQ : integer := 1;
	  constant CNT_MAX : integer := CLK_FREQ/BLINK_FREQ/2-1;

	  signal cnt      : unsigned(24 downto 0);
	  signal blink    : std_logic;

 begin
	  process(clk)
	  begin
			if rising_edge(clk) then
				 if cnt=CNT_MAX then
					  cnt <= (others => '0');
					  blink <= not blink;
				 else
					  cnt <= cnt + 1;
				 end if;
			end if;
	  end process;
	  led <= blink;
end rtl;