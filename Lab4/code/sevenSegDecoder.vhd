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
--| FILENAME      : sevenSegDecoderder.vhd
--| AUTHOR(S)     : C3C Lauren Humpherys and C3C Christopher Katz
--| CREATED       : 02/15/2020, Modified 04/2020
--| DESCRIPTION   : Program decoder to generate appropriate output for input of 
--| 				7 segments of the second annode (1s column).  				
--| DOCUMENTATION : See top_basys3.vhd
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

entity sevenSegDecoder is 
	port(
		i_D : in std_logic_vector(3 downto 0);
		o_S : out std_logic_vector(6 downto 0)
  );
end sevenSegDecoder;

architecture sevenSegDecoder_arch of sevenSegDecoder is 
	signal c_Sa : std_logic;
	signal c_Sb : std_logic;
	signal c_Sc : std_logic;		
	signal c_Sd : std_logic;
	signal c_Se : std_logic;
	signal c_Sf : std_logic;
	signal c_Sg : std_logic;
  
begin
	-- CONCURRENT STATEMENTS "MODULES" ------------------

	o_S(0) <= c_Sa;
	o_S(1) <= c_Sb;
	o_S(2) <= c_Sc;
	o_S(3) <= c_Sd;
	o_S(4) <= c_Se;
	o_S(5) <= c_Sf;
	o_S(6) <= c_Sg;
	
	--Sa = BC'D' + ABC' + A'B'C'D + AB'CD		
	c_Sa <= (not i_D(3) and not i_D(2) and not i_D(1) and i_D(0) )
		or ( i_D(3) and not i_D(2) and i_D(1) and i_D(0) )
		or ( i_D(2) and not i_D(1) and not i_D(0) )
		or ( i_D(3) and i_D(2) and not i_D(1) );
	
	--Sb = ABD' + A'BC'D + ACD + BCD' 	
	c_Sb <= (i_D(3) and i_D(2) and not i_D(0))
		or (i_D(3) and i_D(1) and i_D(0))
		or (i_D(2) and i_D(1) and not i_D(0))
	    or (not i_D(3) and i_D(2) and not i_D(1) and i_D(0));
	
	--Sc = ABD' + ABC + A'B'CD'		
	c_Sc <= (i_D(3) and i_D(2) and not i_D(0))
		or (not i_D(3) and not i_D(2) and i_D(1) and not i_D(0))
		or (i_D(3) and i_D(2) and i_D(1));	
	
	--Sd = A'BC'D' + B'C'D + BCD + AB'CD'
	c_Sd <= (not i_D(3) and i_D(2) and not i_D(1) and not i_D(0))
		or (not i_D(2) and not i_D(1) and i_D(0))
		or (i_D(2) and i_D(1) and i_D(0))
		or (i_D(3) and not i_D(2) and i_D(1) and not i_D(0));
	
	--Se = A'BC' + A'D + C'D
	c_Se <= (not i_D(3) and i_D(2) and not i_D(1))
		or (not i_D(2) and not i_D(1) and i_D(0))
		or (not i_D(3) and i_D(0));
	
	--Sg = A'B'C' + A'BCD	
	c_Sg <= '1' when (	(i_D = x"0") or
						(i_D = x"1") or
					(i_D = x"7") ) else '0';

	
	--Sf = ABC' + A'B'D + A'B'C + A'CD
	c_Sf <= '1' when (	(i_D = x"1") or
						(i_D = x"2") or
						(i_D = x"3") or
						(i_D = x"7") or
						(i_D = x"C") or
						(i_D = x"D") ) else '0';
	


	


	
	
end sevenSegDecoder_arch;
