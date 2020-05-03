--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2018 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : top_basys3.vhd
--| AUTHOR(S)     : Capt Phillip Warner (modified by C3C Lauren Humpherys and C3C Christopher Katz)
--| CREATED       : 3/9/2018  Modified by Capt Dan Johnson (3/30/2020), again on 4/27/2020
--| DESCRIPTION   : This file implements the top level module for a BASYS 3 to 
--|					drive the Lab 4 Design Project (Advanced Elevator Controller).
--|
--|					Inputs: clk       --> 100 MHz clock from FPGA
--|							btnL      --> Rst Clk
--|							btnR      --> Rst FSM
--|							btnU      --> Rst Master
--|							btnC      --> GO (request floor)
--|							sw(15:12) --> Passenger location (floor select bits)
--| 						sw(3:0)   --> Desired location (floor select bits)
--| 						 - Minumum FUNCTIONALITY ONLY: sw(1) --> up_down, sw(0) --> stop
--|							 
--|					Outputs: led --> indicates elevator movement with sweeping pattern (additional functionality)
--|							   - led(10) --> led(15) = MOVING UP
--|							   - led(5)  --> led(0)  = MOVING DOWN
--|							   - ALL OFF		     = NOT MOVING
--|							 an(3:0)    --> seven-segment display anode active-low enable (AN3 ... AN0)
--|							 seg(6:0)	--> seven-segment display cathodes (CG ... CA.  DP unused)
--|
--| DOCUMENTATION : Col Neff pointed out that not all names of our variables in MooreElevatorController 
--|                 did not match the ones topBasys3.vhd
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : MooreElevatorController.vhd, clock_divider.vhd, sevenSegDecoder.vhd
--|				   thunderbird_fsm.vhd, sevenSegDecoder, TDM4.vhd, OTHERS???
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


entity top_basys3 is
	port(

		clk     :   in std_logic; -- native 100MHz FPGA clock
		
		-- Switches (16 total)
		sw  	:   in std_logic_vector(15 downto 0);
		
		-- Buttons (5 total)
		btnC	:	in	std_logic;					  -- GO
		btnU	:	in	std_logic;					  -- master_reset
		btnL	:	in	std_logic;                    -- clk_reset
		btnR	:	in	std_logic;	                  -- fsm_reset
		--btnD	:	in	std_logic;			
		
		-- LEDs (16 total)
		led 	:   out std_logic_vector(15 downto 0);

		-- 7-segment display segments (active-low cathodes)
		seg		:	out std_logic_vector(6 downto 0);

		-- 7-segment display active-low enables (anodes)
		an      :	out std_logic_vector(3 downto 0)
	);
end top_basys3;

architecture top_basys3_arch of top_basys3 is 

	-- declare components and signals
component MooreElevatorController is
	Port ( clk     : in  STD_LOGIC;
		   reset   : in  STD_LOGIC;
		   stop    : in  STD_LOGIC;
		   up_down : in  STD_LOGIC;
		   floor   : out STD_LOGIC_VECTOR(3 DOWNTO 0)       
		 );
end component MooreElevatorController;
	
component clock_divider is
	generic ( constant k_DIV : natural := 2	);
	port ( 	i_clk    : in std_logic;		   -- basys3 clk
			i_reset  : in std_logic;		   -- asynchronous
			o_clk    : out std_logic		   -- divided (slow) clock
	);
end component clock_divider;

component sevenSegDecoder is
	port (
		i_D	:	in std_logic_vector (3 downto 0);
		o_S :	out std_logic_vector (6 downto 0)
		);
end component sevenSegDecoder;

component TDM4 is
	generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
    Port ( i_CLK     	: in  STD_LOGIC;
           i_RESET	 	: in  STD_LOGIC; -- asynchronous
           i_D3 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D2 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D1 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D0 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   o_DATA		: out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);		--7seg decoder
		   o_SEL		: out STD_LOGIC_VECTOR (3 downto 0)	                -- selected data line (one-cold)	anode
	);
end component TDM4;

