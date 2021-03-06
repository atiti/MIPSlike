----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:46:25 03/07/2012 
-- Design Name: 
-- Module Name:    MIPSlike - Behavioral 
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

entity MIPSlike is
    Port ( Clk             : in std_logic;
	        Reset           : in std_logic;
			  rxd					: in std_logic;
			  txd					: out std_logic;
			  leds				: out std_logic_vector(0 to 7);
			  VGA_RED,VGA_GREEN,VGA_BLUE,VGA_HSYNC,VGA_VSYNC : out std_logic;
			  PS2Clk : in  STD_LOGIC;
           PS2Data : in  STD_LOGIC);
end MIPSlike;

architecture structure of MIPSlike is

	component reg
		generic ( bit_width 		: natural := 32 );
		port ( clk,clear,load	: in std_logic;
				 data_in 			: in std_logic_vector(bit_width-1 downto 0);
             data_out 			: out std_logic_vector(bit_width-1 downto 0));
	end component;

	component InstructionFetch
	
	port(Reset           : in std_logic;
		  Clk					: in std_logic;
		  Branch				: in std_logic;
		  jumpSelect		: in std_logic;
		  branchPC			: in std_logic_vector(31 downto 0);
		  jumpPC				: in std_logic_vector(31 downto 0);
		  outPC				: out std_logic_vector(31 downto 0);
		  Instruction    	: out std_logic_vector(31 downto 0));
		  
	end component;

	component InstructionDecode
	
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
		  
	end component;

	component Forwarding
	
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
		  
	end component;
	
	component Execute
	
   port(	Reset           	: in std_logic;
			Instruction			: in std_logic_vector(31 downto 0); 
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
		  
	end component;

	component MemoryAccess
	
   port(cpuclk,memclk             : in std_logic;
		  Reset           : in std_logic;
		  Zero            : in std_logic;
		  MemoryCTLin		: in std_logic_vector(2 downto 0);
		  Address			: in std_logic_vector(31 downto 0);
		  WriteData			: in std_logic_vector(31 downto 0);
		  Branch				: out std_logic;
		  ReadData	 		: out std_logic_vector(31 downto 0);
		  rxd					: in std_logic;
		  txd					: out std_logic;
		  VGA_RED,VGA_GREEN,VGA_BLUE,VGA_HSYNC,VGA_VSYNC : out std_logic;
		  PS2Clk : in  STD_LOGIC;
        PS2Data : in  STD_LOGIC);
		  
	end component;

	component WriteBack
	
   port(Reset           : in std_logic;
		  MemtoReg			: in std_logic;
		  ALUResult			: in std_logic_vector(31 downto 0);
		  ReadData			: in std_logic_vector(31 downto 0);
		  WriteData	 		: out std_logic_vector(31 downto 0));
		  
	end component;

	signal PCIF 				: std_logic_vector(31 downto 0);
	signal PCID 				: std_logic_vector(31 downto 0);
	signal PCEX 				: std_logic_vector(31 downto 0);
	signal InstructionIF 	: std_logic_vector(31 downto 0);
	signal InstructionID 	: std_logic_vector(31 downto 0);
	signal InstructionEX 	: std_logic_vector(31 downto 0);
	signal InstructionMEM 	: std_logic_vector(31 downto 0);
	signal InstructionWB 	: std_logic_vector(31 downto 0);
	signal WriteData			: std_logic_vector(31 downto 0);
	signal WriteRegister 	: std_logic_vector(4 downto 0);
	signal RegWrite			: std_logic;
	signal ExecuteCTLID		: std_logic_vector(3 downto 0);
	signal MemoryCTLID		: std_logic_vector(2 downto 0);
	signal WriteBackCTLID	: std_logic_vector(1 downto 0);
	signal ReadData1ID 		: std_logic_vector(31 downto 0);
	signal ReadData2ID		: std_logic_vector(31 downto 0);
	signal ImmediateID		: std_logic_vector(31 downto 0);
	signal InstructionRtID	: std_logic_vector(4 downto 0);
	signal InstructionRdID	: std_logic_vector(4 downto 0);
	signal ExecuteCTLEX		: std_logic_vector(3 downto 0);
	signal MemoryCTLEX		: std_logic_vector(2 downto 0);
	signal WriteBackCTLEX	: std_logic_vector(1 downto 0);
	signal ReadData1EX 		: std_logic_vector(31 downto 0);
	signal ReadData2EX		: std_logic_vector(31 downto 0);
	signal FwdOutA	 			: std_logic_vector(31 downto 0);
	signal FwdOutB	 			: std_logic_vector(31 downto 0);
	signal ImmediateEX		: std_logic_vector(31 downto 0);
	signal BranchAddrEX		: std_logic_vector(31 downto 0);
	signal InstructionRtEX	: std_logic_vector(4 downto 0);
	signal InstructionRdEX	: std_logic_vector(4 downto 0);
	signal ZeroEX				: std_logic;
	signal ALUResultEX		: std_logic_vector(31 downto 0);
	signal DestinationRegEX : std_logic_vector(4 downto 0);
	signal Branch				: std_logic;
	signal BranchAddrMEM		: std_logic_vector(31 downto 0);
	signal WriteDataMEM		: std_logic_vector(31 downto 0);
	signal MemoryCTLMEM		: std_logic_vector(2 downto 0);
	signal WriteBackCTLMEM	: std_logic_vector(1 downto 0);
	signal ZeroMEM				: std_logic;
	signal ALUResultMEM		: std_logic_vector(31 downto 0);
	signal DestinationRegMEM: std_logic_vector(4 downto 0);
	signal ReadDataMEM		: std_logic_vector(31 downto 0);
	signal MemtoReg			: std_logic;
	signal ALUResultWB		: std_logic_vector(31 downto 0);
	signal ReadDataWB			: std_logic_vector(31 downto 0);
	signal jumpSelect			: std_logic;
	signal jumpAddress		: std_logic_vector(31 downto 0);



	signal cpuclk, memclk : std_logic;
begin
-- Memory clock - 50 Mhz
memclk <= Clk;
-- Clock divider - 25 Mhz
cpuclkdiv: process (Clk,Reset)
begin
	if Reset = '1' then
		cpuclk <= '0';
	elsif rising_edge(Clk) then
		cpuclk <= not cpuclk;
	end if;
end process;

leds <= PCID(7 downto 0);

IFe : InstructionFetch
	port map ( Reset => Reset, Clk =>cpuclk, Branch => Branch,
				  jumpSelect => jumpSelect, branchPC => BranchAddrMEM,
				  jumpPC => jumpAddress, outPC => PCIF,
				  Instruction => InstructionIF);

IFRegID : reg 
	generic map (bit_width => 64)
	port map(clk => cpuclk, clear => Reset , load => '1', 
				data_in(63 downto 32)  => PCIF,
				data_in(31 downto 0)   => InstructionIF, 
				data_out(63 downto 32) => PCID,
				data_out(31 downto 0)  => InstructionID);

ID : InstructionDecode
	port map(Reset => Reset, Clk => cpuclk, RegWrite => RegWrite, WriteRegister => WriteRegister,
				WriteData => WriteData, Instruction => InstructionID, PCin => PCID,
				ExecuteCTL => ExecuteCTLID, MemoryCTL => MemoryCTLID, 
				WriteBackCTL => WriteBackCTLID, ReadData1	=> ReadData1ID,
				ReadData2 => ReadData2ID, Immediate	=>	ImmediateID,
				InstructionRt => InstructionRtID, InstructionRd => InstructionRdID);

IDIntructionRegEX : reg 
	generic map (bit_width => 32)
	port map(clk => cpuclk, clear => Reset , load => '1', 
				data_in => InstructionID, data_out => InstructionEX);

IDRegEX : reg 
	generic map (bit_width => 147)
	port map(clk => cpuclk, clear => Reset , load => '1', 
				data_in(146 downto 115) => PCID,
				data_in(114 downto 113) => WriteBackCTLID,
				data_in(112 downto 110) => MemoryCTLID,
				data_in(109 downto 106) => ExecuteCTLID,
				data_in(105 downto 74) 	=> ReadData1ID,
				data_in(73 downto 42) 	=> ReadData2ID,
				data_in(41 downto 10) 	=> ImmediateID,
				data_in(9 downto 5) 		=> InstructionRtID,
				data_in(4 downto 0)		=> InstructionRdID,
				data_out(146 downto 115)=> PCEX,
				data_out(114 downto 113)=> WriteBackCTLEX,
				data_out(112 downto 110)=> MemoryCTLEX,
				data_out(109 downto 106)=> ExecuteCTLEX,
				data_out(105 downto 74) => ReadData1EX,
				data_out(73 downto 42) 	=> ReadData2EX,
				data_out(41 downto 10) 	=> ImmediateEX,
				data_out(9 downto 5) 	=> InstructionRtEX,
				data_out(4 downto 0)		=> InstructionRdEX);

FWD : Forwarding
-- Change so that it does not read directly from Instruction register...
   port map(Reset => Reset, RegisterRs => InstructionEX(25 downto 21), 
				RegisterRt => InstructionRtEX, FwdDestRegMEM => DestinationRegMEM,
				FwdDestRegWB => WriteRegister, ReadDataA => ReadData1EX, 
				ReadDataB => ReadData2EX, FwdDatafromMEM => ALUResultMEM,
				FwdDatafromWB => WriteData, FwdRegWriteMEM => WriteBackCTLMEM(1),
				FwdRegWriteWB => RegWrite,
				DataA => FwdOutA, DataB => FwdOutB);

EX : Execute
	
   port map(Reset => Reset, Instruction => InstructionEX,
				ExecuteCTLin => ExecuteCTLEX,
				ReadData1 => FwdOutA, ReadData2 => FwdOutB,
				Immediate => ImmediateEX, PC => PCEX, InstructionRt => InstructionRtEX,
				InstructionRd => InstructionRdEX, PCjumpselect => jumpSelect, 
				PCjump => jumpAddress, Zero => ZeroEX,
				ALUResult => ALUResultEX, BranchAddress => BranchAddrEX,
				DestinationReg => DestinationRegEX);

EXIntructionRegMEM : reg 
	generic map (bit_width => 32)
	port map(clk => cpuclk, clear => Reset , load => '1', 
				data_in => InstructionEX, data_out => InstructionMEM);

EXRegMEM : reg 
	generic map (bit_width => 107)
	port map(clk => cpuclk, clear => Reset , load => '1', 
				data_in(106 downto 75) => BranchAddrEX,
				data_in(74 downto 73)  => WriteBackCTLEX,
				data_in(72 downto 70)  => MemoryCTLEX,
				data_in(69)				  => ZeroEX,
				data_in(68 downto 37)  => ALUResultEX,
				data_in(36 downto 5)	  => FwdOutB,
				data_in(4 downto 0)	  => DestinationRegEX,
				data_out(106 downto 75)=> BranchAddrMEM,
				data_out(74 downto 73) => WriteBackCTLMEM,
				data_out(72 downto 70) => MemoryCTLMEM,
				data_out(69)			  => ZeroMEM,
				data_out(68 downto 37) => ALUResultMEM,
				data_out(36 downto 5)  => WriteDataMEM,
				data_out(4 downto 0)	  => DestinationRegMEM);
				
MEM : MemoryAccess
	
   port map(cpuclk => cpuclk, memclk => memclk, Reset => Reset, Zero => ZeroMEM, MemoryCTLin => MemoryCTLMEM,
				Address => ALUResultMEM, WriteData => WriteDataMEM, Branch => Branch,
				ReadData => ReadDataMEM, rxd=>rxd, txd=>txd,
				VGA_RED=>VGA_RED,VGA_GREEN=>VGA_GREEN,VGA_BLUE=>VGA_BLUE,VGA_HSYNC=>VGA_HSYNC,VGA_VSYNC=>VGA_VSYNC,
				PS2Clk => PS2Clk, PS2Data => PS2Data);

MEMIntructionRegWB : reg 
	generic map (bit_width => 32)
	port map(clk => cpuclk, clear => Reset , load => '1', 
				data_in => InstructionMEM, data_out => InstructionWB);
				
MEMRegWB : reg
	generic map (bit_width => 71)
	port map(clk => cpuclk, clear => Reset , load => '1', 
				data_in(70 downto 69)  => WriteBackCTLMEM,
				data_in(68 downto 37)  => ReadDataMEM,
				data_in(36 downto 5)   => ALUResultMEM,
				data_in(4 downto 0)	  => DestinationRegMEM,
				data_out(70) 			  => RegWrite,
				data_out(69) 			  => MemtoReg,
				data_out(68 downto 37) => ReadDataWB,
				data_out(36 downto 5)  => ALUResultWB,
				data_out(4 downto 0)	  => WriteRegister);
				
WB : WriteBack

	port map(Reset => Reset, MemtoReg => MemtoReg, 
				ALUResult => ALUResultWB, ReadData => ReadDataWB,
				WriteData => WriteData);

end structure;

