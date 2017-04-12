library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mod_n_counter is
	generic(
		COUNT_N: natural := 2;
		COUNT_MIN: natural := 0;
		COUNT_INC: natural := 1;
		WIDTH: natural := 1
	);
	port(
		clk, rst, en: in std_logic;
		count: out std_logic_vector(WIDTH-1 downto 0);
		toggle, pulse, clk_pulse: out std_logic
	);
end mod_n_counter;

architecture Behavioral of mod_n_counter is
	signal q: unsigned(WIDTH-1 downto 0) := to_unsigned(COUNT_MIN, WIDTH);
	signal toggle_q: std_logic;
	constant COUNT_MAX: natural := COUNT_N-1;
begin
	process(clk, rst) begin
		if (rst = '1') then
			q <= to_unsigned(COUNT_MIN, WIDTH);
			toggle_q <= '0';
		elsif (clk'event and clk='1') then
			if (en='1') then
				q <= q + COUNT_INC;
				if (q >= COUNT_MAX) then
					q <= to_unsigned(COUNT_MIN, WIDTH);
					toggle_q <= not toggle_q;
				end if;
			end if;
		end if;
	end process;
	
	pulse <= '1' when q=to_unsigned(COUNT_MAX, WIDTH) else
				 '0';
	clk_pulse <= '1' when q=to_unsigned(COUNT_MAX, WIDTH) and clk='1' else
				'0';
	toggle <= toggle_q;
	count <= std_logic_vector(q);
end Behavioral;

