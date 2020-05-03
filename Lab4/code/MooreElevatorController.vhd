--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2018 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : MooreElevatorController.vhd
--| AUTHOR(S)     : Capt Phillip Warner, Lauren Humpherys, Christopher Katz
--| CREATED       : 03/2018  Modified by Capt Johnson on 18 March 2020, again on 27 April 2020
--| DESCRIPTION   : This file implements the ICE5 Basic elevator controller (Moore Machine)
--|
--|  The system is specified as follows:
--|   - The elevator controller will traverse four floors (numbered 1 to 4).
--|   - It has two external inputs, Up_Down and Stop.
--|   - When Up_Down is active and Stop is inactive, the elevator will move up 
--|			until it reaches the top floor (one floor per clock, of course).
--|   - When Up_Down is inactive and Stop is inactive, the elevator will move down 
--|			until it reaches the bottom floor (one floor per clock).
--|   - When Stop is active, the system stops at the current floor.  
--|   - When the elevator is at the top floor, it will stay there until Up_Down 
--|			goes inactive while Stop is inactive.  Likewise, it will remain at the bottom 
--|			until told to go up and Stop is inactive.  
--|   - The system should output the floor it is on (1 – 4) as a four-bit binary number.
--|  
--| DOCUMENTATION : Only help recieved in EI from Capt Johnson
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : None
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------   
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MooreElevatorController is
    Port ( clk     : in  STD_LOGIC;
           reset   : in  STD_LOGIC;
           stop    : in  STD_LOGIC;
           up_down : in  STD_LOGIC;
           floor   : out STD_LOGIC_VECTOR (3 downto 0)		   
		 );
end MooreElevatorController;

architecture Behavioral of MooreElevatorController is

 

    -- Below you create a new variable type! You also define what values that 
    -- variable type can take on. Now you can assign a signal as 
    -- "sm_floor" the same way you'd assign a signal as std_logic
    -- how would you modify this to go up to 15 floors?
    -- ANSWER: To go up to 15 floors you would add varriables s_floor5 thorugh s_floor15
    type sm_floor is (s_floor1, s_floor2, s_floor3, s_floor4, s_floor5, s_floor6, s_floor7, s_floor8, s_floor9, s_floor10, s_floor11, s_floor12, s_floor13, s_floor14, s_floor15);
    
    -- Here you create variables that can take on the values
    -- defined above. 
    signal current_state, next_state : sm_floor;

 

begin
    
    -- Next state logic ---------------------------------
    next_state <=  s_floor1 when (current_state = s_floor1 and up_down = '0' and stop = '0') or (current_state = s_floor1 and stop = '1') or (current_state = s_floor2 and up_down = '0' and stop = '0') else
                   s_floor2 when (current_state = s_floor1 and up_down = '1' and stop = '0') or (current_state = s_floor2 and stop = '1') or (current_state = s_floor3 and up_down = '0' and stop = '0') else
                   s_floor3 when (current_state = s_floor2 and up_down = '1' and stop = '0') or (current_state = s_floor3 and stop = '1') or (current_state = s_floor4 and up_down = '0' and stop = '0') else
                   s_floor4 when (current_state = s_floor3 and up_down = '1' and stop = '0') or (current_state = s_floor4 and stop = '1') or (current_state = s_floor5 and up_down = '0' and stop = '0') else 
                   s_floor5 when (current_state = s_floor4 and up_down = '1' and stop = '0') or (current_state = s_floor5 and stop = '1') or (current_state = s_floor6 and up_down = '0' and stop = '0') else
                   s_floor6 when (current_state = s_floor5 and up_down = '1' and stop = '0') or (current_state = s_floor6 and stop = '1') or (current_state = s_floor7 and up_down = '0' and stop = '0') else
                   s_floor7 when (current_state = s_floor6 and up_down = '1' and stop = '0') or (current_state = s_floor7 and stop = '1') or (current_state = s_floor8 and up_down = '0' and stop = '0') else
                   s_floor8 when (current_state = s_floor7 and up_down = '1' and stop = '0') or (current_state = s_floor8 and stop = '1') or (current_state = s_floor9 and up_down = '0' and stop = '0') else 
                   s_floor9 when (current_state = s_floor8 and up_down = '1' and stop = '0') or (current_state = s_floor9 and stop = '1') or (current_state = s_floor10 and up_down = '0' and stop = '0') else
                   s_floor10 when (current_state = s_floor9 and up_down = '1' and stop = '0') or (current_state = s_floor10 and stop = '1') or (current_state = s_floor11 and up_down = '0' and stop = '0') else
                   s_floor11 when (current_state = s_floor10 and up_down = '1' and stop = '0') or (current_state = s_floor11 and stop = '1') or (current_state = s_floor12 and up_down = '0' and stop = '0') else
                   s_floor12 when (current_state = s_floor11 and up_down = '1' and stop = '0') or (current_state = s_floor12 and stop = '1') or (current_state = s_floor13 and up_down = '0' and stop = '0') else 
                   s_floor13 when (current_state = s_floor12 and up_down = '1' and stop = '0') or (current_state = s_floor13 and stop = '1') or (current_state = s_floor14 and up_down = '0' and stop = '0') else
                   s_floor14 when (current_state = s_floor13 and up_down = '1' and stop = '0') or (current_state = s_floor14 and stop = '1') or (current_state = s_floor15 and up_down = '0' and stop = '0') else
                   s_floor15 when (current_state = s_floor14 and up_down = '1' and stop = '0') or (current_state = s_floor15 and stop = '1') or (current_state = s_floor15 and up_down = '1' and stop = '0') else s_floor1; 
                                       
    
     -- State memory ------------
    register_proc : process (clk, reset)
    begin
        if reset = '1' then
            current_state <= s_floor1;
        elsif (rising_edge(clk)) then 
            current_state <= next_state;
        end if;
    end process register_proc;   
    -- reset is active high and will return elevator to floor1
    
       
    -- Output logic     ---------------------------------    
    
    -- default is floor1
    --floor <= "0001" when current_state = s_floor1 else
    --         "0010" when current_state = s_floor2 else
    --         "0011" when current_state = s_floor3 else
    --         "0100" when current_state = s_floor4 else "0001";
    
    floor <= X"1" when current_state = s_floor1 else
            X"2" when current_state = s_floor2 else
            X"3" when current_state = s_floor3 else
            X"4" when current_state = s_floor4 else 
            X"5" when current_state = s_floor5 else
            X"6" when current_state = s_floor6 else
            X"7" when current_state = s_floor7 else
            X"8" when current_state = s_floor8 else
            X"9" when current_state = s_floor9 else 
            X"A" when current_state = s_floor10 else
            X"B" when current_state = s_floor11 else
            X"C" when current_state = s_floor12 else
            X"D" when current_state = s_floor13 else
            X"E" when current_state = s_floor14 else 
            X"F" when current_state = s_floor15 else X"1";

 


end Behavioral;







