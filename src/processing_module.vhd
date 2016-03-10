-- ENTITY DECLARATION: module input and output ports of a device
-- port names, port sizes, directions

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processing_module is port( 
	IL : in std_logic_vector(7 downto 0); 
	IR : in std_logic_vector(7 downto 0);
	RS : out std_logic_vector(7 downto 0):="00000000"; 
	RB : out std_logic_vector(7 downto 0):="00000000";
	CLK : in std_logic
	);
end processing_module;


-- ARCHITECTURE BLOCK --
architecture Behavioral of processing_module is
    signal regS : std_logic_vector(7 downto 0):="00000000"; -- 1 for test
    signal regB : std_logic_vector(7 downto 0):="00000000"; -- 2 for test
   -- signal ready, ready2 : std_logic := '0';

-- FUNCTIONAL CODE: module functionality and implementation
begin
	process --change process(rising_edge(CLK)) to process(CLK)
	variable count : integer := 1;
	begin 
    if(rising_edge(CLK)) then  --added this if
      if(regS < IL and IL <= regB and regB <= IR) then
        report "Case 2";
        regS <= IL;
      elsif (regB < IL and regB <= IR) then
        report "Case 3";
        regS <= regB; regB <= IL; --change Rb for regB in regS<=regB
      elsif (IL <= regS and regS <= IR and IR < regB) then
        report "Case 4";
        regB <= IR;
      elsif (IL <= regS and IR < regS) then
        report "Case 5";
        regS <= IR; regB <= regS;
      elsif (regS < IL and IL <= IR and IR < regB) then
        report "Case 6";
        regS <= IL;regB <= IR;
      elsif(regS <= IR and IR < IL and IR < regB) then
        report "Case 7";
        regS <= IR;regB <= IL;
      end if;
      RS <= regS;
      RB <= regB;
      -- ready <= '1';
    end if;       
    wait on CLK;
    end process;
	

end Behavioral;