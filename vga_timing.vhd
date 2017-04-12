library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_timing is
	port(
		clk, rst: in std_logic;
		HS, VS, last_column, last_row, blank: out std_logic;
		pixel_x, pixel_y: out std_logic_vector(9 downto 0)
	);
end vga_timing;

architecture Behavioral of vga_timing is
	signal disp_x, disp_y, en_x, en_y, pulse_x: std_logic;
begin
	vga_speed : entity work.mod_n_counter
		port map(
			clk => clk,
			rst => rst,
			en => '1',
			pulse => en_x
		);
			
	en_y <= pulse_x and en_x;
	x_counter: entity work.pixel_sync
		generic map(
			-- total clocks = 800
			T_DISP => 640,
			T_FP => 16,
			T_PW => 96,
			T_BP => 48,
			WIDTH => 10
		)
		port map(
			clk => clk,
			rst => rst,
			en => en_x,
			q => pixel_x,
			sync => hs,
			disp => disp_x,
			pulse => pulse_x,
			last_disp => last_column
		);
	y_counter: entity work.pixel_sync
		generic map(
			-- total clocks = 521
			T_DISP => 480,
			T_FP => 10,
			T_PW => 2,
			T_BP => 29,
			WIDTH => 10
		)
		port map(
			clk => clk,
			rst => rst,
			en => en_y,
			q => pixel_y,
			sync => vs,
			disp => disp_y,
			last_disp => last_row
		);
	
	blank <= (not disp_y) or (not disp_x);
end Behavioral;

