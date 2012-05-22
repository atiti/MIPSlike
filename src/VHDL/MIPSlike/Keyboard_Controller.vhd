library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Keyboard_Controller is
    Port ( PS2Clk : in  STD_LOGIC;
			  Reset : in STD_LOGIC;
           DataIn : in  STD_LOGIC;
			  Address : in std_logic_vector(1 downto 0);
			  DataOut : out STD_LOGIC_VECTOR(15 downto 0)
	  );
end Keyboard_Controller;

architecture Behavioral of Keyboard_Controller is
	signal data : STD_LOGIC_VECTOR (21 downto 0) := "1111111111111111111111";
	signal status, dout : std_logic_vector(15 downto 0);
	signal Counter,nCounter : STD_LOGIC_VECTOR (4 downto 0) := "00000";	
begin

	DataOut <= status when (Address = "00") else dout;

	process (PS2Clk,DataIn) begin
		if (falling_edge(PS2Clk)) then
			if Reset = '1' then
				dout <= (others => '0');
				status <= (others => '0');
			end if;

			data(21 downto 1) <= data(20 downto 0);
			data(0) <= DataIn;
			if (Counter = "10101") then
				dout <= data(20 downto 13) & data(9 downto 2);
				status <= X"0001";
			end if;
			if (Counter = "10101") then
				Counter <= "00000";
			else
				Counter <= Counter + 1;
			end if;
		end if;
	end process;
end Behavioral;