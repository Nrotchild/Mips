library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
package REC_PKG is

	--Registers that combine the outputs of the Control Unit
	
	type WB_CTRL_REG is
	record
		RegWrite	:	STD_LOGIC;	--Write enable signal
		MemtoReg	:	STD_LOGIC;	--enable signal
    	end record;
    
	type MEM_CTRL_REG is
    	record
	      	Branch		:	STD_LOGIC;	--enable
			MemRead		:	STD_LOGIC;	--enable
			MemWrite	:	STD_LOGIC;	--enable
    	end record;

	type ALU_OP_INPUT is
    	record
       		Op0		:	STD_LOGIC;
       		Op1		:	STD_LOGIC;
		
    	end record;
    
	type EX_CTRL_REG is
    	record
       		RegDst		:	STD_LOGIC;	--enable
       		ALUOp		:	ALU_OP_INPUT;
			ALUSrc		:	STD_LOGIC;	--enable
    	end record;
	

	type ALU_INPUT is
	record
		Op0		:	STD_LOGIC;
		Op1		:	STD_LOGIC;
		Op2		:	STD_LOGIC;
	end record;

end RECORDS_PKG;