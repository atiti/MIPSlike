library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.yavga_pkg.all;

entity memoryAccess is
   port(cpuclk,memclk,Reset           : in std_logic;
        Zero : in std_logic;
        MemoryCTLin           : in std_logic_vector(2 downto 0);
        Address                       : in std_logic_vector(31 downto 0);
        WriteData                     : in std_logic_vector(31 downto 0);
        Branch                        : out std_logic;
        ReadData                      : out std_logic_vector(31 downto 0);
		  rxd					: in std_logic;
		  txd					: out std_logic;
		  VGA_RED,VGA_GREEN,VGA_BLUE,VGA_HSYNC,VGA_VSYNC : out std_logic;
		  PS2Clk : in  STD_LOGIC;
        PS2Data : in  STD_LOGIC
	);
end memoryAccess;

architecture Behavioral of memoryAccess is

	component dualport_async_ram is
         generic ( addr_width : integer := 13;
                   data_width : integer := 32
         );
 	   port ( clk : in  STD_LOGIC;
           we : in  STD_LOGIC;
           addr_a : in  std_logic_vector(addr_width-1 downto 0);
           addr_b : in  std_logic_vector(addr_width-1 downto 0);
           din_a : in  std_logic_vector(data_width-1 downto 0);
           dout_a : out  std_logic_vector(data_width-1 downto 0);
           dout_b : out  std_logic_vector(data_width-1 downto 0));
	end component;

   component sc_uart is
    generic (addr_bits : integer := 2;
	   clk_freq : integer := 50000000;
	   baud_rate : integer := 115200;
	   txf_depth : integer := 4; txf_thres : integer := 2;
	   rxf_depth : integer := 4; rxf_thres : integer := 2);
    port (
	   clk		: in std_logic;
	   reset	: in std_logic;

   	 address		: in std_logic_vector(addr_bits-1 downto 0);
	   wr_data		: in std_logic_vector(31 downto 0);
   	 rd, wr		: in std_logic;
	   rd_data		: out std_logic_vector(31 downto 0);
	   rdy_cnt		: out unsigned(1 downto 0);

	   txd		: out std_logic;
	   rxd		: in std_logic;
	   ncts	: in std_logic;
	   nrts	: out std_logic
    );
	end component;

--   component VGAcore is
--	generic ( addr_width : integer := 12;
--				  data_width : integer := 8
--	 );
--	port ( VGA_RED,VGA_GREEN,VGA_BLUE,VGA_HSYNC,VGA_VSYNC : out std_logic;
--			 clk,reset : in std_logic;
--			 addr : out std_logic_vector(addr_width-1 downto 0);
--			 dout : in std_logic_vector(data_width-1 downto 0)
--	);
--	end component;

  component vga_ctrl
    port(
      i_clk       : in  std_logic;
      i_reset     : in  std_logic;
      i_h_sync_en : in  std_logic;
      i_v_sync_en : in  std_logic;
      i_chr_addr  : in  std_logic_vector(c_CHR_ADDR_BUS_W - 1 downto 0);
      i_chr_data  : in  std_logic_vector(c_CHR_DATA_BUS_W - 1 downto 0);
      i_chr_clk   : in  std_logic;
      i_chr_en    : in  std_logic;
      i_chr_we    : in  std_logic_vector(c_CHR_WE_BUS_W - 1 downto 0);
      i_chr_rst   : in  std_logic;
      o_h_sync    : out std_logic;
      o_v_sync    : out std_logic;
      o_r         : out std_logic;
      o_g         : out std_logic;
      o_b         : out std_logic;
      o_chr_data  : out std_logic_vector(c_CHR_DATA_BUS_W - 1 downto 0)
      );
  end component;

  component Keyboard_Controller is
    Port ( PS2Clk : in  STD_LOGIC;
			  Reset : in STD_LOGIC;
           DataIn : in  STD_LOGIC;
			  Address : in std_logic_vector(1 downto 0);
			  DataOut : out STD_LOGIC_VECTOR(15 downto 0)
	  );
	end component;
	
  -- These signals need to be mapped to the fpga
  signal ncts,nrts,rd,wr,mem_we : std_logic := '0';
  signal rdy_cnt : unsigned(1 downto 0);
  signal rd_data : std_logic_vector(31 downto 0);
  -- END

	signal addra, addrb : std_logic_vector(12 downto 0);
	signal doutb,dataout : std_logic_vector(31 downto 0);
  signal mainmem_data : std_logic_vector(31 downto 0);
  signal kbd_data : std_logic_vector(15 downto 0);
  signal chip_select : std_logic_vector(0 to 1);
  signal vgaaddr : std_logic_vector(10 downto 0);
  signal vgain : std_logic_vector(7 downto 0);
  signal tmpvgaaddr : std_logic_vector(11 downto 0);
  signal vgadata : std_logic_vector(31 downto 0);
  signal vga_wen, tmp_wen : std_logic_vector(3 downto 0);  
  signal kbd_reset : std_logic;
