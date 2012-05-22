library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_toplevel is
end tb_toplevel;
         
architecture Behavioral of tb_toplevel is
  component registerfile is
    Generic ( bit_width : integer := 32; -- bit width of the data lines
              num_regs : integer := 32 -- number of registers 
            );
    Port (read_reg1, read_reg2, write_reg : in std_logic_vector(4 downto 0);
          clk,reset,write_en : in std_logic;
          write_data : in std_logic_vector(bit_width-1 downto 0);
          read_data1, read_data2 : out std_logic_vector(bit_width-1 downto 0)
    );
  end component;


  signal clk,reset,load : std_logic;
  signal wd, rd1, rd2 : std_logic_vector(31 downto 0);
  
  constant time_clk : time := 5 ns;
  
begin
  clock_gen: process is
  begin
    wd <= (others => '0');
    reset <= '1';
    load <= '0';
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    reset <= '0';
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    load <= '1';
    wd <= (others => '0');
    wd(3 downto 1) <= "111";
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    load <= '0';
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    load <= '1';
    wd <= (others => '0');
    wd(3 downto 1) <= "001";
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    load <= '0';
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    load <= '1';
    wd <= (others => '0');
    wd(3 downto 1) <= "100";
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    load <= '0';
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
    clk <= '0' after time_clk, '1' after 2*time_clk;
    wait for 2*time_clk;
  end process clock_gen;
  
  regf: registerfile port map(read_reg1=>"00000",read_reg2=>"00010",write_reg=>"00010",
                              clk=>clk,reset=>reset,write_en=>load,write_data=>wd,
                            read_data1=>rd1,read_data2=>rd2);
                            
                            
                            
  
end Behavioral;

