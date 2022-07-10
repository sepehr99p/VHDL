
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity COOLERROTATIONALSPEED is
    Port ( TEMPERATURE         : in  std_logic_vector( 7 downto 0);
           CLK, RESET     : in  std_logic;
           FAN            : in std_logic;
           FAN_SPEED       :out std_logic_vector( 3 downto 0));
end COOLERROTATIONALSPEED;

architecture BEHAVIORAL of COOLERROTATIONALSPEED is
--type STATE_TYPE is (S1_FAN, S2_FAN,S3_FAN, out_FAN, DUMMY);
subtype STATE_TYPE is STD_ULOGIC_vector (1 downto 0) ;
constant S1_FAN    : STATE_TYPE := "00";
constant S2_FAN   : STATE_TYPE := "01";
constant S3_FAN   : STATE_TYPE := "10";
constant OUT_FAN   : STATE_TYPE := "11";
signal NEXT_FAN_SPEED: std_logic_vector(3 downto 0); 
constant RPS0: std_logic_vector(3 downto 0) := "0000";  
constant RPS4: std_logic_vector(3 downto 0) := "0100";
constant RPS6: std_logic_vector(3 downto 0) := "0110";
constant RPS8: std_logic_vector(3 downto 0) := "1000";

signal STATE_FAN,NEXTSTATE_FAN : STATE_TYPE;
begin
    REG:process (CLK, RESET )
        begin
            
            if RESET='1' then
                STATE_FAN <= OUT_FAN; 
                FAN_SPEED <= RPS0;     
            elsif CLK'event and CLK='1' then
                STATE_FAN <= NEXTSTATE_FAN ;
                FAN_SPEED <= next_FAN_SPEED;
            end if ;
        end process REG;
    CMB:process(FAN,STATE_FAN,NEXTSTATE_FAN,TEMPERATURE ) is
        begin
            if FAN='1' then
            case STATE_FAN is
            when OUT_FAN =>
                if(TEMPERATURE>"00100011")then
                    NEXTSTATE_FAN <= S1_FAN;
                else
                    NEXTSTATE_FAN <= OUT_FAN;
                end if;
            when S1_FAN=>
                if(TEMPERATURE>"00101000")then
                    NEXTSTATE_FAN <= S2_FAN;
                elsif(TEMPERATURE<"00011001")then
                    NEXTSTATE_FAN <= out_FAN;
                else
                    NEXTSTATE_FAN <= S1_FAN;
                end if;
            when S2_FAN=>
                if(TEMPERATURE>"00101101")then
                    NEXTSTATE_FAN <= S3_FAN;
                elsif(TEMPERATURE<"00100011")then
                    NEXTSTATE_FAN <= S1_FAN;
                else
                    NEXTSTATE_FAN <= S2_FAN;
                end if;
            when S3_FAN=>
                if(TEMPERATURE<"00101000")then
                    NEXTSTATE_FAN <= S2_FAN;
                else
                    NEXTSTATE_FAN <= S3_FAN;
                end if;
           when others  => NEXTSTATE_FAN<= out_FAN ;
        end case; 
        else
         NEXTSTATE_FAN<= out_FAN;
         end if;
    end process CMB;
    OUTPUT: process (STATE_FAN,TEMPERATURE )
            begin
            case state_FAN is
                when out_FAN =>
                     NEXT_FAN_speed<= RPS0;
                when S1_FAN =>
                     NEXT_FAN_speed<= RPS4;
                when S2_FAN =>
                     NEXT_FAN_speed<= RPS6;
                when S3_FAN =>
                     NEXT_FAN_speed<= RPS8;
                when others  =>                             
                    NEXT_FAN_speed<= RPS0;
            end case;        
            end process OUTPUT;

end BEHAVIORAL;
