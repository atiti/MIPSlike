----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:12:59 04/16/2012 
-- Design Name: 
-- Module Name:    instructionDecode - Behavioral 
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

entity instructionDecode is
   port(Reset           : in std_logic;
		  Clk 				: in std_logic;
		  RegWrite        : in std_logic;
		  WriteRegister   : in std_logic_vector(4 downto 0);
		  WriteData		   : in std_logic_vector(31 downto 0);
		  Instruction     : in std_logic_vector(31 downto 0);
		  PCin				: in std_logic_vector(31 downto 0);
		  ExecuteCTL		: out std_logic_vector(3 downto 0);
		  MemoryCTL			: out std_logic_vector(2 downto 0);
		  WriteBackCTL		: out std_logic_vector(1 downto 0);
		  ReadData1			: out std_logic_vector(31 downto 0);
		  ReadData2			: out std_logic_vector(31 downto 0);
		  Immediate			: out std_logic_vector(31 downto 0);
		  InstructionRt	: out std_logic_vector(4 downto 0);
		  InstructionRd	: out std_logic_vector(4 downto 0));
end instructionDecode;

architecture Behavioral of instructionDecode is
  component registerfile is
    Generic ( bit_width : integer := 32; -- bit width of the data lines
              num_regs : integer := 32 -- number of registers 
            );
    Port (read_reg1, read_reg2, write_reg : in std_logic_vector(4 downto 0);
          clk,reset,write_en,write_en2 : in std_logic;
          write_data, write_data2 : in std_logic_vector(bit_width-1 downto 0);
          read_data1, read_data2 : out std_logic_vector(bit_width-1 downto 0)
    );
  end component;
  signal rs, rt : std_logic_vector(4 downto 0);
	signal WriteData2 : std_logic_vector(31 downto 0);
	signal RegWrite2 : std_logic;
	signal Data1, Data2 :  std_logic_vector(31 downto 0);
  
begin
-- jal (opcode "000011")
RegWrite2 <= '1' when (Instruction(31 downto 26)="000011") else '0';
WriteData2 <= PCin when (Instruction(31 downto 26)="000011") else (others => '0');

regf: registerfile port map(read_reg1=>rs,read_reg2=>rt,write_reg=>WriteRegister,
			    clk=>Clk,reset=>Reset,write_en=>RegWrite,write_en2=>RegWrite2, write_data=>WriteData,write_data2=>WriteData2,
			    read_data1=>Data1,read_data2=>Data2);

rs <= Instruction(25 downto 21);
rt <= Instruction(20 downto 16);
InstructionRd <= Instruction(15 downto 11);
InstructionRt <= Instruction(20 downto 16);
Immediate <= std_logic_vector(RESIZE(signed(Instruction(15 downto 0)),32));
ReadData1 <= WriteData when (rs = WriteRegister and RegWrite = '1' and rs /= "00000") else
				 WriteData2 when (rs = "11111" and RegWrite2 = '1') else Data1;
ReadData2 <= WriteData when (rt = WriteRegister and RegWrite = '1' and rt /= "00000") else
				 WriteData2 when (rt = "11111" and RegWrite2 = '1') else Data2;
--std_logic_vector(resize(signed(Instruction(15 downto 0)), Immediate'length));

process (Instruction)
begin
	case Instruction(31 downto 26) is
		-- R-type instruction
		when "000000" =>
			MemoryCTL		<= "000";
			WriteBackCTL	<= "10";
			ExecuteCTL <= "1100";
			
--			case Instruction(5 downto 0) is
--				-- sll
--				when "000000"=>
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- srl
--				when "000010"=>
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- jr
--				when "001000" => 
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- add
--				when "100000" => 
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- addu
--				when "100001" => 
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- sub
--				when "100010" => 
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- subu
--				when "100011" => 
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- and 
--				when "100100" => 
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- or 
--				when "100101" => 
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- xor 
--				when "100110" => 
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- nor 
--				when "100111" => 
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- slt
--				when "101010" =>
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				-- sltu
--				when "101011" =>
--					WriteBackCTL	<= "10";
--					ExecuteCTL <= "1100";
--				when others => 
--					WriteBackCTL	<= "10";
--					ExecuteCTL <="1100";
--			end case;
		
		-- I-type instructions
		
		-- beq
		when "000100" =>
			WriteBackCTL	<= "00";
			MemoryCTL		<= "100";
			ExecuteCTL 		<= "0000";
		-- bne
		when "000101" =>
			WriteBackCTL	<= "00";
			MemoryCTL		<= "100";
			ExecuteCTL 		<= "0000";
		-- addi
		when "001000" =>
			WriteBackCTL	<= "10";
			MemoryCTL		<= "000";
			ExecuteCTL 		<= "0101";
		-- andi
		when "001100" =>
			WriteBackCTL	<= "10";
			MemoryCTL		<= "000";
			ExecuteCTL 		<= "0101";
		-- ori
		when "001101" =>
			WriteBackCTL	<= "10";
			MemoryCTL		<= "000";
			ExecuteCTL 		<= "0101";
		-- xori
		when "001110" =>
			WriteBackCTL	<= "10";
			MemoryCTL		<= "000";
			ExecuteCTL 		<= "0101";			
		-- slti
		when "001010" =>
			WriteBackCTL	<= "10";
			MemoryCTL		<= "000";
			ExecuteCTL 		<= "0101";
		-- sltiu
		when "001011" =>
			WriteBackCTL	<= "10";
			MemoryCTL		<= "000";
			ExecuteCTL 		<= "0101";
		-- lw
		when "100011" =>
			WriteBackCTL	<= "11";
			MemoryCTL		<= "010";
			ExecuteCTL 		<= "0101";
		-- sw
		when "101011" =>
			WriteBackCTL	<= "00";
			MemoryCTL		<= "001";
			ExecuteCTL		<= "0101";

		-- J-type instructions (Check if the CTL signals are correct!)
		
		-- j
		when "000010" =>
			WriteBackCTL	<= "00";
			MemoryCTL		<= "010";
			ExecuteCTL 		<= "0001";

		-- jal
		when "000011" =>
			WriteBackCTL	<= "00";
			MemoryCTL		<= "010";
			ExecuteCTL 		<= "0001";
		
		
		
		when others =>
			WriteBackCTL	<= "00";
			MemoryCTL		<= "000";
			ExecuteCTL 		<= "0000";

	end case;

end process;


end Behavioral;

