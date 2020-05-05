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
--| FILENAME      : sevenSegDecoder_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : C3C Lauren Humpherys, C3C Christopher Katz
--| CREATED       : 02/20/2020
--| DESCRIPTION   : Implementation of a seven seg decoder
--| 	
--| DOCUMENTATION : None.
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : sevenSegDecoder.vhd
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
  
entity sevenSegDecoder_tb is
end sevenSegDecoder_tb;

architecture test_bench of sevenSegDecoder_tb is 
	
  -- declaration of the component of top-level design unit under test (UUT)
  component sevenSegDecoder is
    port(
	-- Identification of input and output bits here
	i_D		:	in std_logic_vector(3 downto 0);
	o_s		:	out std_logic_vector(6 downto 0)
    );	
  end component;

  -- Additional components that are required
  	signal w_i_D		:	std_logic_vector(3 downto 0);
	signal w_o_S		:	std_logic_vector(6 downto 0);

  
begin
	-- PORT MAPS ----------------------------------------

	uut_inst : sevenSegDecoder port map (
		i_D	=>	w_i_D,
		o_S	=>	w_o_S
	);

	
	-- Test Plan Process --------------------------------
	test_process : process 
	begin
		w_i_D <= x"0"; wait for 10 ns;
		w_i_D <= x"1"; wait for 10 ns;
		w_i_D <= x"2"; wait for 10 ns;
		w_i_D <= x"3"; wait for 10 ns;
		w_i_D <= x"4"; wait for 10 ns;
		w_i_D <= x"5"; wait for 10 ns;
		w_i_D <= x"6"; wait for 10 ns;
		w_i_D <= x"7"; wait for 10 ns;
		w_i_D <= x"8"; wait for 10 ns;
		w_i_D <= x"9"; wait for 10 ns;
		w_i_D <= x"A"; wait for 10 ns;
		w_i_D <= x"B"; wait for 10 ns;
		w_i_D <= x"C"; wait for 10 ns;
		w_i_D <= x"D"; wait for 10 ns;
		w_i_D <= x"E"; wait for 10 ns;
        w_i_D <= x"F"; wait for 10 ns;
		
	end process;	
	-----------------------------------------------------	
	
end test_bench;
