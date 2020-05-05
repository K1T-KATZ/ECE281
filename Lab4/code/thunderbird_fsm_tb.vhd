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
--| FILENAME      : thunderbird_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : C3C Lauren Humpherys and C3C Christopher Katz
--| CREATED       : 03/30/2020
--| DESCRIPTION   : This file contains test cases to evaluate the functionality 
--|					of the thunderbird FSM module, which is used to show the
--|					direction of elevator movement through the LED lights
--|
--| DOCUMENTATION : (See thunderbird_fsm.vhd)
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : LIST ANY DEPENDENCIES
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

library unisim;
  use UNISIM.Vcomponents.ALL;
  
entity thunderbird_FSM_tb is
end thunderbird_FSM_tb;

architecture test_bench of thunderbird_FSM_tb is 
	
  -- Component of top-level design unit under test (UUT)
  component thunderbird_FSM is
    port(
		i_clk, i_reset : in std_logic;
		i_left, i_right : in std_logic;
		o_lights_L : out std_logic_vector(2 downto 0);
		o_lights_R : out std_logic_vector(2 downto 0)
    );	
  end component;

  -- declare any additional components required
  
  
  -- Signals needed to stimulate the UUT inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal left : std_logic := '0';
   signal right : std_logic := '0';

  -- Signals for outputs of the UUT
   signal lights_L : std_logic_vector(2 downto 0);
   signal lights_R : std_logic_vector(2 downto 0);
   
   constant k_clk_period : time := 10 ns;


 
begin
	-- PORT MAPS ----------------------------------------

	-- map ports for any component instances (port mapping is like wiring hardware)
	uut_inst : thunderbird_FSM port map (
		i_clk        => clk,
		i_reset      =>  reset,
		i_left       => left,
		i_right      => right,
		o_lights_L   => lights_L,
		o_lights_R   => lights_R
	);
	
	-- PROCESSES ----------------------------------------
	
	-- Provide a comment that describes each process
	-- block them off like the modules above and separate with SPACE
	-- You will at least have a test process
	
	-- Clock process definitions ------------------------
	clk_proc : process
	begin
		clk <= '0';
		wait for k_clk_period/2;
		clk <= '1';
		wait for k_clk_period/2;
	end process;
	-----------------------------------------------------
   
	-- Test Process --------------------------------
	sim_proc : process 		
	begin

		left  <= '0';							-- Set initial state of left and right sides to zero
		right <= '0';
		
	-- RESET --------------------------------
	-- Tests machine state after btnR would have been pressed to reset. 
		reset <= '1'; wait for 10 ns;			-- Reset button is pushed
		reset <= '0'; 						    -- No other buttons are pushed, so all lights should be off.
		
	-- HAZARDS --------------------------------
	-- Tests machine state after both sw(0) and sw(15) would have both been switched on 
		left	<= '1'; 					
		right	<= '1'; wait for 40 ns;
		
		right   <= '0'; wait for 40 ns;			-- TRANSITION
		left    <= '0'; wait for 40 ns;			-- Set left and right outputs back to zero, turning them off.
	
	-- RIGHT ----------------------------------
	-- Tests machine state after sw(0) would have been switched on. 
		right   <= '1'; wait for 40 ns;
		
		
		right   <= '0'; wait for 40 ns;			-- TRANSITION
		left    <= '0'; wait for 40 ns;			-- Set left and right outputs back to zero, turning them off.
		
	-- LEFT ----------------------------------
	-- Tests machine state after sw(15) would have been switched on.
		left   <= '1'; wait for 40 ns;
		
	-- RESET --------------------------------
	-- Tests machine state after btnR would have been pressed to reset. 
		reset <= '1'; wait for 10 ns;			-- Reset button is pushed
		wait;		    						-- No other buttons are pushed.

	end process;		
	
end test_bench;
