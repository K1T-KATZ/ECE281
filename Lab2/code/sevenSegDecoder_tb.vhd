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
--| AUTHOR(S)     : C3C Christopher Katz, C3C Lauren Humpherys
--| CREATED       : 02/24/2020
--| DESCRIPTION   : Implimentation of a seven segmant decoder
--|
--| DOCUMENTATION : See sevenSegDecoder.vhd for full documentation statement
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
	
  -- declare the component of your top-level design unit under test (UUT)
  component sevenSegDecoder is
    port(
	-- Identify input and output bits here
	i_D		:	in std_logic_vector(3 downto 0);
	o_s		:	out std_logic_vector (6 downto 0)
    );	
  end component;

  -- declare any additional components required
	signal w_i_D		:	std_logic_vector(3 downto 0);
	signal w_o_s		:	std_logic_vector (6 downto 0);
  
  -- declare signals needed to stimulate the UUT inputs

  -- also need signals for the outputs of the UUT

  
begin
	-- PORT MAPS ----------------------------------------

	-- map ports for any component instances (port mapping is like wiring hardware)
	uut_inst : sevenSegDecoder port map (
		i_D	=>	w_i_D,
		o_s	=>	w_o_s
	  -- use comma (not a semicolon)
	  -- no comma on last line
	);
	
	-- Test Plan Process --------------------------------
	-- Implement the test plan here.  Body of process is continuous from time = 0  
	test_process : process 
	begin
		-- ex: assign '0' for first 100 ns, then '1' for next 100 ns, then '0'
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
