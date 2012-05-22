----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:29:59 05/01/2012 
-- Design Name: 
-- Module Name:    Forwarding - Behavioral 
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

entity Forwarding is

  port(	Reset           	: in std_logic;
			RegisterRs			: in std_logic_vector(4 downto 0);
			RegisterRt			: in std_logic_vector(4 downto 0);
			FwdDestRegMEM		: in std_logic_vector(4 downto 0);
			FwdDestRegWB		: in std_logic_vector(4 downto 0);
			ReadDataA			: in std_logic_vector(31 downto 0);
			ReadDataB			: in std_logic_vector(31 downto 0);
			FwdDatafromMEM		: in std_logic_vector(31 downto 0);
			FwdDatafromWB		: in std_logic_vector(31 downto 0);
			FwdRegWriteMEM		: in std_logic;
			FwdRegWriteWB		: in std_logic;
			DataA					: out std_logic_vector(31 downto 0);
			DataB					: out std_logic_vector(31 downto 0));
		  
end Forwarding;

architecture Behavioral of Forwarding is

begin

	DataA <= FwdDatafromMEM when (RegisterRs = FwdDestRegMEM and RegisterRs /= "00000" and FwdRegWriteMEM = '1') else 
				FwdDatafromWB  when (RegisterRs = FwdDestRegWB  and RegisterRs /= "00000" and FwdRegWriteWB  = '1') else ReadDataA;
	DataB <= FwdDatafromMEM when (RegisterRt = FwdDestRegMEM and RegisterRt /= "00000" and FwdRegWriteMEM = '1') else 
				FwdDatafromWB  when (RegisterRt = FwdDestRegWB  and RegisterRt /= "00000" and FwdRegWriteWB  = '1') else ReadDataB;

end Behavioral;

