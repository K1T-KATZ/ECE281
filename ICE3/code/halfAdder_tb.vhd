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
--| FILENAME      : halfAdder_tb.vhd
--| AUTHOR(S)     : Capt Warner
--| CREATED       : 01/17/2017
--| DESCRIPTION   : This file implements a half adder test bench.
--|
--| DOCUMENTATION : Modified slightly by Capt Johnson
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : halfAdder.vhd
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
  
entity halfAdder_tb is
end halfAdder_tb;

architecture test_bench of halfAdder_tb is 

-- Component Declaration	
  component halfAdder is
	port(
		i_A     : in  std_logic; 
		i_B     : in  std_logic; 
		o_S     : out std_logic;
		o_Cout  : out std_logic
	);	
  end component;

  
  signal i_sw1, i_sw0 : std_logic := '0'; 
  signal o_led1, o_led0 : std_logic := '0';
    
begin
-- Port Maps
	halfAdder_inst : halfAdder port map (
		i_A     => i_sw1,
		i_B     => i_sw0,
		o_S     => o_led0,
		o_Cout  => o_led1
	);

--Process to generate test cases
	test_process : process 
	begin
	
		i_sw1 <= '0'; i_sw0 <= '0'; wait for 10 ns;
		i_sw1 <= '0'; i_sw0 <= '1'; wait for 10 ns;
		i_sw1 <= '1'; i_sw0 <= '0'; wait for 10 ns;
		i_sw1 <= '1'; i_sw0 <= '1';
		
		wait; -- wait forever
	end process;	
	-----------------------------------------------------	
	
end test_bench;
