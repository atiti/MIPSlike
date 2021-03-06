----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:23:40 03/31/2012 
-- Design Name: 
-- Module Name:    Execute - Behavioral 
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

entity Execute is
    Port ( 	Reset     		   : in std_logic;
				Instruction			: in std_logic_vector(31 downto 0); -- This will hopefully be removed in the end
				ExecuteCTLin		: in std_logic_vector(3 downto 0);
				ReadData1			: in std_logic_vector(31 downto 0);
				ReadData2			: in std_logic_vector(31 downto 0);
				Immediate			: in std_logic_vector(31 downto 0);
				PC						: in std_logic_vector(31 downto 0);
				InstructionRt		: in std_logic_vector(4 downto 0);
				InstructionRd		: in std_logic_vector(4 downto 0);
				PCjumpselect		: out std_logic;
				PCjump				: out std_logic_vector(31 downto 0);
				Zero					: out std_logic;
				ALUResult 			: out std_logic_vector(31 downto 0);
				BranchAddress		: out std_logic_vector(31 downto 0);
				DestinationReg		: out std_logic_vector(4 downto 0));
end Execute;

architecture Behavioral of Execute is

Signal ALUInput1 : std_logic_vector(31 downto 0);
Signal ALUInput2 : std_logic_vector(31 downto 0);
Signal ALUSrc	  : std_logic;
Signal ALUOp	  : std_logic_vector(1 downto 0);
Signal RegDst	  : std_logic;
Signal TMPALUResult : std_logic_vector(31 downto 0);
Signal shamt	  : integer range 0 to 31 := 0;
--Signal Funct	  : std_logic_vector(5 downto 0);

begin
	ALUSrc 	 		<= ExecuteCTLin(0);
	ALUOp 	 		<= ExecuteCTLin(2 downto 1);
	RegDst	 		<= ExecuteCTLin(3);
	ALUInput1 		<= ReadData1;
	ALUInput2 		<= ReadData2 when (ALUSrc='0') else Immediate;
	DestinationReg <= InstructionRt when (RegDst='0') else InstructionRd;
	BranchAddress  <= std_logic_vector(signed(PC) + signed(Immediate(29 downto 0) & "00"));
	Zero				<= '1' when (signed(TMPALUResult) = 0) else '0';
	-- handling 'jr':
	PCjump 			<= ReadData1 when ((Instruction(31 downto 26) & Instruction(5 downto 0))="000000001000") else
							PC(31 downto 28) & Instruction(25 downto 0) & "00";
	shamt				<= to_integer(unsigned(Instruction(10 downto 6)));
	
	Process (Instruction,ALUInput1,ALUInput2)
	begin
		case Instruction(31 downto 26) is
			-- R-type instruction (Opcode 0) - Read function
			when "000000" =>
				case Instruction(5 downto 0) is
					-- sll
					when "000000" => 
						TMPALUResult <= std_logic_vector(unsigned(ALUInput2) sll shamt);
						PCjumpselect <= '0';
					-- srl
					when "000010" => 
						TMPALUResult <= std_logic_vector(unsigned(ALUInput2) srl shamt);
						PCjumpselect <= '0';
					-- sra
--					when "000011" => TMPALUResult <= ALUInput2 sra integer(Instruction(10 downto 6));
					-- sllv
--					when "000100" => TMPALUResult <= ALUInput2 sll integer(ALUInput1(4 downto 0));
					-- srlv
--					when "000110" => TMPALUResult <= ALUInput2 srl integer(ALUInput1(4 downto 0));
					-- srav
--					when "000111" => TMPALUResult <= ALUInput2 sra integer(ALUInput1(4 downto 0));
					-- jr
					when "001000" => 
						TMPALUResult <= ALUInput1;
						PCjumpselect <= '1';
					-- jalr
--					when "001000" => TMPALUResult <= ALUInput1;
					-- movz "001010"
					-- movn "001011"
					-- syscall "001100"
					-- break "001101"
					-- sync "001111"

					-- mfhi
--					when "010000" => TMPALUResult <= ALUInput1;
					-- mthi "010000"

					-- mflo
