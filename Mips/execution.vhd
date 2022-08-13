library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all; 
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
library work;
use work.REC_pkg.all;

entity EXECUTION is
	port( 
		--inputs
     	CLK				: in STD_LOGIC;					
		RESET			: in STD_LOGIC;					
     	WB_CR			: in WB_CTRL_REG; 	--hold until WB stage
		MEM_CR			: in MEM_CTRL_REG;	--hold until MEM stage
		EX_CR			: in EX_CTRL_REG;	--use 	     	
		RS	 			: in STD_LOGIC_VECTOR (31 downto 0);--data of Rs
	    RT 				: in STD_LOGIC_VECTOR (31 downto 0);--data of Rt
		OFFSET			: in STD_LOGIC_VECTOR (31 downto 0);--Offset  [15-0] after sign ex
		RT_ADDR			: in STD_LOGIC_VECTOR (4 downto 0);	--RT [20-16]
		RD_ADDR			: in STD_LOGIC_VECTOR (4 downto 0);	--RD [15-11]
		OPERAND_A		: in STD_LOGIC_VECTOR (1 downto 0);--from FU
		OPERAND_B		: in STD_LOGIC_VECTOR (1 downto 0);--from FU
		DATA_FROM_MEM_FU: in std_logic_vector (31 downto 0);-- for mux after FU
		DATA_FROM_WB_FU	: in std_logic_vector (31 downto 0);-- for mux after FU

				     	      
		--outputs
		WB_CR_OUT		: out WB_CTRL_REG;	--hold until WB stage
		MEM_CR_OUT		: out MEM_CTRL_REG;	--hold until MEM stage
		ALU_RES_OUT		: out STD_LOGIC_VECTOR(31 downto 0);--ALU result
		RT_OUT			: out STD_LOGIC_VECTOR (31 downto 0);--It will enter as Write Data in the MEM stage 
		RT_RD_ADDR_OUT	: out STD_LOGIC_VECTOR (4 downto 0)	--hold until WB stage			
	);
end EXECUTION;

architecture arc_execution of EXECUTION is
	
	signal ALU_IN_AUX		: ALU_INPUT;
	signal RT_RD_ADDR_AUX	: STD_LOGIC_VECTOR (4 downto 0);
	signal ALU_REG_IN		: STD_LOGIC_VECTOR (31 downto 0); 
	signal ALU_REG_IN2		: STD_LOGIC_VECTOR (31 downto 0);
	signal ALU_REG_IN3		: STD_LOGIC_VECTOR (31 downto 0); 
	signal ALU_RES_AUX		: STD_LOGIC_VECTOR (31 downto 0); 
	
	begin
	
	ALU_CTRL:
		entity work.ALU_CONTROL 
		port map(
			CLK			=> CLK,
			FUNCT		=> OFFSET(5 downto 0),
			ALU_OP_IN	=> EX_CR.ALUOp,
		    ALU_IN		=> ALU_IN_AUX
		);
		
	MUX_RT_RD:
		process(EX_CR.RegDst,RT_ADDR,RD_ADDR) is
    		begin
    	 		if( EX_CR.RegDst = '0') then
    	 			RT_RD_ADDR_AUX <= RT_ADDR; 
	    	 	else
    		 		RT_RD_ADDR_AUX <= RD_ADDR;
    		 	end if;
    	 	end process MUX_RT_RD;
	 
	MUX_ALU1:
			process(RS,OPERAND_A,DATA_FROM_WB_FU,DATA_FROM_MEM_FU) is
    		begin
    	 		if( OPERAND_A = "00") then
    	 			ALU_REG_IN2 <= RS; 
	    	 	elsif (OPERAND_A = "01") then--2a
    		 		ALU_REG_IN2 <= DATA_FROM_WB_FU;
				elsif (OPERAND_A = "10") then--1a
				ALU_REG_IN2 <= DATA_FROM_MEM_FU;
				else
				ALU_REG_IN2 <= RS;
    		 	end if;
    	 	end process MUX_ALU1;
	
	MUX_ALU2:
				process(RT,OPERAND_B,DATA_FROM_WB_FU,DATA_FROM_MEM_FU) is
				begin
    	 		if( OPERAND_B = "00") then
    	 			ALU_REG_IN <= RT; 
	    	 	elsif (OPERAND_B = "01") then--2b
    		 		ALU_REG_IN <= DATA_FROM_WB_FU;
				elsif (OPERAND_B = "10") then--1b
				ALU_REG_IN <= DATA_FROM_MEM_FU;
				else
				ALU_REG_IN <= RT;
    		 	end if;
    	 	end process MUX_ALU2;				
				
 MUX_ALU:	process(EX_CR.AluSrc,ALU_REG_IN,RT,OFFSET)--connecting mux b to   
		begin                                     -- 
			if( EX_CR.AluSrc = '0') then
				ALU_REG_IN3 <= ALU_REG_IN; 
			else
				ALU_REG_IN3 <= OFFSET;
			end if;
		end process MUX_ALU;
		
	 
	ALU_MIPS: 
		
		entity work.ALU 
		port map(
			X		=> ALU_REG_IN2,
			Y		=> ALU_REG_IN3,
			ALU_IN	=> ALU_IN_AUX,
			R		=> ALU_RES_AUX
		);

	EX_MEM_REGS:
		 entity work.EX_MEM_REGISTERS 
		 port map(
			--inputs
			CLK				=> CLK,
			RESET			=> RESET,
			WB_CR_IN		=> WB_CR,
			MEM_CR_IN		=> MEM_CR,
			ALU_RES_IN		=> ALU_RES_AUX,
			RT_IN			=> RT,
			RT_RD_ADDR_IN	=> RT_RD_ADDR_AUX,	
			--outputs
			WB_CR_OUT		=> WB_CR_OUT,
			MEM_CR_OUT		=> MEM_CR_OUT,
			ALU_RES_OUT		=> ALU_RES_OUT,
			RT_OUT			=> RT_OUT,
			RT_RD_ADDR_OUT	=> RT_RD_ADDR_OUT	
		);

end arc_execution;
	