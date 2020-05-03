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
--| FILENAME      : thirtyOneDayMonth_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : C3C Christopher Katz, C3C Lauren Humpherys
--| CREATED       : 02/10/2020
--| DESCRIPTION   : This file is the Lab1 testbench
--|
--| DOCUMENTATION : Recieved a lot of help from Capt Johnson.
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
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
  
entity thirtyOneDayMonth_tb is --notice entity is empty.  The testbench has no external connections.
end thirtyOneDayMonth_tb;

architecture test_bench of thirtyOneDayMonth_tb is 
	
  -- declare the component of your top-level design unit under test (UUT) (looks very similar to entity declaration)
  component thirtyoneDayMonth is
    port(
	--SEL : in  std_logic_vector(1 downto 0); -- select input
	sw  	: 	in  std_logic_vector(3 downto 0); -- 4-bit input port
    o_led0 	: 	out std_logic
    );	
  end component;

  -- declare any additional components required
  
  signal w_sw : std_logic_vector (3 downto 0):= (others=> '0');
  signal w_led0 : std_logic;

  
begin
	-- PORT MAPS ----------------------------------------

	-- map ports for any component instances (port mapping is like wiring hardware)
	uut_inst : thirtyOneDayMonth port map (
            sw    => w_sw,  -- notice comma (not a semicolon)
            o_led0  => w_led0
	);

	-- Test Plan Process --------------------------------
	-- Implement the test plan here.  Body of process is continuous from time = 0  
	test_process : process 
	begin
	-- Place test cases here. The first case has been written for you	 //DONE//
		w_sw <= "0000"; wait for 10 ns;
        w_sw <= "0001"; wait for 10 ns;
		w_sw <= "0010"; wait for 10 ns;
		w_sw <= "0011"; wait for 10 ns;
		w_sw <= "0100"; wait for 10 ns;
		w_sw <= "0101"; wait for 10 ns;
		w_sw <= "0110"; wait for 10 ns;
		w_sw <= "0111"; wait for 10 ns;
		w_sw <= "1000"; wait for 10 ns;
        w_sw <= "1001"; wait for 10 ns;
        w_sw <= "1010"; wait for 10 ns;
        w_sw <= "1011"; wait for 10 ns;
        w_sw <= "1100"; wait for 10 ns;
        w_sw <= "1101"; wait for 10 ns;
        w_sw <= "1110"; wait for 10 ns;
        w_sw <= "1111"; wait for 10 ns;
	    --Fill in the rest of the test cases here	 //DONE//
		wait; -- wait forever
	end process;	
	-----------------------------------------------------	
	
end test_bench;
