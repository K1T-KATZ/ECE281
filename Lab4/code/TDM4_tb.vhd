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
--| FILENAME      : TDM4_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : Capt Phillip Warner, Used by C3C Lauren Humpherys and C3C Christopher Katz
--| CREATED       : 03/2017, Used 04/2020
--| DESCRIPTION   : This file tests the 4 to 1 TDM.
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : TDM4.vhd
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
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
  
entity TDM4_tb is
end TDM4_tb;

architecture test_bench of TDM4_tb is 	
  
	component TDM4 is
		generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
		Port ( i_CLK     	: in  STD_LOGIC;
			   i_RESET	 	: in  STD_LOGIC; -- asynchronous
			   i_D3 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
			   i_D2 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
			   i_D1 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
			   i_D0 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
			   o_DATA		: out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
			   o_SEL		: out STD_LOGIC_VECTOR (3 downto 0)	-- selected data line
		);
	end component TDM4;

	-- Setup of test clk and other signals
	constant k_clk_period	: time 		:= 20 ns;
	signal clk			 	: std_logic	:= '0';

	signal reset			: std_logic	:= '0';
	
	constant k_IO_WIDTH		: natural	:= 4;
	signal D3, D2, D1, D0, DATA	: std_logic_vector (k_IO_WIDTH - 1 downto 0);

	signal sel				: std_logic_vector(3 downto 0);
	
begin
	-- PORT MAPS ----------------------------------------

	uut_inst : TDM4 
	generic map ( k_WIDTH => k_IO_WIDTH )
	port map ( i_CLK   => clk,
		       i_RESET => reset,
		       i_D3    => D3,
		       i_D2    => D2,
		       i_D1    => D1,
		       i_D0    => D0,
		       o_DATA  => DATA,
		       o_SEL   => sel
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
	-----------------------------------------------------	
	
	-- Test Plan Process --------------------------------
	test_process : process 
	begin
		-- assignment of test values to data inputs (one-hot)
		D3 <= "1000";
		D2 <= "0100";
		D1 <= "0010";
		D0 <= "0001";
				
		-- reset the system first
		reset <= '1';
		wait for k_clk_period;		
		reset <= '0';
		
		wait; -- let the TDM do its work
	end process;	
	-----------------------------------------------------	
	
end test_bench;
