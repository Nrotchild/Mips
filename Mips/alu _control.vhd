library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;

library work;
use work.REC_pkg.all;

entity ALU_CONTROL is
	port(
			--inputs
			CLK			:	in STD_LOGIC;				
			FUNCT		:	in STD_LOGIC_VECTOR(5 downto 0);	
			ALU_OP_IN	:	in ALU_OP_INPUT;	--op0 op1		
			--output
		    ALU_IN		:	out ALU_INPUT	--inputs to the alu			
	);
end ALU_CONTROL;

architecture ALU_CONTROL_ARC of ALU_CONTROL is
begin
	--logic from presentation of alu
	ALU_IN.Op0 <= ALU_OP_IN.Op1 and ( FUNCT(0) or FUNCT(3) );
	ALU_IN.Op1 <= (not ALU_OP_IN.Op1) or (not FUNCT(2));
	ALU_IN.Op2 <= ALU_OP_IN.Op0 or ( ALU_OP_IN.Op1 and FUNCT(1) );

end ALU_CONTROL_ARC;