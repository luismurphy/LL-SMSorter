----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2016 12:59:06 AM
-- Design Name: 
-- Module Name: sorter_system_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sorter_system_tb is
--  Port ( );
end sorter_system_tb;

architecture Behavioral of sorter_system_tb is

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

    component blk_mem_gen_0 port (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
      end component;
-- functional code
begin
	uut: controller port map (
		S_CLK, S_DATA_FROM_MEM, S_DATA_TO_MEM, S_MEM_ADDR, S_MEM_ENABLE,
		S_MEM_WE, S_TO_ARRAY, S_FROM_ARRAY, S_SEND_TO_OUT, S_PM_RESET);
	sys_array: Array8 port map (
		S_TO_ARRAY, INF_ITEM, S_FROM_ARRAY, S_CLK, S_PM_RESET);
	blk_mem_gen: blk_mem_gen_0 port map (
	    S_CLK,S_MEM_ENABLE,S_MEM_WE, S_MEM_ADDR, S_DATA_TO_MEM, S_DATA_FROM_MEM);
	clk_process : process
	begin
		S_CLK <= '0';
		wait for clk_period/2;  --for 0.5 ns signal is '0'.
		S_CLK <= '1';
		wait for clk_period/2;  --for next 0.5 ns signal is '1'.
	end process;

end Behavioral;
