library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dualport_async_ram is
	 generic ( addr_width : integer := 5;
				  data_width : integer := 8 
	 );
    port ( clk : in  STD_LOGIC;
           we : in  STD_LOGIC;
           addr_a : in  std_logic_vector(addr_width-1 downto 0);
           addr_b : in  std_logic_vector(addr_width-1 downto 0);
           din_a : in  std_logic_vector(data_width-1 downto 0);
           dout_a : out  std_logic_vector(data_width-1 downto 0);
           dout_b : out  std_logic_vector(data_width-1 downto 0));
end dualport_async_ram;

architecture Behavioral of dualport_async_ram is
	type ram_type is array (0 to 2**addr_width-1) of std_logic_vector(data_width-1 downto 0);
	signal ram : ram_type;
begin
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if (we = '1') then
				ram(to_integer(unsigned(addr_a))) <= din_a;
			end if;
			dout_a <= ram(to_integer(unsigned(addr_a)));
	      dout_b <= ram(to_integer(unsigned(addr_b)));
		end if;
	end process;
end Behavioral;

