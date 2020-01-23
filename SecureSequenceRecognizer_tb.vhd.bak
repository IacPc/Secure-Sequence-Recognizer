

library IEEE;
use IEEE.std_logic_1164.all;

entity SSR_tb is
end SSR_tb;


architecture SSR_tb_beh of SSR_tb is

	constant T_CLK   : time := 10 ns; -- Clock period
	constant T_RESET : time := 24 ns; -- Period before the reset deassertion
	constant T_FIRST : time := 13 ns; -- Period before the reset deassertion	

	signal clk_tb  	: std_logic := '0'; -- clock signal, intialized to '0' 
	signal rst_tb  	: std_logic := '0'; -- reset signal
    	signal in_tb	: std_logic_vector(7 downto 0) ;
	signal f_tb	: std_logic :='0';
	signal out_tb	: std_logic;
	signal warn_tb	: std_logic;

	component SecureSequenceRec is
		port (
			clock:	in std_logic; --- clock signal	
			reset:	in std_logic; -- reset signal active low
			first:	in std_logic; -- start sampling signal
			num_in:	in std_logic_vector(7 downto 0); --input sequence number
			
			unlock:	 out std_logic; -- signal of success
			warning: out std_logic -- error signal	

		);
	end component;
	begin

	clk_tb <= not(clk_tb) after T_CLK / 2;  
	rst_tb <= '1' after T_RESET; -- Deasserting the reset after T_RESET nanosecods.
	
	SSR_test: SecureSequenceRec
	port map(clk_tb,rst_tb,f_tb,in_tb,out_tb,warn_tb);

	r_process:process
	begin
		wait for T_RESET;
		in_tb<="00100100";
		wait for T_FIRST;
		f_tb<='1';
		wait for T_CLK;  
		f_tb<='0';
		in_tb<="10010011";--in_tb<="00010011"; -- The second is correct
		wait for T_CLK;
		in_tb<="00111000";
		wait for T_CLK;
		in_tb<="01100101";
		wait for T_CLK;
		in_tb<="01001001";
		
	end process;
	
end SSR_tb_beh;