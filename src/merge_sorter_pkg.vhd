LIBRARY IEEE;
use IEEE.math_real.all;
use IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

package merge_sorter_pkg is
	-- DECLARATIONS --
	-- functions
	function get_n_init_subseqs return integer;
	impure function RANDOM_NUM_GEN(constant lower_value : in integer;  
		constant upper_value : in integer;  
		constant busWidth: in integer ) return integer;  
	-- constants
	constant DATA_SIZE : integer := 32; -- 4 bytes per space
	constant ADDR_SIZE : integer := 12; -- 2^30 spaces, 4*2^30 bits, or 4Gb storage
	constant ZERO_ITEM : std_logic_vector(DATA_SIZE-1 downto 0) := B"00000000_00000000_00000000_00000000";
	constant INF_ITEM : std_logic_vector(DATA_SIZE-1 downto 0) := B"11111111_11111111_11111111_11111111";
	constant ZERO_ADDR : std_logic_vector(ADDR_SIZE-1 downto 0) := B"000000000000";
	constant K : integer := 10;
	constant N_ITEMS : integer := 1024;
	constant REQ_CYCLES : integer := integer( ceil( log(real(N_ITEMS)) / log(real(K)) ));
	constant INIT_SUBSEQS : integer := get_n_init_subseqs;

	shared variable seed1:integer:=844396720; -- uniform procedure seed1  
	shared variable seed2:integer:=821616997; -- uniform procedure seed2  
end merge_sorter_pkg;

	-- BODY --
package body merge_sorter_pkg is
	function get_n_init_subseqs return integer is
		 variable init_subseqs : integer := 0 ; -- local variable
	begin
		init_subseqs := N_ITEMS / K;
		if (N_ITEMS mod K > 0) then
			init_subseqs:=init_subseqs+1;
		end if;
		return init_subseqs;
	end get_n_init_subseqs;
	
	-- http://sagekingthegreat.blogspot.com/2013/08/vhdl-random-number-generation-for.html
	impure function RANDOM_NUM_GEN(constant lower_value : in integer;  
		constant upper_value : in integer;  
		constant busWidth: in integer ) return integer is  
			variable result : integer;  
			variable tmp_real : real; -- return value from uniform procedure --  
			begin  
--            ASSERT (lower_value < (2**busWidth))  
--            -REPORT "RANDOM_NUM_GEN():lower_value Range is exceeded "  
--            SEVERITY FAILURE;  
--            ASSERT (upper_value < (2**busWidth))  
--            REPORT "RANDOM_NUM_GEN():upper_value Range is exceeded"  
--            SEVERITY FAILURE;  
			uniform(seed1,seed2,tmp_real);  
			-- generates rand no. inside busWidth limit --  
			result :=integer(trunc((tmp_real * real(upper_value - lower_value)) + real(lower_value)));  
			return result;  
	end RANDOM_NUM_GEN; 
end merge_sorter_pkg;