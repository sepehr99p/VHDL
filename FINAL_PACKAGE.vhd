library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
package FINAL_PACKAGE is
    component INCUBATOR is
    Port ( TEMPERATURE       : in   std_logic_vector( 7 downto 0);
           CLK, RESET        : in   std_logic;
           FAN_SPEED         : out  std_logic_vector( 3 downto 0);
           VALID             : out  boolean;
           HEATER , COOLER   : out  std_logic);
    end component;
end package;
package body FINAL_PACKAGE is
end package body ;