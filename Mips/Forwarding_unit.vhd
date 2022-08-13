library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all; 
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
library work;
use work.REC_pkg.all;

entity Forwarding_unit is
    Port ( 
				
				ex_mem_regWrite   : 	in	std_logic;--en4
				ex_mem_registerRd : 	in  STD_LOGIC_VECTOR(4 downto 0);--rd4
				
				mem_wb_regWrite   : 	in	std_logic;--en5
				mem_wb_registerRd : 	in  STD_LOGIC_VECTOR(4 downto 0);--rd5
				
				id_ex_registerRs  : 	in  STD_LOGIC_VECTOR(4 downto 0);--rs3
				id_ex_registerRt  : 	in  STD_LOGIC_VECTOR(4 downto 0);--rt3
				
				fordward_a        :	    out STD_LOGIC_VECTOR(1 downto 0);--mux
				fordward_b 		  :	    out STD_LOGIC_VECTOR(1 downto 0)--mux
				
			  );
end Forwarding_unit;

architecture arc_FU of Forwarding_unit is

begin

	process(ex_mem_regWrite, ex_mem_registerRd, mem_wb_regWrite, 
			  mem_wb_registerRd, id_ex_registerRs, id_ex_registerRt ) is
	begin
		
		--case 1a
		if ((ex_mem_regWrite = '1') 
			and (ex_mem_registerRd /="00000") 
			and (ex_mem_registerRd = id_ex_registerRs)) then--4-->>3
				fordward_a <= "10"; 
				--case 2a
		elsif ((mem_wb_regWrite = '1') -- 5-->>3
			and (mem_wb_registerRd /="00000") 
			 	and (ex_mem_registerRd /= id_ex_registerRs)--if double bingo
			and (mem_wb_registerRd = id_ex_registerRs)) then
				fordward_a <= "01"; 
		else 
			fordward_a <= "00";
		end if;
		
		--case 1b 
		if ((ex_mem_regWrite = '1') 
			and (ex_mem_registerRd /="00000") 
			and (ex_mem_registerRd = id_ex_registerRt)) then --4-->>3
				fordward_b <= "10"; 
		--case 2b	
		elsif ((mem_wb_regWrite = '1') -- 5-->>3
			and (mem_wb_registerRd /="00000") 
				and (ex_mem_registerRd /= id_ex_registerRt)--if double bingo
			and (mem_wb_registerRd = id_ex_registerRt)) then
				fordward_b <= "01"; 
		else 
			fordward_b <= "00";
		end if;
		
	
	end process;

end arc_FU;
