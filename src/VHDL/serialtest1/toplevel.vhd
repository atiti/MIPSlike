----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:07:55 03/02/2012 
-- Design Name: 
-- Module Name:    toplevel - Behavioral 
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


entity toplevel is
    port ( clk : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  rxd : in STD_LOGIC;
			  txd : out STD_LOGIC;
           led : out  STD_LOGIC);
end toplevel;

architecture rtl of toplevel is
	component sc_uart
		generic (addr_bits : integer := 1;
			clk_freq : integer := 50000000;
			baud_rate : integer := 115200;
			txf_depth : integer := 4; txf_thres : integer := 2;
			rxf_depth : integer := 4; rxf_thres : integer := 2);
		port (
			clk		: in std_logic;
			reset	: in std_logic;
			-- SimpCon interface
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

   constant CLK_FREQ : integer := 50000000;
   constant BLINK_FREQ : integer := 1;
   constant CNT_MAX : integer := CLK_FREQ/BLINK_FREQ/2-1;

   signal cnt      : integer; --unsigned(32 downto 0);
   signal blink    : std_logic;
	signal address	 : std_logic_vector(0 downto 0);
	signal wr_data,rd_data : std_logic_vector(31 downto 0);
	signal rd, wr	 : std_logic;
	signal ncts, nrts : std_logic;
	signal rdy_cnt	 : unsigned(1 downto 0);
	signal cnt2		 : integer := 48;

begin
	ncts <= '0';
	nrts <= '0';
	sc_uart1: sc_uart port map(clk=>clk, reset=>reset, address=>address, wr_data=>wr_data, rd=>rd, wr=>wr, rd_data=>rd_data, rdy_cnt=>rdy_cnt, txd=>txd, rxd=>rxd, ncts=>ncts, nrts=>nrts);
   process(clk)
   begin
		if rising_edge(clk) then
			if cnt = CNT_MAX then
				blink <= not blink;
				--if blink = '1' then
				--	wr_data <= X"00000030";
				--else
				--	wr_data <= X"00000031";
				--end if;
				if cnt2 < 58 then
					wr_data <= std_logic_vector(to_unsigned(cnt2, 32));
					cnt2 <= cnt2 + 1;
				else
					cnt2 <= 48;
					wr_data <= X"0000000A";
				end if;
					
				wr <= '1';
				address <= "1";
				cnt <= 0;
			else
				cnt <= cnt + 1;
				rd <= '0';
				wr <= '0';
				address <= "0";
				wr_data <= X"00000000";
			end if;
				
--			if rdy_cnt = 0 then
--				if cnt < 58 then
--					blink <= not blink;
--					address <= "1";
--					wr_data <= std_logic_vector(to_unsigned(cnt,32));
--					--if blink = '1' then
--					--	wr_data <= X"00000030";
--					-- else
--					--	wr_data <= X"00000031";
--					-- end if;
--					wr <= '1';
--					cnt <= cnt + 1;
--				else -- Reset counter and send a new line
--					cnt <= 48;
--					address <= "1";
--					wr_data <= X"00000010";
--					wr <= '1';
--				end if;
--			else
--				rd <= '0';
--				wr <= '0';
--				address <= "0";
--				wr_data <= X"00000000";
--         end if;
      end if;
   end process;
   led <= blink;
end rtl;

