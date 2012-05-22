----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:07:34 04/03/2012 
-- Design Name: 
-- Module Name:    WriteBack - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WriteBack is

   port(Reset           : in std_logic;
		  MemtoReg			: in std_logic;
		  ALUResult			: in std_logic_vector(31 downto 0);
		  ReadData			: in std_logic_vector(31 downto 0);
		  WriteData	 		: out std_logic_vector(31 downto 0));

end WriteBack;

architecture Behavioral of WriteBack is

begin

	WriteData <= ALUResult when (MemtoReg='0') else ReadData;

end Behavioral;
