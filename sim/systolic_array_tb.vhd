LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.merge_sorter_pkg.all;

-- ENTITY BLOCK --
entity systolic_array_tb is
end systolic_array_tb;


-- ARCHITECTURE BLOCK --
architecture Behavioral of systolic_array_tb is

--Signal declarations
signal S_CLK : std_logic := '0';
-- Initialize according to first case you want to test
signal S_HEAD_IN : std_logic_vector(DATA_SIZE-1 downto 0) := B"00000000_00000000_00000000_00000001";
signal S_TAIL_IN : std_logic_vector(DATA_SIZE-1 downto 0) := INF_ITEM;
signal S_HEAD_OUT : std_logic_vector(DATA_SIZE-1 downto 0);
signal S_PM_RESET : std_logic := '0';
constant CLK_PERIOD : time := 1 ns;


-- Component declarations
component Array8 port (
	HEAD_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    TAIL_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    HEAD_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    CLK : in std_logic;
    PM_RESET : in std_logic
);
end component;



-- functional code
begin
	uut: Array8 port map ( S_HEAD_IN, S_TAIL_IN, S_HEAD_OUT, S_CLK, S_PM_RESET ); 
	
	CLK_PROCESS : process
	begin
		S_CLK <= '0';
		wait for CLK_PERIOD/2;  --for 0.5 ns signal is '0'.
		S_CLK <= '1';
		wait for CLK_PERIOD/2;  --for next 0.5 ns signal is '1'.
	end process;

	process(S_CLK)
	variable count : integer := 1;
    begin
        if (rising_edge(S_CLK)) then
            count := count + 1;
        end if;
        if (falling_edge(S_CLK)) then
            --Here, insert for next cases
            if (count = 2)  then -- case 2
                S_HEAD_IN <= B"00000000_00000000_00000000_00001100"; --12
            elsif (count = 3) then -- case 3
                S_HEAD_IN <= B"00000000_00000000_00000000_00001000"; --8         8
            elsif (count = 4) then -- case 4
                S_HEAD_IN <= B"00000000_00000000_00000000_00000100"; --4
            elsif (count = 5) then -- case 5
                S_HEAD_IN <= B"00000000_00000000_00000000_00001110"; --14
            elsif (count = 6) then -- case 6
                S_HEAD_IN <= B"00000000_00000000_00000000_00001000"; --8        8
            elsif (count = 7) then -- case 7
                S_HEAD_IN <= B"00000000_00000000_00000000_00001001"; --9        9
            elsif (count = 8) then -- case 8
                S_HEAD_IN <= B"00000000_00000000_00000000_00001001"; --9        9
             elsif (count = 9) then -- case 9
                S_HEAD_IN <= B"00000000_00000000_00000000_00001011"; --11
             elsif (count = 10) then -- case 10
               S_HEAD_IN <= B"00000000_00000000_00000000_00001010"; --10
             elsif (count = 11) then -- case 11
               S_HEAD_IN <= B"00000000_00000000_00000000_00001110"; --14
             elsif (count = 12) then  --case 12
                S_HEAD_IN <= B"00000000_00000000_00000000_00111110"; --62
             elsif (count = 13) then --case 13
                S_HEAD_IN <= B"00000000_00000000_00000000_01001110"; --78
             elsif (count = 14) then  --case 14
                S_HEAD_IN <= B"00000000_00000000_00000000_10001110"; --142
             elsif (count = 15) then --case 15
                S_HEAD_IN <= B"00000000_00000000_00000000_00000010"; --2          
             elsif (count = 16) then --case 16
                S_HEAD_IN <= B"00000000_00000000_00000000_00000001"; --1           1
             elsif (count > 16) then  --emptying
                S_HEAD_IN <= B"00000000_00000000_00000000_11111111"; 
            end if;
		end if;
	end process;

end Behavioral;	