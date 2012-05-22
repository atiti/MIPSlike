----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:09:46 04/16/2012 
-- Design Name: 
-- Module Name:    instructionFetch - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instructionFetch is
		port(Reset           : in std_logic;
			  Clk					: in std_logic;
			  Branch				: in std_logic;
			  jumpSelect		: in std_logic;
			  branchPC			: in std_logic_vector(31 downto 0);
			  jumpPC				: in std_logic_vector(31 downto 0);
			  outPC				: out std_logic_vector(31 downto 0);
			  Instruction    	: out std_logic_vector(31 downto 0));

end instructionFetch;

architecture Behavioral of instructionFetch is
	--component rom is
	--	port (
	--		clk         : in std_logic;
	--		address     : in std_logic_vector(31 downto 0);
	--		q           : out std_logic_vector(31 downto 0)
	--	);
	--end component;
	component ROMv2 is
	 generic ( addr_width : integer := 12;
				  data_width : integer := 32 
	 );
    port ( CLK,EN : in  STD_LOGIC;
           ADDR : in  std_logic_vector(addr_width-1 downto 0);
           DATA : out  std_logic_vector(data_width-1 downto 0)
    );       
  end component;
	
	
	component reg is
		generic ( bit_width 		: natural := 32 );
		port ( clk,clear,load	: in std_logic;
				 data_in 			: in std_logic_vector(bit_width-1 downto 0);
             data_out 			: out std_logic_vector(bit_width-1 downto 0));
	end component;
	
	signal nextPC : std_logic_vector(31 downto 0);
	signal oldPC : std_logic_vector(31 downto 0);
	signal addr : std_logic_vector(11 downto 0);
  signal en : std_logic;
begin
	en <= '1';
	nextPC <= branchPC when (Branch='1') else
				 jumpPC when (jumpSelect='1') else (std_logic_vector(unsigned(oldPC) + 4));
	outPC <= std_logic_vector(unsigned(nextPC));
	PCreg : reg 
	generic map (bit_width => 32)
	port map(clk => Clk, clear => Reset , load => '1', 
				data_in => nextPC, data_out => oldPC);
				
		
	InstructionMemory : ROMv2 port map (CLK=>Clk, EN=>En, ADDR=>oldPC(11 downto 0), DATA=>Instruction);
	--InstructionMemory : rom
	--port map(clk => Clk, address => oldPC , q => Instruction);
	
end Behavioral;

