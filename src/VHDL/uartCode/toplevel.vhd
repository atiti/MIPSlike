library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity toplevel is
    port ( clk : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  rxd : in STD_LOGIC;
			  txd : out STD_LOGIC;
           leds : out std_logic_vector(3 downto 0));
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
   	constant ASCII_ZERO : std_logic_vector(7 downto 0) := "00110000"; -- 0 in ASCII 
   	constant ASCII_ONE : std_logic_vector(7 downto 0) := "00110001"; -- 1 in ASCII


	type implementation_type is (simple, zero_to_nine, uart_input);
	----- SELECTING BEHAVIOUR
	-- 1. simple : Blink led
	-- 2. zero_to_nine : Count up from 0 to 9 at the maximum baud rate
	-- 3. uart_input : Turn a LED on and off by typing 0 or 1 in the serial console
	constant implementation : implementation_type := uart_input;  -- change this to select task
	type statetype is (poll, looprdy, sendinc, readchar, toggle); -- states
	signal state          : statetype := poll;
	signal next_state      : statetype;

	signal saved_state    : statetype;
	signal to_saved_state : statetype;    -- input to register

	signal cnt      : integer; --unsigned(32 downto 0);
	signal blink    : std_logic;
	signal address	 : std_logic_vector(0 downto 0);
	signal wr_data,rd_data : std_logic_vector(31 downto 0);
	signal rd, wr	 : std_logic;
	signal ncts, nrts : std_logic;
	signal rdy_cnt	 : unsigned(1 downto 0);
	signal cntadd	: integer := 48;
begin
	ncts <= '0';
	nrts <= '0';
	sc_uart1: sc_uart port map(clk=>clk, reset=>reset, address=>address, wr_data=>wr_data, rd=>rd, wr=>wr, rd_data=>rd_data, rdy_cnt=>rdy_cnt, txd=>txd, rxd=>rxd, ncts=>ncts, nrts=>nrts);

	-- Simple blink implementation
	sa: if implementation = simple generate
		process(clk)
		begin
			address <= "1"; -- write address
			wr_data <= X"000000" & "0011000" & blink;
			leds <= "000" & blink;
			if rising_edge(clk) then
				if cnt = CNT_MAX then
					cnt <= 0;
					blink <= not blink;
					wr <= '1';
				else
					wr <= '0';
					cnt <= cnt + 1;
				end if;
			end if;
		end process;
	end generate sa;
	
	-- Counting from 0-to-9 implementation
	sb: if implementation = zero_to_nine generate
		a: process(clk) is
		begin
			if rising_edge(clk) then
				state <= next_state;
				saved_state <= to_saved_state;
				if cnt + cntadd = 10 then
					cnt <= 0;
				else
					cnt <= cnt + cntadd;
				end if;
			end if;
		end process a;
		
		b: process(cnt, rd_data(0), rdy_cnt, saved_state, state) is
		begin
			rd <= '0';
			wr <= '0';
			wr_data <= X"00000000";
			cntadd <= 0;
			address <= "0";
			leds <= "1010";
			to_saved_state <= saved_state;
			case state is
				when poll =>
					rd <= '1';
					to_saved_state <= sendinc;
					next_state <= looprdy;
				when looprdy =>
					if rdy_cnt < 1 then
						next_state <= saved_state;
					else
						next_state <= looprdy;
					end if;
				when sendinc =>
					if rd_data(0) = '1' then
						wr <= '1';
						address <= "1";
						wr_data <= std_logic_vector(unsigned(ASCII_ZERO) + cnt);
						cntadd <= 1;
						next_state <= looprdy;
						to_saved_state <= poll;
					end if;
					next_state <= poll;
				when others => null;
			end case;
		end process b;
	end generate sb;
	
	-- UART led toggler
	sc: if implementation = uart_input generate
		sequential: process(clk) is
		begin
			if rising_edge(clk) then
				state <= next_state;
				saved_state <= to_saved_state;
			end if;
		end process sequential;
		
		combinatorical: process(rd_data, rdy_cnt, saved_state, state) is
		begin
			rd <= '0';
			wr <= '0';
			wr_data <= X"00000000";
			cntadd <= 0;
			address <= "0";
			leds <= "0001";
			to_saved_state <= saved_state;
			case state is
				when poll =>
					rd <= '1';
					address <= "0";
					to_saved_state <= readchar;
					next_state <= looprdy;
				when readchar =>
					if rd_data(1) = '1' then -- there is some data in the receive buffer
						rd <= '1';
						address <= "1";
						to_saved_state <= toggle;
						next_state <= looprdy;
					else
						next_state <= poll;
					end if;
				when toggle =>
					if rd_data = ASCII_ZERO then
						leds <= "0010";
					elsif rd_data = ASCII_ONE then
						leds <= "0100";
					end if;
					next_state <= poll;
				when looprdy =>
					if rdy_cnt < 1 then
						next_state <= saved_state;
					else
						next_state <= looprdy;
					end if;
				when others => null;
			end case;
		end process combinatorical;
	end generate sc;
	
end rtl;

