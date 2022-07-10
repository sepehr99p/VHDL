
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity INCUBATOR is
    Port ( TEMPERATURE       : in   std_logic_vector( 7 downto 0);
           CLK, RESET        : in   std_logic;
           FAN_SPEED         : out  std_logic_vector( 3 downto 0);
           VALID             : out  boolean;
           HEATER , COOLER   : out  std_logic);
end INCUBATOR;

architecture BEHAVIORAL of INCUBATOR is




component VALID_TEMPERATURE is
    Port (
        TEMPERATURE          : in std_logic_vector(7 downto 0);
        CLK                  : in std_logic;
        VALID                : out boolean
     );
end component;

component  DIGITALCONTROL is
    Port ( TEMPERATURE       : in  std_logic_vector( 7 downto 0);
           CLK, RESET        : in  std_logic;
           VALID             : in boolean;
           HEATER, COOLER    : out std_logic);
end component;

component COOLERROTATIONALSPEED is
    Port ( TEMPERATURE       : in  std_logic_vector( 7 downto 0);
           CLK, RESET        : in  std_logic;
           FAN               : in std_logic;
           FAN_SPEED         :out std_logic_vector( 3 downto 0));
end component;
signal FANSPEED: STD_LOGIC := '0';
signal TEMPVALID : boolean :=true;
begin


VT: Valid_temperature
    Port map (TEMPERATURE =>TEMPERATURE,
              CLK=> CLK,
              VALID => TEMPVALID );

DC: DIGITALCONTROL
    Port map (TEMPERATURE =>TEMPERATURE,
        CLK=> CLK,
        RESET => RESET,
        VALID => TEMPVALID,
        HEATER => HEATER,
        COOLER => FANSPEED);

CRS: COOLERROTATIONALSPEED 
    Port map (
        TEMPERATURE =>TEMPERATURE,
        CLK=>CLK,
        RESET=>RESET,
        FAN => FANSPEED,
        FAN_SPEED =>FAN_SPEED);
        

COOLER <=FANSPEED;
valid <=TEMPVALID;
end BEHAVIORAL;
configuration CFG of INCUBATOR is
   for BEHAVIORAL
          for VT:Valid_temperature use entity work.Valid_temperature(BEHAVIORAL);
          end for;
          for DC:DIGITALCONTROL use entity work.DIGITALCONTROL(BEHAVIORAL);
          end for;
          for CRS:COOLERROTATIONALSPEED use entity work.COOLERROTATIONALSPEED(BEHAVIORAL);
          end for;
   end for;
end CFG;
