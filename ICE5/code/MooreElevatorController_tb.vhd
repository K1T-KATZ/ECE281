--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : Moore_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : Capt Phillip Warner, Lauren Humpherys, Christopher Katz
--| CREATED       : 03/2017
--| DESCRIPTION   : This file tests the Moore elevator controller module
--|
--| DOCUMENTATION : Only help recieved in EI from Capt Johnson
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : MooreElevatorController_Shell.vhd
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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
 
entity MooreElevatorController_tb is
end MooreElevatorController_tb;

 

architecture test_bench of MooreElevatorController_tb is 
    
    component MooreElevatorController is
        Port ( clk : in  STD_LOGIC;
               reset : in  STD_LOGIC; -- synchronous
               stop : in  STD_LOGIC;
               up_down : in  STD_LOGIC;
               floor : out  STD_LOGIC_VECTOR (3 downto 0));
    end component MooreElevatorController;
    
    -- test signals
    signal clk, reset, stop, up_down : std_logic                     := '0';
    signal floor                      : std_logic_vector(3 downto 0) := (others => '0');
  
    -- 50 MHz clock
    constant k_clk_period : time := 20 ns;
    
begin
    -- PORT MAPS ----------------------------------------

 

    uut_inst : MooreElevatorController port map (
        clk     => clk,
        reset   => reset,
        stop    => stop,
        up_down => up_down,
        floor   => floor
    );
    
    -- PROCESSES ----------------------------------------
    
    -- Clock Process ------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for k_clk_period/2;
        
        clk <= '1';
        wait for k_clk_period/2;
    end process clk_process;
    
    
    -- Test Plan Process --------------------------------
    test_process : process 
    begin
        -- reset into initial state (floor 1)
        reset <= '1';  wait for k_clk_period; reset <= '0';
        
        -- active UP signal
        up_down <= '1';
        
        -- stay on each floor for 2 cycles and then move up to the next floor
        stop <= '1';  wait for k_clk_period * 2;    -- what do I need here to wait two cycles?
        stop <= '0';  wait for k_clk_period;
        stop <= '1';  wait for k_clk_period * 2;    -- what do I need here to wait two cycles?
        stop <= '0';  wait for k_clk_period;
        stop <= '1';  wait for k_clk_period * 2;    -- what do I need here to wait two cycles?
        stop <= '0';  wait for k_clk_period;
        --fill in the rest of the test bench here to go up to floor 4
        wait for k_clk_period * 2;                    -- wait on floor 4 (stop should NOT matter)

 

        -- from top floor, return to first floor without stopping
        up_down <= '0';
        wait for k_clk_period * 4;
        
        -- wait one more clk period just to prove that you will stay at first floor
        wait for k_clk_period;
        
        wait; -- wait forever
    end process;    
    -----------------------------------------------------    
    
end test_bench;