component thunderbird_fsm is 
	port(
		i_clk, i_reset : in std_logic;
		i_left, i_right : in std_logic;
		o_lights_L : out std_logic_vector(2 downto 0);
		o_lights_R : out std_logic_vector(2 downto 0)
	);
end component thunderbird_fsm;


	
	-- create wire to connect button to 7SD enable (active-low)
	--signal w_7SD_EN_n : std_logic := '0';	
	signal w_clk : std_logic;
	signal fsm_reset : std_logic;
	signal clock_reset : std_logic;
    --signal master_reset : std_logic;
	signal w_updown : std_logic;
	signal w_stop : std_logic;
	signal w_data_out : std_logic_vector(3 downto 0);
    --signal w_data : std_logic_vector(3 downto 0);
	signal w_sel : std_logic;
    signal w_floor : std_logic_vector(3 downto 0);
    signal w_floor1 : std_logic_vector(3 downto 0);
    signal w_floor2 : std_logic_vector(3 downto 0);
    signal w_clk_1 : std_logic;
    signal w_clk_2 : std_logic;
    signal w_clk_3 : std_logic;
    signal w_thunderL : std_logic;
    signal w_thunderR : std_logic;
    signal w_led_R : std_logic_vector(2 downto 0);
    signal w_led_L : std_logic_vector(2 downto 0);
    signal desired_floor : std_logic_vector(3 downto 0);
    signal current_floor : std_logic_vector(3 downto 0);
	signal w_goPress : std_logic;


  
begin
	-- PORT MAPS ----------------------------------------
	moore_elevator_controller_inst : MooreElevatorController
		port map(
			clk		    => w_clk_1,
			reset		=> fsm_reset,
			up_down	    => w_updown,
			stop		=> w_stop,
			floor		=> w_floor
		);
		
		
	clkdiv2hz_inst : clock_divider		--instantiation of clock_divider to take 
        generic map ( k_DIV => 25000000 ) -- 2 Hz clock from 100 MHz
        port map (						  -- MooreElevatorController 
            i_clk   => clk,			
            i_reset => clock_reset,			
            o_clk   => w_clk_1
        );
		
		
	clkdiv500hz_inst : clock_divider		--instantiation of clock_divider to take 
        generic map ( k_DIV => 50000 )     -- 500 Hz clock from 100 MHz
        port map (						    -- TDM4
            i_clk   => clk,			        -- ORIG KDIV: 200000
            i_reset => btnU,			
            o_clk   => w_clk_2
        );
        
	clkdiv6hz_inst : clock_divider 		--instantiation of clock_divider to take 
        generic map ( k_DIV => 6250000 ) -- 6 Hz clock from 100 MHz
        port map (                        -- Thunderbird  
            i_clk   => clk,            
            i_reset => clock_reset,                    
            o_clk   => w_clk_3
        ); 
		
	sevenSegDecoder_inst: sevenSegDecoder
		port map(
			i_D => w_data_out,
			o_S(6) => seg(6), 
            o_S(5) => seg(5),
            o_S(4) => seg(4),
            o_S(3) => seg(3),
            o_S(2) => seg(2),
            o_S(1) => seg(1),
            o_S(0) => seg(0)
   		);
		
	TDM4_inst : TDM4
		port map( 
		   i_CLK    	=> w_clk_2,
           i_RESET	 	=> btnU,
           i_D3 		=> w_floor1,
		   i_D2 		=> w_floor2,
		   i_D1 		=> w_floor,
		   i_D0 		=> w_floor,
		   o_DATA		=> w_data_out,	    	--7seg decoder
		   o_SEL(3)		=> an(3),       		-- selected data line (one-cold)	anode
		   o_SEL(2)		=> an(2), 
		   o_SEL(1)		=> an(1), 
		   o_SEL(0)		=> an(0) 
	);
	        
    thunderbird_fsm_inst : thunderbird_fsm
        port map (                              
            i_reset       => fsm_reset,
            i_clk         => w_clk_3,
            i_left        => w_thunderL,
            i_right       => w_thunderR,
            o_lights_R(0) => w_led_R(2),
            o_lights_R(1) => w_led_R(1), 
            o_lights_R(2) => w_led_R(0),
            o_lights_L(0) => w_led_L(0), 
            o_lights_L(1) => w_led_L(1),
            o_lights_L(2) => w_led_L(2)
         );
	
	-- CONCURRENT STATEMENTS ----------------------------
	
	-- wire up active-low 7SD anode to button (active-high)
	-- display 7SD 0 only when button pushed
	-- other 7SD are kept off
	
    an(1) <= '1';
    an(0) <= '1';
    fsm_reset <= btnU or btnR;        
    clock_reset <= btnU or btnL;        --Clocks
      
      
	led(9 downto 6) <= "0000";
	
	-- leave unused switches UNCONNECTED
	
	--current_floor <= sw(15 downto 12);
	
    w_floor1 <= "0001" when w_floor > "1001" else 
                "0000";
    
    w_floor2 <= w_floor when w_floor < "1010" else
                "0000" when w_floor = "1010" else
                "0001" when w_floor = "1011" else
                "0010" when w_floor = "1100" else
                "0011" when w_floor = "1101" else
                "0100" when w_floor = "1110" else
                "0101" when w_floor = "1111" else 
                "0001";
   
    moving_lights_proc : process (w_updown, w_stop, w_floor)
        begin
            if w_updown = '1' and w_stop = '0' and w_floor < "1111" then
            w_thunderL <= '1';
            w_thunderR <= '0';
            elsif w_updown = '0' and w_stop = '0' and w_floor > "0001" then
            w_thunderL <= '0';
            w_thunderR <= '1';
            else
            w_thunderL <= '0';
            w_thunderR <= '0';
            end if;
     end process moving_lights_proc;
	 
	 