begin
--  process(Address,chip_select,MemoryCTLin)
--    variable tmpcs : std_logic_vector(0 to 2);
--  begin 
--    if Address(14) = '1' then
--       tmpcs := "010";
--    else
--       tmpcs := "100";
--    end if;  
--    chip_select <= tmpcs;
--  end process;
  chip_select <= Address(15 downto 14);

  process(chip_select,rd_data,mainmem_data)
  begin
    case chip_select is
		  -- Main memory
		  when "00" =>
			dataout <= mainmem_data;
		  when "01" =>
			dataout <= rd_data;
		  when "11" =>
			dataout <= X"0000" & kbd_data;
      when others =>  dataout <= (others => '0');
    end case;
  end process;

  ReadData <= dataout;
  Branch <= Zero and MemoryCTLin(2);
  
  -- Main Memory - 0x0 - 0x1fff
	addrb <= (others => '0');
	addra <= "00" & Address(12 downto 2);
	mem_we <= '1' when (chip_select = "00" and MemoryCTLin(0) = '1') else '0';
	dpr1: dualport_async_ram port map(clk=>memclk,we=>mem_we,addr_a=>Address(12 downto 0),addr_b=>addrb,
					  din_a=>WriteData,dout_a=>mainmem_data,dout_b=>doutb);

  -- Serial memory - 0x2000 - 0x4000
  rd <= '1' when (chip_select = "01" AND MemoryCTLin(0) = '0') else '0';
  wr <= '1' when (chip_select = "01" AND MemoryCTLin(0) = '1') else '0';
  ser1: sc_uart port map (clk=>memclk,reset=>Reset,address=>Address(1 downto 0),wr_data=>WriteData,rd=>rd,wr=>wr,
          rd_data=>rd_data,rdy_cnt=>rdy_cnt,txd=>txd,rxd=>rxd,ncts=>ncts,nrts=>nrts);

  -- VGA memory - 0x4000 - 0x8000
  vgain <= doutb(7 downto 0);
  --vgaaddr <= "0" & tmpvgaaddr;
  
  vga_wen <= tmp_wen when (chip_select = "10" AND MemoryCTLin(0) = '1') else "0000";
  
  addrdecoder: process (Address)
  begin
	vgaaddr <= "0" & Address(13 downto 4);
	case Address(3 downto 2) is
			when "11" =>
				vgadata <= X"000000" & WriteData(7 downto 0);
				tmp_wen <= "1000";
			when "10" =>
				vgadata <= X"0000" & WriteData(7 downto 0) & X"00";
				tmp_wen <= "0100";
			when "01" =>
				vgadata <= X"00" & WriteData(7 downto 0) & X"0000";
				tmp_wen <= "0010";
			when "00" =>
				vgadata <= WriteData(7 downto 0) & X"000000";
				tmp_wen <= "0001";
			when others => 
				vgadata <= WriteData;
				tmp_wen <= "0000";
	end case;
  end process;
  
  
    u1_vga_ctrl : vga_ctrl port map(
    i_clk       => memclk,
    i_reset     => Reset,
    o_h_sync    => VGA_HSYNC,
    o_v_sync    => VGA_VSYNC,
    i_h_sync_en => '1',
    i_v_sync_en => '1',
    o_r         => VGA_RED,
    o_g         => VGA_GREEN,
    o_b         => VGA_BLUE,
    i_chr_addr  => vgaaddr,          --B"000_0000_0000",
    i_chr_data  => vgadata,          --X"00000000",
    o_chr_data  => open,
    i_chr_clk   => cpuclk,
    i_chr_en    => '1',
    i_chr_we    => vga_wen,
    i_chr_rst   => Reset
    );
 
  --vga1: VGAcore port map ( VGA_RED,VGA_GREEN,VGA_BLUE,VGA_HSYNC,VGA_VSYNC,
  --									clk=>memclk, reset=>Reset, addr=>tmpvgaaddr, dout => vgain);

	-- kbd
	kbd_reset <= '1' when (Reset = '1' OR Address(1) = '1') else '0';
	kbd1: Keyboard_Controller port map ( PS2Clk => PS2Clk, Reset => kbd_reset, 
													 DataIn => PS2Data, Address => Address(1 downto 0),
													 DataOut => kbd_data );


end Behavioral;

