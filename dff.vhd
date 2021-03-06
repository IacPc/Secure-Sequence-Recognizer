library IEEE;
use IEEE.std_logic_1164.all;
		
entity DFF is
	generic(N_bit : integer); 
	port (
			clk: in std_logic;
			reset: in std_logic;
			D: in std_logic_vector(N_bit-1 downto 0);
			Q: out std_logic_vector(N_bit-1 downto 0) 
		 );
end DFF;
architecture DFF_beh of DFF is
	--signal q_s : std_logic_vector(N_bit - 1 downto 0);  -- internal signal used to map the internal registers
	begin
		dff_proc:process(clk,reset)
		begin  
			if(reset='0') then
				Q <= (others => '0'); -- Use the keyword "others" to address all the N_bit bits. Watch out: do not omit the brackets
			elsif(rising_edge(clk)) then
				Q<=D;
			end if;
		end process;	
end DFF_beh;		