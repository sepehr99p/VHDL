library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.std_logic_arith.all;

entity INCUBATOR_TB is
--  Port ( );
end INCUBATOR_TB;

architecture BEHAVIORAL of INCUBATOR_TB is

    constant CLOCK: time := 50 ns/2000.0;
    constant CLOCK_PERIOD: time := 50 * 5 ns;
    signal DONE: boolean := false;
    signal VALID: boolean := true;
    signal CLK: std_logic := '1';
    signal RESET: std_logic := '0';
    signal TEMPERATURE: std_logic_vector(7 downto 0);
    signal COOLER: std_logic;
    signal HEATER: std_logic;
    signal FAN_SPEED: std_logic_vector(3 downto 0);

    component Incubator is
        port
        (
            CLK: in std_logic;
            RESET: in std_logic;
            TEMPERATURE: in std_logic_vector(7 downto 0);
            VALID           : out boolean;
            COOLER: out std_logic;
            HEATER: out std_logic;
            FAN_SPEED: out std_logic_vector(3 downto 0)
        );
    end component;
    begin

    CG:                          --ClockGenerator
    process
    begin
        while not DONE loop
            wait for CLOCK;
            clk <= not clk;
        end loop;
        wait;
    end process CG;
    
   
    
    INC: INCUBATOR               --INCUBATOR
        port map
        (
            CLK => CLK,
            RESET => RESET,
            TEMPERATURE =>  TEMPERATURE,
            VALID => VALID,
            COOLER => COOLER,
            HEATER => HEATER,
            FAN_SPEED=> FAN_SPEED
        );
    Stimulus:
    process
    begin
        RESET <= '0';
        TEMPERATURE <= "11110110";
        for  i in 0 to 13 loop
            wait for CLOCK_PERIOD ;
            TEMPERATURE <= TEMPERATURE  + "00000101";
        end loop;
        for  i in 0 to 34 loop
            wait for CLOCK_PERIOD ;
            TEMPERATURE <= TEMPERATURE  - "00000010";
        end loop;
        --TEMPERATURE <= CONV_STD_LOGIC_VECTOR(RANDOM_NUM_GEN(-10,60,8),8);
        TEMPERATURE<="01110110" ;
        wait for CLOCK_PERIOD ;
        TEMPERATURE<="00110110" ;
        wait for CLOCK_PERIOD ;
        reset <= '1';
        wait for CLOCK_PERIOD;
        reset <= '0';
        DONE <= true;
        wait;
    end process;
    
end BEHAVIORAL;

