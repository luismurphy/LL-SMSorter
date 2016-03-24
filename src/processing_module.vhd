library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.merge_sorter_pkg.all;

-- ENTITY DECLARATION: module input and output ports of a device
-- port names, port sizes, directions
entity processing_module is 
	port(
		IL : in std_logic_vector(DATA_SIZE-1 downto 0); 
		IR : in std_logic_vector(DATA_SIZE-1 downto 0);
		RS : out std_logic_vector(DATA_SIZE-1 downto 0):=ZERO_ITEM; -- ALWAYS INITIALIZED WITH NEGATIVE INFINITE
		RB : out std_logic_vector(DATA_SIZE-1 downto 0):=ZERO_ITEM; -- ALWAYS INITIALIZED WITH NEGATIVE INFINITE
		CLK : in std_logic;
		PM_RESET : in std_logic
	);
end processing_module;

-- ARCHITECTURE BLOCK --
architecture Behavioral of processing_module is
	signal regS : std_logic_vector(DATA_SIZE-1 downto 0):=ZERO_ITEM; -- ALWAYS INITIALISED WITH NEGATIVE INFINITE-- 1 for test
	signal regB : std_logic_vector(DATA_SIZE-1 downto 0):=ZERO_ITEM; -- ALWAYS INITIALISED WITH NEGATIVE INFINITE-- 2 for test

-- FUNCTIONAL CODE: module functionality and implementation
begin
	process -- "sensitivity list implemented as "wait on"
	variable count : integer := 1;
	begin 
		if (PM_RESET = '1') then -- asynchronous
			 -- PM_RESET is 1 when all items have been returned in sorted order
			 -- Controller signals modules to take on a -inf value (ZERO_ITEM)
			 regS <= ZERO_ITEM;
			 regB <= ZERO_ITEM;
		elsif(rising_edge(CLK)) then	-- FIGURE 10C
			if(regS < IL and IL <= regB and regB <= IR) then
				report "Case 2";
				regS <= IL;
			elsif (regB < IL and regB <= IR) then
				report "Case 3";
				regS <= regB; regB <= IL;
			elsif (IL <= regS and regS <= IR and IR < regB) then
				report "Case 4";
				regB <= IR;
			elsif (IL <= regS and IR < regS) then
				report "Case 5";
				regS <= IR; regB <= regS;
			elsif (regS < IL and IL <= IR and IR < regB) then
				report "Case 6";
				regS <= IL; regB <= IR;
			elsif(regS <= IR and IR < IL and IR < regB) then
				report "Case 7";
				regS <= IR; regB <= IL;
			end if;
			-- Move RS <= regS here?
			--RS <= regS;
            --RB <= regB;
		end if;
		-- Should falling_edge() behavior be changed?
		if(falling_edge(CLK)) then
			RS <= regS;
			RB <= regB;
			count := count+1;
		end if;
		wait on CLK, PM_RESET;
	end process;
end Behavioral;