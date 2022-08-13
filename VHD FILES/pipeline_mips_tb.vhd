library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;

entity Pipeline_mips_TB is
end Pipeline_mips_TB;

architecture Pipeline_mips_TB_ARC of Pipeline_mips_TB is

	component Pipeline_mips is
		port(
			CLK 	 :	in STD_LOGIC;
			RESET	 :	in STD_LOGIC
		);
	end component Pipeline_mips;


	signal CLK	: STD_LOGIC;
	signal RESET	: STD_LOGIC;

begin
	MIPS_TB:
		Pipeline_mips port map(
			CLK => CLK,
			RESET => RESET
		);

	CLK_PROC:
		process
		begin
			while true loop
				CLK <= '0';
				wait for 20 us;
				CLK <= '1';
				wait for 20 us;
			end loop;
		end process CLK_PROC;


	RESET_PROC:
		process
		begin
			RESET<='1';
			wait for 20 us;
			RESET<='0';
			wait;
		end process RESET_PROC;
   	
end Pipeline_mips_TB_ARC;