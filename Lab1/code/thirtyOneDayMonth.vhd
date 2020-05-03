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
--| FILENAME      : thirtyOneDayMonth.vhd
--| AUTHOR(S)     : C3C Christopher Katz, C3C Lauren Humpherys
--| CREATED       : 2/05/2018
--| DESCRIPTION   : This file simply provides a template for Lab1
--| 				- Be sure to include your Documentation Statement below!
--|
--| DOCUMENTATION : 
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

-- entity name should match filename, this has been filled out for you  
entity thirtyOneDayMonth is 
  port(
	sw  : in  std_logic_vector(3 downto 0); -- 4-bit input port
	o_led0 : out std_logic
  );
end thirtyOneDayMonth;

architecture thirtyOneDayMonth_arch of thirtyOneDayMonth is 
	-- include components declarations and signals
    signal SEL: std_logic_vector(2 downto 0); -- select 


begin
-- assigning names to reflect original schematics (for ease of understanding if you wish to)
    SEL(0) <= sw(1);
    SEL(1) <= sw(2);
    SEL(2) <= sw(3);

	--finish assigning signals
	o_led0 <= sw(0) when (SEL = "000") else
-- enter your logic here to implement your specific circuit.	
	sw(0) when (SEL = "001") else
	sw(0) when (SEL = "010") else
	sw(0) when (SEL = "011") else
	not sw(0) when (SEL = "100") else
	not sw(0) when (SEL = "101") else
    not sw(0) when (SEL = "110") else 
    '0' when (SEL = "111") else '0';
	
end thirtyOneDayMonth_arch;
