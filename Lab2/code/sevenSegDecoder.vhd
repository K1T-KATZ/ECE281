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
--| FILENAME      : sevenSegDecoder.vhd
--| AUTHOR(S)     : C3C Christopher Katz, C3C Lauren Humpherys
--| CREATED       : 02/24/2020
--| DESCRIPTION   : Implimentation of a seven segmant decoder
--| 				- Be sure to include your Documentation Statement below!
--|
--| DOCUMENTATION : Lauren Humpherys and I worked together on this project. 
--| 				Capt Johnson answered questions over email and worked on 
--|					the project in his office.
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : NONE
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

-- entity name should match filename  
entity sevenSegDecoder is 
  port(
	-- Identify input and output bits here	
	i_D		:	in std_logic_vector(3 downto 0);
	o_s		:	out std_logic_vector (6 downto 0)
  );
end sevenSegDecoder;

architecture sevenSegDecoder_arch of sevenSegDecoder is 
	-- include components declarations and signals
	signal c_Sa : std_logic;
	signal c_Sb : std_logic;
	signal c_Sc : std_logic;
	signal c_Sd : std_logic;
	signal c_Se : std_logic;
	signal c_Sf : std_logic;
	signal c_Sg : std_logic;
	
	-- intermediate signals with initial value
	-- typically you would use names that relate to signal (e.g. c_mux_2)
  
begin
	-- CONCURRENT STATEMENTS "MODULES" ------------------
	
	-- map the wires to the outputs
	o_s(0) <= c_Sa;
	o_s(1) <= c_Sb;
	o_s(2) <= c_Sc;
	o_s(3) <= c_Sd;
	o_s(4) <= c_Se;
	o_s(5) <= c_Sf;
	o_s(6) <= c_Sg;
	
	-- logic telling each switch (light) when to turn on 
	-- c_Sa through c_Se show the formula using AND, NOT, and OR gates
	c_Sa <= (not i_D(3) and not i_D(2) and not i_D(1) and i_D(0))
		or (i_D(3) and not i_D(2) and i_D(1) and i_D(0))
		or (i_D(2) and not i_D(1) and not i_D(0))
		or (i_D(3) and i_D(2) and not i_D(1));
	
	c_Sb <= (i_D(3) and i_D(2) and not i_D(0))
		or (i_D(3) and i_D(1) and i_D(0))
		or (i_D(2) and i_D(1) and not i_D(0))
		or (not i_D(3) and i_D(2) and not i_D(1) and i_D(0));
	
	c_Sc <= (i_D(3) and i_D(2) and not i_D(0))
		or (not i_D(3) and not i_D(2) and i_D(1) and not i_D(0))
		or (i_D(3) and i_D(2) and i_D(1));
		
	c_Sd <= (not i_D(3) and i_D(2) and not i_D(1) and not i_D(0))
		or (not i_D(2) and not i_D(1) and i_D(0))
		or (i_D(2) and i_D(1) and i_D(0))
		or (i_D(3) and not i_D(2) and i_D(1) and not i_D(0));
		
	c_Se <= (not i_D(3) and i_D(2) and not i_D(1))
		or (not i_D(2) and not i_D(1) and i_D(0))
		or (not i_D(3) and i_D(0));
		
	-- c_Sg and c_Sf show the formula using a lookup table (LUT)
	c_Sg <= '1' when (	(i_D = x"0") or
						(i_D = x"1") or
						(i_D = x"7") ) else '0';
	
	c_Sf <= '1' when (	(i_D = x"1") or
						(i_D = x"2") or
						(i_D = x"3") or
						(i_D = x"7") or
						(i_D = x"C") or
						(i_D = x"D") ) else '0';
						
	-- the LUT approach is far easier to both creat and troubleshoot because you
	-- can see directly when each light should be on.

end sevenSegDecoder_arch;
