

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity VALID_TEMPERATURE is
 Port (
        TEMPERATURE : in std_logic_vector(7 downto 0);
        CLK: in STD_LOGIC;
        VALID : out boolean
     );
end VALID_TEMPERATURE;

architecture BEHAVIORAL of VALID_TEMPERATURE is
signal TEMP: integer := 0;
begin
    
    CLOCK: process(CLK ,TEMPERATURE)
    begin
        TEMP<= to_integer(signed(TEMPERATURE));
        if(rising_edge(CLK)) then
            if(TEMP >60 ) then
                VALID<=false;
            elsif(TEMP <-10) then
                VALID<=false;
            else
                VALID<=true;
            end if;
        end if;
end process;


end BEHAVIORAL;
