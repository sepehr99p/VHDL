

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity DIGITALCONTROL is
    Port ( TEMPERATURE         : in  STD_LOGIC_vector( 7 downto 0);
           CLK, RESET          : in  STD_LOGIC;
           VALID               : in boolean;
           HEATER, COOLER      : out  STD_LOGIC);
end DIGITALCONTROL;

architecture BEHAVIORAL of DIGITALCONTROL is
--type STATE_TYPE is (S1_TEMPERATURE, S2_TEMPERATURE,S3_TEMPERATURE, DUMMY);
subtype STATE_TYPE is STD_ULOGIC_vector (1 downto 0) ;
constant S1_TEMPERATURE    : STATE_TYPE := "00";
constant S2_TEMPERATURE    : STATE_TYPE := "01";
constant S3_TEMPERATURE    : STATE_TYPE := "10";
signal STATE,NEXTSTATE: STATE_TYPE; 

begin
    REG:process (CLK, RESET)
        begin
            if RESET='1' then
                STATE <= S1_TEMPERATURE;       
            elsif CLK'event and CLK='1' then
                STATE <= NEXTSTATE ;
            end if ;
        end process REG;
     CMB:process(STATE ,TEMPERATURE ,NEXTSTATE , valid) 
         begin
         if(VALID) then 
         case STATE is 
            when S1_TEMPERATURE =>
                if TEMPERATURE<"00001111" then
                    NEXTSTATE <= S3_TEMPERATURE;
                elsif TEMPERATURE>"00100011" then
                    NEXTSTATE <= S2_TEMPERATURE;
                else
                    NEXTSTATE <= S1_TEMPERATURE;
                end if ; 
                
            when S2_TEMPERATURE => 
                if TEMPERATURE <"00011001" then
                    NEXTSTATE <= S1_TEMPERATURE;
                else
                    NEXTSTATE <= S2_TEMPERATURE;
                end if ;
              
            when S3_TEMPERATURE=> 
                if TEMPERATURE >"00011110" then
                    NEXTSTATE <= S1_TEMPERATURE;
                else
                    NEXTSTATE <= S3_TEMPERATURE;
                end if ;
            when others => NEXTSTATE <= S1_TEMPERATURE ;
        end case ;
        else
            NEXTSTATE <= S1_TEMPERATURE ; 
        end if;
    end process CMB;
    (HEATER , COOLER )<= STATE;

end BEHAVIORAL;
