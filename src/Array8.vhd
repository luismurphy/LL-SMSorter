
library IEEE;
use IEEE.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Array8 is
    port ( HEAD_IN : in std_logic_vector(7 downto 0);
           TAIL_IN : in std_logic_vector(7 downto 0);
           HEAD_OUT : out std_logic_vector(7 downto 0);
           CLK : in std_logic);
end Array8;

architecture Behavioral of Array8 is

    -- DECLARE
    component processing_module
    port(IL : in std_logic_vector(7 downto 0); 
        IR : in std_logic_vector(7 downto 0);
        RS : out std_logic_vector(7 downto 0); 
        RB : out std_logic_vector(7 downto 0);
        CLK : in std_logic
        );
    end component;
    
    type vector_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal left_data : vector_array;
    signal right_data : vector_array;
    
    -- INSTANTIATE
    begin
    pm_array: For i in 0 to 7 generate
        pm1: if i=0 generate
        begin
            pm: component processing_module
                port map(head_in, left_data(i+1), head_out, right_data(i), CLK);
                --       IL        IR               RS          RB
        end generate pm1;
        
        pm_middle: if (i>0 and i<7) generate
        begin
            pm: component processing_module
                port map(right_data(i-1), left_data(i+1), left_data(i), right_data(i), CLK);
        end generate pm_middle;
        
        pm7: if (i=7) generate
        begin
            pm: component processing_module
                port map(right_data(i-1), tail_in, left_data(i), right_data(i), CLK);
        end generate pm7;
        
    end generate pm_array;
end Behavioral;
