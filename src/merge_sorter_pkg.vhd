use IEEE.math_real.all;

package merge_sorter_pkg is
	-- DECLARATIONS --
	-- constants
	constant DATA_SIZE : integer := 32; -- 4 bytes per space
	constant ADDR_SIZE : integer := 30; -- 2^30 spaces, 4*2^30 bits, or 4Gb storage
	constant ZERO_ITEM : std_logic_vector(DATA_SIZE-1 downto 0) := B"00000000_00000000_00000000_00000000";
	constant INF_ITEM : std_logic_vector(DATA_SIZE-1 downto 0) := B"11111111_11111111_11111111_11111111";
	constant K : integer := 4;
	constant N_ITEMS : integer := 1024;
	constant REQ_CYCLES : integer := integer( ceil( real(log(to_integer(N_ITEMS))) / real(log(to_integer(K))) ));
	constant INIT_SUBSEQS : integer := get_n_init_subseqs;

	-- functions
	function get_n_init_subseqs return integer;
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
end merge_sorter_pkg;