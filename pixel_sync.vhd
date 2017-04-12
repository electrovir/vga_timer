library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pixel_sync is
	generic(
		-- default values are for the horizontal sync pulse
		T_DISP: natural := 640; --number of clocsk per display time
		T_FP: natural := 16; --number of clocks per front porch time
		T_PW: natural := 96; -- number of clocks per sync pulse width
		T_BP: natural := 48; --number of clocks per back porch time
		WIDTH: natural := 10  -- bit width of counter
	);
	port(
		clk, rst, en: in std_logic;
		q: out std_logic_vector(WIDTH-1 downto 0);    -- actual counter value
		sync: out std_logic; -- the synce signal
		disp: out std_logic; -- asserted while the T_disp phase is ongoing
		last_disp: out std_logic; -- asserted while the part of T_DISP
		pulse: out std_logic -- asserted when the end of T_BP is reached
	);
end pixel_sync;

-- the following sequence continually repeats
-- sync is the high/low value shown.
--      |<----T_DISP---->|<-T_FP->|<-T_PW->|<-T_BP->|
--      |________________|________|        |________|
-- sync |                |        |________|        |

architecture Behavioral of pixel_sync is
	signal count: std_logic_vector(WIDTH-1 downto 0) := (others=>'0'); 
	constant T_TOTAL: natural := T_DISP + T_FP + T_PW + T_BP;
begin
	counter : entity work.mod_n_counter
		generic map(
			COUNT_N => T_TOTAL, 
			WIDTH => WIDTH
		)
		port map(
			clk => clk,
			rst => rst,
			en => en,
			pulse => pulse,
			count => count
		);
		
	disp <= '1' when unsigned(count)<T_DISP else
			  '0';
	last_disp <= '1' when unsigned(count)=(T_DISP-1) else
			  '0';
	sync <= '0' when unsigned(count)>(T_DISP+T_FP-1) and unsigned(count)<(T_TOTAL-T_BP) else
		  '1';
	q <= count;
	
end Behavioral;

