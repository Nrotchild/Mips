library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.records_pkg.all;

entity EX_MEM_REGISTERS is 
    port(
		--INPUTS
			CLK				: in STD_LOGIC;					
			RESET			: in STD_LOGIC;					
			WB_CR_IN		: in WB_CTRL_REG; --hold until WB stage
			MEM_CR_IN		: in MEM_CTRL_REG;--hold until MEM stage
			ALU_RES_IN		: in STD_LOGIC_VECTOR(31 downto 0);	--alu res
			--------fu---------------
			RT_IN			: in STD_LOGIC_VECTOR (31 downto 0);--It will enter as Write Data in the MEM stage
			RT_RD_ADDR_IN	: in STD_LOGIC_VECTOR (4 downto 0);--hold until WB stage - (used for lw or sw)	
			 			     	      
			--outputs
			WB_CR_OUT		: out WB_CTRL_REG; 	--hold until WB stage
			MEM_CR_OUT		: out MEM_CTRL_REG;	--hold until MEM stage
			ALU_RES_OUT		: out STD_LOGIC_VECTOR (31 downto 0);--alu res
			-------fu---------------
			RT_OUT			: out STD_LOGIC_VECTOR (31 downto 0);--It will enter as Write Data in the MEM stage
			RT_RD_ADDR_OUT	: out STD_LOGIC_VECTOR (4 downto 0)--hold until WB stage
			
		);
end EX_MEM_REGISTERS;

architecture EX_MEM_REGISTERS_ARC of EX_MEM_REGISTERS is        
begin 

	SYNC_EX_MEM:
	  process(CLK,RESET,WB_CR_IN,MEM_CR_IN,ALU_RES_IN,RT_IN,RT_RD_ADDR_IN)
	  begin
		if RESET = '1' then
	    	WB_CR_OUT		<= ('0','0');
			MEM_CR_OUT		<= ('0','0','0');
			ALU_RES_OUT		<= x"00000000";
			RT_OUT			<= x"00000000";
			RT_RD_ADDR_OUT	<= "00000";
		elsif rising_edge(CLK) then
	    	WB_CR_OUT		<= WB_CR_IN;
			MEM_CR_OUT		<= MEM_CR_IN;
			ALU_RES_OUT		<= ALU_RES_IN;
			RT_OUT			<= RT_IN;
			RT_RD_ADDR_OUT	<= RT_RD_ADDR_IN;
		end if;
	  end process; 

end EX_MEM_REGISTERS_ARC;