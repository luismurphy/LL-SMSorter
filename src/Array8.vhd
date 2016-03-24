
library IEEE;
use IEEE.std_logic_1164.ALL;
use work.merge_sorter_pkg.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- ENTITY BLOCK -- 
entity Array8 is
	port (
		HEAD_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
		TAIL_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
		HEAD_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
		CLK : in std_logic;
		PM_RESET : in std_logic
	);
end Array8;

-- ARCHITECTURE BLOCK --
architecture Behavioral of Array8 is

	-- COMPONENT DECLARATION
	component processing_module
	port(IL : in std_logic_vector(DATA_SIZE-1 downto 0); 
		IR : in std_logic_vector(DATA_SIZE-1 downto 0);
		RS : out std_logic_vector(DATA_SIZE-1 downto 0); 
		RB : out std_logic_vector(DATA_SIZE-1 downto 0);
		CLK : in std_logic;
		PM_RESET : in std_logic
		);
	end component;
	
	-- SIGNALS DECLARATION
	type vector_array is array (0 to (K/2)-1) of std_logic_vector(DATA_SIZE-1 downto 0); --array of size 8 with data of 8bits
	signal left_data : vector_array; -- signal from RS of each Processing Module
	signal right_data : vector_array; -- signal from RB of each Processing Module
	
-- FUNCTIONAL CODE: systolic array functionality and implementation
begin
pm_array: For i in 0 to (K/2)-1 generate

	-- First Processing Module --
	pm1: if i=0 generate
	begin
		pm: component processing_module
			port map(head_in, left_data(i+1), head_out, right_data(i), CLK, PM_RESET);
			--       IL        IR               RS          RB
	end generate pm1;
	
	-- Middles Processing Modules --
	pm_middle: if (i>0 and i<(K/2)-1) generate
	begin
		pm: component processing_module
			port map(right_data(i-1), left_data(i+1), left_data(i), right_data(i), CLK, PM_RESET);
			--       IL               IR               RS           RB
	end generate pm_middle;
	
	-- Last Processing Module --
	pm7: if (i=(K/2)-1) generate
	begin
		pm: component processing_module
			port map(right_data(i-1), tail_in, left_data(i), right_data(i), CLK, PM_RESET);
			--       IL               IR       RS            RB
	end generate pm7;	
end generate pm_array;
end Behavioral;
