LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity processing_module_tb is
end processing_module_tb;


-- ARCHITECTURE BLOCK --
architecture Behavioral of processing_module_tb is

--Signal declarations
signal S_CLK : std_logic :='0';
-- Initialize according to first case you want to test
signal S_IL : std_logic_vector(7 downto 0) := "00000000";
signal S_IR : std_logic_vector(7 downto 0) := "00000011";
signal S_RS : std_logic_vector(7 downto 0);
signal S_RB : std_logic_vector(7 downto 0);
constant CLK_period : time := 1 ns;


-- Component declarations
component processing_module port (
	IL : in std_logic_vector(7 downto 0); 
	IR : in std_logic_vector(7 downto 0);
	RS : out std_logic_vector(7 downto 0); 
	RB : out std_logic_vector(7 downto 0);
	CLK : in std_logic
);
end component;



-- functional code
begin
	uut: processing_module port map ( S_IL, S_IR, S_RS, S_RB, S_CLK ); 
	
	CLK_process : process
	begin
		S_CLK <= '0';
		wait for CLK_period/2;  --for 0.5 ns signal is '0'.
		S_CLK <= '1';
		wait for CLK_period/2;  --for next 0.5 ns signal is '1'.
	end process;

	process(S_CLK)
	variable count : integer := 1;
    begin
        if (rising_edge(S_CLK)) then
            count := count + 1;
        end if;
        if (falling_edge(S_CLK)) then
            --Here, insert for next cases
            if (count = 2)  then -- case 3
                S_IL <= "00000001"; S_IR <= "00000011";
            elsif (count = 3) then -- case 2
                S_IL <= "00000001"; S_IR <= "00000010";
            elsif (count = 4) then -- case 3
                S_IL <= "00000111"; S_IR <= "00001111";
            elsif (count = 5) then -- case 4
                S_IL <= "00000000"; S_IR <= "00000011";
            elsif (count = 6) then -- case 5
                S_IL <= "00000001"; S_IR <= "00000000";
            elsif (count = 7) then -- case 3
                S_IL <= "00011100"; S_IR <= "00000001";
            elsif (count = 8) then -- case 6
                S_IL <= "00000111"; S_IR <= "00001111"; 
            elsif (count = 9) then -- case 7
                S_IL <= "00011111"; S_IR <= "00000111";  
            elsif (count > 10) then -- last
                S_IL <= "00011100"; S_IR <= "00000001"; 
            end if;
		end if;
	end process;

end Behavioral;