LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE work.merge_sorter_pkg.all;


ENTITY controller_tb IS
END controller_tb;


-- ARCHITECTURE BLOCK --
ARCHITECTURE Behavioral OF controller_tb IS

    --Signal declarations: Initialize according to first case you want to test
    SIGNAL S_CLK : std_logic :='0';

    SIGNAL S_DATA_FROM_MEM : std_logic_vector(DATA_SIZE-1 downto 0) := ZERO_ITEM;
    SIGNAL S_DATA_TO_MEM : std_logic_vector(DATA_SIZE-1 downto 0);
    SIGNAL S_MEM_ADDR : std_logic_vector(ADDR_SIZE-1 downto 0);
    SIGNAL S_MEM_ENABLE : std_logic;
    SIGNAL S_MEM_WE : std_logic;
    SIGNAL S_TO_ARRAY : std_logic_vector(DATA_SIZE-1 downto 0);
    SIGNAL S_FROM_ARRAY : std_logic_vector(DATA_SIZE-1 downto 0);
    SIGNAL S_SEND_TO_OUT : std_logic;

    CONSTANT clk_period : time := 1 ns;


    -- Component declarations
    COMPONENT controller
        PORT (   
            CLK : in std_logic;

            DATA_FROM_MEM : in std_logic_vector(DATA_SIZE-1 downto 0);
            DATA_TO_MEM : out std_logic_vector(DATA_SIZE-1 downto 0);
            MEM_ADDR : out std_logic_vector(ADDR_SIZE-1 downto 0);
            MEM_ENABLE : out std_logic;
            MEM_WE : out std_logic;

            TO_ARRAY : out std_logic_vector(DATA_SIZE-1 downto 0);
            FROM_ARRAY : in std_logic_vector(DATA_SIZE-1 downto 0);
            SEND_TO_OUT : out std_logic
        );
    END COMPONENT;



    -- functional code
    BEGIN
        uut: controller PORT MAP (
            S_CLK, S_DATA_FROM_MEM, S_DATA_TO_MEM, S_MEM_ADDR, S_MEM_ENABLE,
            S_MEM_WE, S_TO_ARRAY, S_FROM_ARRAY, S_SEND_TO_OUT );
        
        clk_process : PROCESS
        BEGIN
            S_CLK <= '0';
            WAIT FOR clk_period/2;  --for 0.5 ns signal is '0'.
            S_CLK <= '1';
            WAIT FOR clk_period/2;  --for next 0.5 ns signal is '1'.
        END PROCESS;

        process(S_CLK)
        variable count : integer := 1;
        begin
            if (rising_edge(S_CLK)) then
                -- DO TEST
                -- Check if change
            end if;
        end process;

end Behavioral;