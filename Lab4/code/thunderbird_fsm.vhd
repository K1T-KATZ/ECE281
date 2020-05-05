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
--| FILENAME      : thunderbird_fsm.vhd
--| AUTHOR(S)     : C3C Lauren Humpherys and C3C Christopher Katz
--| CREATED       : 03/30/2020
--| DESCRIPTION   : Implementation of the thunderbird FSM module, which is used to 
--|					show the direction of elevator movement through the LED lights
--|
--| DOCUMENTATION : Captain Johnson helped us differentiate between state and 
--| output logic. He also helped us correct major errors by telling us to uncomment 
--| all switches and LED lights in the constraints file, and ground the LEDs not being 
--| used for this lab. C3C Felix Zheng verified that our RTL Schematic was correct.
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : None.
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

entity thunderbird_fsm is 
  port(
		i_clk, i_reset : in std_logic;
		i_left, i_right : in std_logic;
		o_lights_L : out std_logic_vector(2 downto 0);
		o_lights_R : out std_logic_vector(2 downto 0)
	);
end thunderbird_fsm;
	

architecture thunderbird_FSM_arch of thunderbird_FSM is 

	signal Q, Q_next:std_logic_vector(2 downto 0) := "000";
  
begin
	-- State Transition Logic	------------------------------
	-- Q(0)* = Q(0)'Q(1)'Q(2)'R(sw) + Q(0)Q(1)'
	Q_next(0) <= (not Q(0) and not Q(1) and not Q(2) and i_right) or (Q(0) and not Q(1));
	-- Q(1)* = Q(0)'Q(1)'Q(2)'L(sw)R(sw) + Q(0)'Q(1)Q(2)' + Q(1)'Q(2)
	Q_next(1) <= (not Q(0) and not Q(1) and not Q(2) and i_left and i_right) or (not Q(0) and Q(1) and not Q(2)) or (not Q(1) and Q(2));
	-- Q(2)* = Q(0)'Q(1)'Q(2)'L(sw) + Q(0)'Q(1)Q(2)' + Q(0)Q(1)'Q(2)'
	Q_next(2) <= (not Q(0) and not Q(1) and not Q(2) and i_left) or (not Q(0) and Q(1) and not Q(2)) or (Q(0) and not Q(1) and not Q(2));


	-- Output Logic		--------------------------------------
	-- One left light
	o_lights_L(0) <= (Q(1) and Q(2)) or (not Q(0) and Q(1)) or (not Q(0) and Q(2));
	-- Two left lights
	o_lights_L(1) <= (not Q(0) and Q(1)) or (Q(0) and Q(1) and Q(2)); 
	-- Three left lights
	o_lights_L(2) <= Q(1) and Q(2);
	-- One right light
	o_lights_R(0) <= Q(0);
	-- Two right lights
	o_lights_R(1) <= (Q(0) and Q(1)) or (Q(0) and Q(2));
	-- Three right lights
	o_lights_R(2) <= Q(0) and Q(1);

	-- State Memory with Asynchronous Reset-------------------
	register_proc : process (i_clk, i_reset)
	begin
		if i_reset = '1' then	
			Q <= "000";		--Reset state is off
		elsif (rising_edge(i_clk)) then
			Q <= Q_next;	--Next state becomes current state
		end if;
	end process register_proc;
	
end thunderbird_FSM_arch;
