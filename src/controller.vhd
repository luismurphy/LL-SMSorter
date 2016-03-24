-----------------------------------
------ SYSTOLIC MERGE SORTER ------
-- Sorter system = Memory + Merge Sorter + Clock
-- Merge Sorter = Controller + Systolic Array
-- This module represents the CONTROLLER subsystem
-- The CONTROLLER is designed as a Moore-type FSM
-- 
-----------------------------------

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.merge_sorter_pkg.all;

------------
-- entity --
------------
entity controller is 
	port(	
		CLK : in std_logic;

		DATA_FROM_MEM : in std_logic_vector(DATA_SIZE-1 downto 0);
		DATA_TO_MEM : out std_logic_vector(DATA_SIZE-1 downto 0);
		MEM_ADDR : out std_logic_vector(ADDR_SIZE-1 downto 0) := ZERO_ADDR;
		MEM_ENABLE : out std_logic := '1';
		MEM_WE : out std_logic := '0';
		
		TO_ARRAY : out std_logic_vector(DATA_SIZE-1 downto 0);
		FROM_ARRAY : in std_logic_vector(DATA_SIZE-1 downto 0);
		SEND_TO_OUT : out std_logic;
		PM_RESET : out std_logic
	);
end controller;

------------------
-- architecture --
------------------
architecture cont_fsm of controller is

	-- type definitions --
	type state_type is (INIT,FILL,EMPT,CONT,DEBUG); --VHDL enum, will I need more states?
	type init_subseq_addr_arr is array (0 to INIT_SUBSEQS-1) of unsigned (ADDR_SIZE-1 downto 0); --holds addresses in unsigned form

	-- intermediate signals --
	signal PS : state_type := FILL;
	signal NS : state_type;
	signal INPUT_REG : std_logic_vector(DATA_SIZE-1 downto 0) := ZERO_ITEM;
	signal OUTPUT_REG : std_logic_vector(DATA_SIZE-1 downto 0) := ZERO_ITEM;
	signal ST_TOG : std_logic := '0'; 

begin
	------------------------------------------
	-- SYNCHRONOUS PROCESS 
	-- Assign next state upon next clock cycle
	-- Asynchronous inputs would go here too
	------------------------------------------
	sync_proc: process(CLK,NS)
	begin
		if(falling_edge(CLK)) then
			PS<=NS;
			ST_TOG <= ST_TOG xor '1'; 
		end if;
	end process sync_proc;

	------------------------------------------
	-- COMBINATORIAL PROCESS 
	-- Runs when synchronous process assigns next state
	-- Does appropriate action depending on present state
	------------------------------------------
	comb_proc: process(ST_TOG)
		variable curr_cycle : integer := 1; -- C
		variable curr_subseq : integer := 0; -- S01,...,S0M
		variable curr_item : integer := -1; -- items during FILL/EMPT
		variable curr_subseq_size : integer := K;

	begin
		TO_ARRAY <= ZERO_ITEM; --preassign zero, doesn't matter
		case PS is
			when INIT =>
			    report "INIT STATE";
				-- set address bus
				MEM_WE <= '0';
				MEM_ADDR <= std_logic_vector(to_unsigned(curr_subseq+curr_item,ADDR_SIZE)); --base + offset
				--curr_item := curr_item +1;
				NS <= FILL;
			-- [0051]-[0052]
			when FILL =>
			    report "FILL STATE";
				PM_RESET <= '0';
				-- set address bus
				MEM_WE <= '0';
				MEM_ADDR <= std_logic_vector(to_unsigned(K*curr_subseq+curr_item,ADDR_SIZE));
				curr_item := curr_item +1;
				-- get from data bus
				--INPUT_REG <= DATA_FROM_MEM;
				--TO_ARRAY <= INPUT_REG;
				TO_ARRAY <= DATA_FROM_MEM;
				-- TODO add exchange between in and out registers

				if (curr_item < curr_subseq_size) then -- still filling
					NS <= FILL;
				else -- done filling
					NS <= EMPT;
					curr_item := 0;
				end if;
				-- FILL can go to FILL, EMPT
			when EMPT =>
			    report "EMPTY STATE";
				MEM_WE <= '1';
				-- set data bus
				--OUTPUT_REG <= FROM_ARRAY;
				--DATA_TO_MEM <= OUTPUT_REG;
				DATA_TO_MEM <= FROM_ARRAY;
				-- set address bus
				MEM_ADDR <= std_logic_vector(to_unsigned(N_ITEMS+K*curr_subseq+curr_item,ADDR_SIZE)); -- intermediate area + base + offset
				-- pass infty to array
				TO_ARRAY <= INF_ITEM;
				curr_item := curr_item+1;
				if (curr_item < curr_subseq_size) then -- still emptying
					NS <= EMPT;
				elsif (curr_subseq < INIT_SUBSEQS) then
					curr_item := 0;
					curr_subseq := curr_subseq + 1;
					PM_RESET <= '1';
					--NS <= DEBUG;
					NS <= FILL;
				else
					-- TODO GO TO CONT
					NS <= DEBUG;
				end if;
				-- EMPT can go to EMPT, FILL or CONT
			when CONT =>
				-- Once in CONT, stays in CONT
			when DEBUG =>
				report "DEBUG state reached";
				-- INFINITE LOOP
				NS <= DEBUG;
			when others =>
				-- never reaches this condition
				report "Error state reached";
				-- INFINITE LOOP
				while(1=1) loop
					null;
				end loop;
		end case;
	end process comb_proc;
end cont_fsm;

----- NOTES -----
-- signals = wires
-- output signals can't be rhs
-- an if statement with a condition not accounted for generates a latch
-- Conversion should follow this pattern:
	-- std_log_vec -> integer -> unsigned -> std_log_vec
-- sensitivity list vs wait, pick one and only one



----- EXPLANATION -----
--This module controls the exchange of data between the systolic array and memory
--To do so, we need to know:
--	1) The K in K-way merge sort (number of subsequences to merge)
--	2) Number of items to sort N
--	3) Type of array (outputs values every 1 or 2 cycles)
--The following steps are executed:
--	0) Separate your N items into M=ceil(N/K) subsequences S1,...,SM of K items (or less) each
--	1) for each subsequence S1,...,SM
--		enter input mode (serially present K items)
--		enter output mode (serially receive K items every 1 or 2 clk cycles)
--	2) Enter continuous mode where
--		starting in cycle C=1
--		while sequence not sorted
--			for each group G of K subsequences SC1,...,SCK of size K^C
--				serially present the first item from each (K items)
--				while all subsequences aren't empty
--					receive item from array, store in new subsequence G' (of size K^(C+1) )
--					simultaneously present item from corresponding subsequence SC1,...,SCK (unless subseq empty)
--          C=C+1