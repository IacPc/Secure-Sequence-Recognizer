library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SecureSequenceRec is
port (
	clock:	in std_logic; --- clock signal	
	reset:	in std_logic; -- reset signal active low
	first:	in std_logic; -- start sampling signal
	num_in:	in std_logic_vector(7 downto 0); --input sequence number
	
	unlock:	 out std_logic; -- signal of success
	warning: out std_logic -- error signal	

);


architecture SSR_beh of SecureSequenceRec is
	
	signal signal_star_in (2 downto 0);
	signal signal_star_out (2 downto 0);

	signal lut_in(2 downto 0);
	signal lut_out(7 downto 0);

	signal signal_ok_in,signal_ok_in; -- 0 when a wrong number is inserted

	component DFF is
	generic(N_bit : integer); 
	port (
		clk: in std_logic;
		reset: in std_logic;
		D: in std_logic_vector(N_bit-1 downto 0);
		Q: out std_logic_vector(N_bit-1 downto 0) 
	);
	end DFF;

	component LUT is  
		generic(
			N_ADD : integer;
			M_DATA : integer
		);
		port(
			address : in STD_LOGIC_VECTOR(N_ADD-1 downto 0);
			data : out STD_LOGIC_VECTOR(M_DATA-1 downto 0)
		);
	end component;

	begin
	
	STAR: DFF --status register
	generic map(N_bit => 3)
	port map(clock,reset,signal_star_in,signal_star_out);

	lut_seq : LUT --contains the sequence numbers
	generic map(N_ADD => 3, M_DATA => 8)
	port map(lut_in,lut_out);

	process(clock,reset,signal_star_in,signal_star_out)


end SSR_beh;