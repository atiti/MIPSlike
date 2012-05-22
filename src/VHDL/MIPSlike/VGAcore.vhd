----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:31:24 04/10/2012 
-- Design Name: 
-- Module Name:    VGAcore - Behavioral 
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

entity VGAcore is
	generic ( addr_width : integer := 12;
				  data_width : integer := 8
	 );
	port ( VGA_RED,VGA_GREEN,VGA_BLUE,VGA_HSYNC,VGA_VSYNC : out std_logic;
			 clk,reset : in std_logic;
			 addr : out std_logic_vector(addr_width-1 downto 0);
			 dout : in std_logic_vector(data_width-1 downto 0)
	);
end VGAcore;

architecture Behavioral of VGAcore is
	component font_rom is
		port(
			clk: in std_logic;
			addr: in std_logic_vector(10 downto 0);
			data: out std_logic_vector(7 downto 0)
		);
	end component;

	component reg is
    generic ( bit_width : natural := 8 );
    port ( clk,clear,load : in std_logic;
           data_in : in std_logic_vector(bit_width-1 downto 0);
           data_out : out std_logic_vector(bit_width-1 downto 0)
    );
	end component;
         

	-- Vertical Sync
	constant VS_T_S : integer := 416800; -- Sync pulse time
	constant VS_T_DISP : integer := 384000; -- Display time
	constant VS_T_PW : integer := 1600; -- Pulse width
	constant VS_T_FP : integer := 8000; -- Front porch
	constant VS_T_BP : integer := 23200;-- Back porch
	-- Horisontal sync
	constant HS_T_S : integer := 800;
	constant HS_T_DISP : integer := 640;
	constant HS_T_PW : integer := 96;
	constant HS_T_FP : integer := 16;
	constant HS_T_BP : integer := 48;

	-- Constants for console
	constant CONS_W : integer := 80;
	constant CONS_H : integer := 30;
	constant CHAR_W : integer := 8; -- HS_T_DISP / CONS_W
	constant CHAR_H : integer := 16; --(VS_T_DISP / CONST_H);

	signal fr_addr : std_logic_vector(10 downto 0);
	signal fr_data,s2data,s3data,s4data,s2datac,s3datac,s4datac : std_logic_vector(7 downto 0);
	signal clkdiv,hsync,vsync,red,green,blue : std_logic;
	signal hcount,vcount,pcount : integer;
	signal curchar_x, curchar_y, pxlcnt_w, pxlcnt_h : integer; 
begin

	fr1: font_rom port map(clk=>clk,addr=>fr_addr,data=>fr_data);
	regs1_d: reg port map(clk=>clkdiv,clear=>reset,load=>'1',data_in=>dout,data_out=>s2data);
	regs2_d: reg port map(clk=>clkdiv,clear=>reset,load=>'1',data_in=>s2data,data_out=>s3data);
	regs3_d: reg port map(clk=>clkdiv,clear=>reset,load=>'1',data_in=>s3data,data_out=>s4data);
	regs1_c: reg port map(clk=>clkdiv,clear=>reset,load=>'1',data_in=>fr_data,data_out=>s2datac);
	regs2_c: reg port map(clk=>clkdiv,clear=>reset,load=>'1',data_in=>s2datac,data_out=>s3datac);
	regs3_c: reg port map(clk=>clkdiv,clear=>reset,load=>'1',data_in=>s3datac,data_out=>s4datac);

	clock_div: process(clk,reset)
	begin
	  if reset = '1' then
	     clkdiv <= '0';
		elsif rising_edge(clk) then
			clkdiv <= not clkdiv;
		end if;
	end process;

	hsync_counter: process(clkdiv,reset)
	begin
	  if reset = '1' then
	     hcount <= 0;
	     hsync <= '0';
	  elsif clkdiv'event and clkdiv = '1' then
       if hcount = (HS_T_S - 1) then
		    hcount <= 0;
		   elsif hcount < HS_T_PW then
			  hsync <= '0';
			  hcount <= hcount + 1;
		   elsif hcount < (HS_T_PW + HS_T_BP) then
			  hsync <= '1';
			  hcount <= hcount + 1;
		   elsif hcount > (HS_T_S - HS_T_FP - 1) then
			  hsync <= '1';
			  hcount <= hcount + 1;
		   else
			  hsync <= '1';
			  hcount <= hcount + 1;
		   end if;
    end if;
	end process;

	vsync_counter: process(clkdiv,reset,vcount)
	begin
	  if reset = '1' then
	    vsync <= '0';
	    vcount <= 0;
	  elsif clkdiv'event and clkdiv = '1' then
	    if vcount = (VS_T_S - 1) then
			 vcount <= 0;
		  elsif vcount < VS_T_PW then
			 vsync <= '0';
			 vcount <= vcount + 1;
		  elsif vcount < (VS_T_PW + VS_T_BP) then
			 vsync <= '1';
			 vcount <= vcount + 1;
		  elsif vcount > (VS_T_S - VS_T_FP) then
			 vsync <= '1';
			 vcount <= vcount + 1;
		  else
			 vsync <= '1';
		   vcount <= vcount + 1;
		  end if;		  
		 end if;
	end process;
	
	data_show: process (clkdiv,reset,hcount,vcount,curchar_x,curchar_y,pxlcnt_w,pxlcnt_h)
		variable intaddr : integer := 0;
	begin
	  if reset = '1' then
	    red <= '0';
	    green <= '1';
	    blue <= '0';
	    pcount <= 0;
		 curchar_x <= 0;
		 curchar_y <= 0;
		 pxlcnt_w <= 0;
		 pxlcnt_h <= 0;
	  elsif clkdiv'event and  clkdiv = '1' then
		  if hcount > (HS_T_PW+HS_T_BP-3) and hcount < (HS_T_S-HS_T_FP) and vcount > (VS_T_PW+VS_T_BP) and vcount < (VS_T_S-VS_T_FP) then
			if hcount > (HS_T_PW+HS_T_BP) then
				if pxlcnt_w >= (CHAR_W-1) then
					pxlcnt_w <= 0;
					curchar_x <= curchar_x + 1;
				else
					pxlcnt_w <= pxlcnt_w + 1;
				end if;
		
				if s4datac(7-pxlcnt_w) = '1' then
					red <= '1';
					green <= '0';
					blue <= '0';
				else
					red <= '1';
					green <= '1';
					blue <= '1';
				end if;
			end if;
			
			--addr <= std_logic_vector(to_unsigned(curchar_y+curchar_x, 11));
			intaddr := curchar_y+curchar_x;
			addr <= std_logic_vector(to_unsigned(intaddr,11));
			fr_addr <= s4data(6 downto 0) & std_logic_vector(to_unsigned(pxlcnt_h, 4));
		
		
		  elsif hcount = (HS_T_S - HS_T_FP) then
			if pxlcnt_h >= (CHAR_H-1) then
				pxlcnt_h <= 0;
				curchar_y <= curchar_y + (CONS_W);
			else
				pxlcnt_h <= pxlcnt_h + 1;
			end if;
			curchar_x <= 0;
			pxlcnt_w <= 0;
		  elsif vcount > (VS_T_S - VS_T_FP) then
			curchar_x <= 0;
			curchar_y <= 0;
			pxlcnt_w <= 0;
			pxlcnt_h <= 0;
		  else
			 red <= '0';
			 green <= '0';
			 blue <= '0';
		  end if;
	   end if;
	end process;
	
	VGA_HSYNC <= hsync;
	VGA_VSYNC <= vsync;
	
	VGA_RED <= red;
	VGA_GREEN <= green;
	VGA_BLUE <= blue;
	
end Behavioral;

