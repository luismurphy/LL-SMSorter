----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2016 12:18:39 AM
-- Design Name: 
-- Module Name: DoubleArray8 - Behavioral
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

    entity DoubleArray8 is
        Port ( Head_In : in STD_LOGIC_VECTOR(7 downto 0); --from controller
               Head_Out : out STD_LOGIC_VECTOR(7 downto 0); -- to controller
               CLK : in STD_LOGIC;
               Tail_In : in STD_LOGIC_VECTOR:="11111111";
               Notification : in STD_LOGIC :='0');
    end DoubleArray8;

architecture Behavioral of DoubleArray8 is

    component processing_module
        port(IL : in std_logic_vector(7 downto 0); 
            IR : in std_logic_vector(7 downto 0);
            RS : out std_logic_vector(7 downto 0); 
            RB : out std_logic_vector(7 downto 0);
            CLK : in std_logic
            );
    end component;
    
    type vector_array is array(0 to 7) of std_logic_vector(7 downto 0);
    signal left_data : vector_array;
    signal right_data : vector_array;
    signal left_data_out : vector_array;
    signal right_data_out : vector_array;

begin

    Input_Array: For i in 0 to 7 generate
    left_data(0) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    left_data(1) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    left_data(2) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    left_data(3) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    left_data(4) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    left_data(5) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    left_data(6) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    left_data(7) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    left_data(0) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    right_data(1) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    right_data(2) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    right_data(3) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    right_data(4) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    right_data(5) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    right_data(6) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    right_data(7) <= "00000000" when (Notification = '1' and rising_edge(CLK));
    
        pm1: if i=0 generate
            begin
                 pm: component processing_module
                    port map(Head_In, left_data(i+1),left_data(i),right_data(i),CLK);
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
    end generate Input_Array;
    
    Output_Array: For i in 0 to 7 generate
        
        right_data_out(0) <= right_data(0) when (Notification = '1' and falling_edge(CLK));
        right_data_out(1) <= right_data(1) when (Notification = '1' and falling_edge(CLK));
        right_data_out(2) <= right_data(2) when (Notification = '1' and falling_edge(CLK));
        right_data_out(3) <= right_data(3) when (Notification = '1' and falling_edge(CLK));
        right_data_out(4) <= right_data(4) when (Notification = '1' and falling_edge(CLK));
        right_data_out(5) <= right_data(5) when (Notification = '1' and falling_edge(CLK));
        right_data_out(6) <= right_data(6) when (Notification = '1' and falling_edge(CLK));
        right_data_out(7) <= right_data(7) when (Notification = '1' and falling_edge(CLK));
        left_data_out(0) <= left_data(0) when (Notification = '1' and falling_edge(CLK));
        left_data_out(1) <= left_data(1) when (Notification = '1' and falling_edge(CLK));
        left_data_out(2) <= left_data(2) when (Notification = '1' and falling_edge(CLK));
        left_data_out(3) <= left_data(3) when (Notification = '1' and falling_edge(CLK));
        left_data_out(4) <= left_data(4) when (Notification = '1' and falling_edge(CLK));
        left_data_out(5) <= left_data(5) when (Notification = '1' and falling_edge(CLK));
        left_data_out(6) <= left_data(6) when (Notification = '1' and falling_edge(CLK));
        left_data_out(7) <= left_data(7) when (Notification = '1' and falling_edge(CLK));
        pm1: if i=0 generate
            begin
                 pm: component processing_module
                    port map(Tail_In, left_data_out(i+1),Head_Out,right_data_out(i),CLK);
            end generate pm1;
            
        pm_middle: if (i>0 and i<7) generate
            begin
                pm: component processing_module
                    port map(right_data_out(i-1), left_data_out(i+1), left_data_out(i), right_data_out(i), CLK);
            end generate pm_middle;
            
        pm7: if (i=7) generate
            begin
                pm: component processing_module
                    port map(right_data_out(i-1), Tail_In, left_data_out(i), right_data_out(i), CLK);
            end generate pm7;
            
        end generate Output_Array;
        
end Behavioral;