--	change_input_proc : process (w_floor, btnC)
--		begin
--		    if (btnC = '1') then 
--			     if w_floor = desired_floor then
 --                   w_updown <= '0';
 --                   w_stop <= '1';
--	             else 
 --                   if (w_floor < desired_floor) then
 --                       w_updown <= '1';
--                        w_stop <= '0';
--                    else
--                        w_updown <= '0';
--                        w_stop <= '0';                     
 --                   end if;
 --                end if;
--			end if;
--		end process change_input_proc;
		
    change_input_proc : process (clk)
    begin 
    if (btnC = '1') then
             desired_floor <= sw(3 downto 0);
             w_goPress <= '1';
     end if;
        if (fsm_reset = '1') then
            w_stop <= '1';
            w_goPress <= '0';
        end if;
        if (rising_edge(clk)) then 
            if (w_goPress = '1') then
                if (w_floor < desired_floor) then
                    w_updown <= '1';
                    w_stop <= '0';
                elsif (w_floor > desired_floor) then
                    w_updown <= '0';
                    w_stop <= '0';  
                else
                    w_stop <= '1';
                    w_goPress <= '0';
                end if;   
            else
                  w_stop <= '1';
                  w_updown <= '0';           
            end if;
        end if;
    end process change_input_proc;
     
    --w_thunderL <= '1' when (sw(1) = '1' and sw(0) = '0' and w_floor < "1111") else 
                --  '0';             
    --w_thunderR <= '1' when (sw(1) = '0' and sw(0) = '0' and w_floor >  "0001") else 
                 -- '0';
	
	led(15)    <= w_led_L(2);
	led(14)    <= w_led_L(2);
	led(13)    <= w_led_L(1);
	led(12)    <= w_led_L(1);
	led(11)    <= w_led_L(0);
	led(10)    <= w_led_L(0);
	led(5)     <= w_led_R(2);
	led(4)     <= w_led_R(2);
	led(3)     <= w_led_R(1);
	led(2)     <= w_led_R(1);
	led(1)     <= w_led_R(0);
	led(0)     <= w_led_R(0);
	
    
	-- Ignore the warnings associated with these signals
	-- Alternatively, you can create a different board implementation, 
	--   or make additional adjustments to the constraints file
	
	-- wire up active-low 7SD anodes (an) as required
	-- Tie any unused anodes to power ('1') to keep them off
	
end top_basys3_arch;
