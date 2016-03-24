LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE work.merge_sorter_pkg.all;



entity controller_tb is
END controller_tb;


-- ARCHITECTURE BLOCK --
architecture Behavioral OF controller_tb is

	--Signal declarations: Initialize according to first case you want to test
	signal S_CLK : std_logic := '1';

	signal S_DATA_FROM_MEM : std_logic_vector(DATA_SIZE-1 downto 0) := CONV_STD_LOGIC_VECTOR(RANDOM_NUM_GEN(0,100,DATA_SIZE),DATA_SIZE);
	signal S_DATA_TO_MEM : std_logic_vector(DATA_SIZE-1 downto 0);
	signal S_MEM_ADDR : std_logic_vector(ADDR_SIZE-1 downto 0);
	signal S_MEM_ENABLE : std_logic;
	signal S_MEM_WE : std_logic;
	signal S_TO_ARRAY : std_logic_vector(DATA_SIZE-1 downto 0);
	signal S_FROM_ARRAY : std_logic_vector(DATA_SIZE-1 downto 0);
	signal S_SEND_TO_OUT : std_logic;
	signal S_PM_RESET : std_logic := '0';

	constant clk_period : time := 1 ns;


	-- component declarations
	component controller port (
		CLK : in std_logic;

		DATA_FROM_MEM : in std_logic_vector(DATA_SIZE-1 downto 0);
		DATA_TO_MEM : out std_logic_vector(DATA_SIZE-1 downto 0);
		MEM_ADDR : out std_logic_vector(ADDR_SIZE-1 downto 0);
		MEM_ENABLE : out std_logic;
		MEM_WE : out std_logic;

		TO_ARRAY : out std_logic_vector(DATA_SIZE-1 downto 0);
		FROM_ARRAY : in std_logic_vector(DATA_SIZE-1 downto 0);
		SEND_TO_OUT : out std_logic;
		PM_RESET : out std_logic
	);
	end component;
	
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
	uut: controller port map (
		S_CLK, S_DATA_FROM_MEM, S_DATA_TO_MEM, S_MEM_ADDR, S_MEM_ENABLE,
		S_MEM_WE, S_TO_ARRAY, S_FROM_ARRAY, S_SEND_TO_OUT, S_PM_RESET);
	sys_array: Array8 port map (
		S_TO_ARRAY, INF_ITEM, S_FROM_ARRAY, S_CLK, S_PM_RESET);
	
	clk_process : process
	begin
		S_CLK <= '0';
		wait for clk_period/2;  --for 0.5 ns signal is '0'.
		S_CLK <= '1';
		wait for clk_period/2;  --for next 0.5 ns signal is '1'.
	end process;

	process(S_CLK)
		variable count : integer := 1;
	begin
		if (rising_edge(S_CLK)) then
			S_DATA_FROM_MEM <= CONV_STD_LOGIC_VECTOR(RANDOM_NUM_GEN(0,100,DATA_SIZE),DATA_SIZE);
			report "data from memory: " & integer'image(CONV_INTEGER(S_DATA_FROM_MEM));
		end if;
	end process;

end Behavioral;