--					when "010000" => TMPALUResult <= ALUInput1;
					-- mtlo "010000"				
					-- mult "011000" (Needs to write to hi and lo...)
					-- multu "011001" (Needs to write to hi and lo...)
					-- div "011010" (Needs to write to hi and lo...)
					-- divu "011011" (Needs to write to hi and lo...)
					
					-- add
					when "100000" => 
						TMPALUResult <= std_logic_vector(signed(ALUInput1) + signed(ALUInput2));
						PCjumpselect <= '0';

					-- addu
					when "100001" => 
						TMPALUResult <= std_logic_vector(unsigned(ALUInput1) + unsigned(ALUInput2));
						PCjumpselect <= '0';
					-- sub
					when "100010" => 
						TMPALUResult <= std_logic_vector(signed(ALUInput1) - signed(ALUInput2));
						PCjumpselect <= '0';
					-- subu
					when "100011" => 
						TMPALUResult <= std_logic_vector(unsigned(ALUInput1) - unsigned(ALUInput2));
						PCjumpselect <= '0';
					-- and 
					when "100100" => 
						TMPALUResult <= ALUInput1 and ALUInput2;
						PCjumpselect <= '0';
					-- or 
					when "100101" => 
						TMPALUResult <= ALUInput1 or ALUInput2;
						PCjumpselect <= '0';
					-- xor 
					when "100110" => 
						TMPALUResult <= ALUInput1 xor ALUInput2;
						PCjumpselect <= '0';
					-- nor 
					when "100111" => 
						TMPALUResult <= ALUInput1 nor ALUInput2;
						PCjumpselect <= '0';
					-- slt
					when "101010" =>
						if (signed(ALUInput1) < signed(ALUInput2)) then
							TMPALUResult <= X"00000001"; 
						else
							TMPALUResult <= X"00000000";
						end if;
						PCjumpselect <= '0';
					-- sltu
					when "101011" =>
						if (unsigned(ALUInput1) < unsigned(ALUInput2)) then
							TMPALUResult <= X"00000001"; 
						else
							TMPALUResult <= X"00000000";
						end if;
						PCjumpselect <= '0';
					when others => 
						TMPALUResult <= (others => '0');
						PCjumpselect <= '0';
				end case;

			-- J-type instructions
			-- j
			when "000010" =>
			   TMPALUResult <= X"00000001";
				PCjumpselect <= '1';
			-- jal
			when "000011" =>
			   TMPALUResult <= X"00000001";
				PCjumpselect <= '1';

			-- I-type instructions
			-- beq
			when "000100" =>
			   TMPALUResult <= std_logic_vector(signed(ALUInput1) - signed(ALUInput2));
				PCjumpselect <= '0';
			-- bne
			when "000101" =>
			   if (signed(ALUInput1) /= signed(ALUInput2)) then
					TMPALUResult <= X"00000000";
			   else
					TMPALUResult <= X"00000001";
			   end if;
				PCjumpselect <= '0';
			-- addi
			when "001000" =>
				TMPALUResult <= std_logic_vector(signed(ALUInput1) + signed(ALUInput2));
				PCjumpselect <= '0';
			-- addiu
			when "001001" =>
				TMPALUResult <= std_logic_vector(unsigned(ALUInput1) + unsigned(ALUInput2));
				PCjumpselect <= '0';
			-- andi
			when "001100" =>
				TMPALUResult <= ALUInput1 and ALUInput2;
				PCjumpselect <= '0';
			-- ori
			when "001101" =>
				TMPALUResult <= ALUInput1 or ALUInput2;
				PCjumpselect <= '0';
			-- xori
			when "001110" =>
				TMPALUResult <= ALUInput1 xor ALUInput2;
				PCjumpselect <= '0';			
			-- slti
			when "001010" =>
				if (signed(ALUInput1) < signed(ALUInput2)) then
					TMPALUResult <= X"00000001"; 
				else
					TMPALUResult <= X"00000000";
				end if;
				PCjumpselect <= '0';
			-- sltiu
			when "001011" =>
				if (unsigned(ALUInput1) < unsigned(ALUInput2)) then
					TMPALUResult <= X"00000001"; 
				else
					TMPALUResult <= X"00000000";
				end if;
				PCjumpselect <= '0';
			-- lw
			-- TODO: Should these be unsigned???
			when "100011" =>
				TMPALUResult <= std_logic_vector(signed(ALUInput1) + signed(ALUInput2));
				PCjumpselect <= '0';
			-- sw
			when "101011" =>
				TMPALUResult <= std_logic_vector(signed(ALUInput1) + signed(ALUInput2));
				PCjumpselect <= '0';
				
			when others => null;
    end case;
	end process;
	
	ALUResult <= TMPALUResult;
end Behavioral;

