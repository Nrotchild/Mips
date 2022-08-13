library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all; 
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.REC_pkg.all;

entity PIPELINE_MIPS is
	port(
		CLK 	: in STD_LOGIC;
		RESET	: in STD_LOGIC
	);
end PIPELINE_MIPS;

architecture PIPELINE_MIPS_ARC of PIPELINE_MIPS is		
	     --------signals--------
				
		-- MEM/IF
		signal PCSrc_AUX			: STD_LOGIC;
		signal NEW_PC_ADDR_AUX4		: STD_LOGIC_vector (31 downto 0);
		-- IF/ID
		signal NEW_PC_ADDR_AUX1		: STD_LOGIC_vector (31 downto 0);
		signal INSTRUCTION_AUX		: STD_LOGIC_vector (31 downto 0);
		signal JUMP					:STD_LOGIC;
		signal JUMP_ADDR			: STD_LOGIC_vector (31 downto 0);
		-- WB/ID
		signal RegWrite_AUX			: STD_LOGIC;
		signal WRITE_REG_AUX2		: STD_LOGIC_vector (4 downto 0);
		signal WRITE_DATA_AUX		: STD_LOGIC_vector (31 downto 0);
		-- ID/EX
		signal NEW_PC_ADDR_AUX2		: STD_LOGIC_vector (31 downto 0);
		signal OFFSET_AUX			: STD_LOGIC_vector (31 downto 0);
		signal RT_ADDR_AUX			: STD_LOGIC_vector (4 downto 0);
		signal RD_ADDR_AUX 			: STD_LOGIC_vector (4 downto 0);
		signal RS_ADDR_AUX			: STD_LOGIC_vector (4 downto 0);
		signal RS_AUX	 			: STD_LOGIC_vector (31 downto 0);
		signal RT_AUX1 				: STD_LOGIC_vector (31 downto 0);
		signal WB_CR_AUX1			: WB_CTRL_REG;
		signal MEM_CR_AUX1			: MEM_CTRL_REG;
		signal EX_CR_AUX			: EX_CTRL_REG;
		-- EX/MEM
		signal WB_CR_AUX2			: WB_CTRL_REG;
		signal MEM_CR_AUX2			: MEM_CTRL_REG;
		signal NEW_PC_ADDR_AUX3		: STD_LOGIC_vector (31 downto 0);
		signal ALU_FLAGS_AUX		: std_logic;
		signal ALU_RES_AUX			: STD_LOGIC_vector (31 downto 0);
		signal RT_AUX2				: STD_LOGIC_vector (31 downto 0);
		signal RT_RD_ADDR_AUX		: STD_LOGIC_vector (4 downto 0);
		--MEM/WB
		signal WB_CR_AUX3			: WB_CTRL_REG;
		signal READ_DATA_AUX		: STD_LOGIC_vector (31 downto 0);
		signal ADDRESS_AUX			: STD_LOGIC_vector (31 downto 0);
		signal WRITE_REG_AUX1		: STD_LOGIC_vector (4 downto 0);	
		--hazards
		signal fordward_a_aux	    : std_logic_vector (1 downto 0);
		signal fordward_b_aux    	: std_logic_vector (1 downto 0);
		signal stall_hazard         : STD_LOGIC; -- when 1 disable pc clock, IF/ID register clock and assign controll signals 0
	 
begin

	--------Port maps---------
			
	INST_FETCH:
		entity work.Fetch 
		port map(
			--inputs
			CLK				=> CLK,
			RESET			=> RESET,
			PCSrc			=> PCSrc_AUX,
			NEW_PC_ADDR_IN	=> NEW_PC_ADDR_AUX2,
			JUMP_ADDR		=>	JUMP_ADDR,
			JUMP_EN			=> JUMP,
			stall_hazard    => stall_hazard,
			inst_curr_stall=>INSTRUCTION_AUX,
			--outputs
			NEW_PC_ADDR_OUT	=> NEW_PC_ADDR_AUX1,
			INSTRUCTION		=> INSTRUCTION_AUX
		);	

	INST_DECODE:
		entity work.INSTRUCTION_DECODING 
		port map(
			--INPUTS
			CLK				=> CLK,
			RESET			=> RESET,
			INSTRUCTION		=> INSTRUCTION_AUX,
			NEW_PC_ADDR_IN	=> NEW_PC_ADDR_AUX1,
			RegWrite		=> RegWrite_AUX,  
			WRITE_DATA		=> WRITE_DATA_AUX, 
			WRITE_REG 		=> WRITE_REG_AUX2,
			stall_hazard    => stall_hazard,
			--OUPUTS
			NEW_PC_ADDR_OUT	=> NEW_PC_ADDR_AUX2,
			OFFSET			=> OFFSET_AUX,
			RT_ADDR			=> RT_ADDR_AUX,
			RD_ADDR			=> RD_ADDR_AUX,
			RS_ADDR         => RS_ADDR_AUX,
			RS 				=> RS_AUX,
			RT 				=> RT_AUX1,
			WB_CR			=> WB_CR_AUX1,
			MEM_CR			=> MEM_CR_AUX1,
			JUMP_ADDR		=>	JUMP_ADDR,
			JUMP_EN			=> JUMP,
			PCSrc			=> PCSrc_AUX,
			EX_CR			=> EX_CR_AUX
			);

	EXE:
		entity work.EXECUTION 
		port map( 
			--INPUTS
			CLK				=> CLK,
			RESET			=> RESET,
			WB_CR			=> WB_CR_AUX1,
			MEM_CR			=> MEM_CR_AUX1,
			EX_CR			=> EX_CR_AUX, 	     	
			RS	 			=> RS_AUX,
		    RT 				=> RT_AUX1,
			OFFSET			=> OFFSET_AUX,
			RT_ADDR			=> RT_ADDR_AUX,
			RD_ADDR			=> RD_ADDR_AUX,
			OPERAND_A       => fordward_a_aux,
			OPERAND_B       => fordward_b_aux,
			DATA_FROM_MEM_FU=> ALU_RES_AUX,
			DATA_FROM_WB_FU => WRITE_DATA_AUX,
			--OUTPUTS
			WB_CR_OUT		=> WB_CR_AUX2,
			MEM_CR_OUT		=> MEM_CR_AUX2,
			ALU_RES_OUT		=> ALU_RES_AUX,
			RT_OUT			=> RT_AUX2,
			RT_RD_ADDR_OUT	=> RT_RD_ADDR_AUX
		);

	MEM_ACC:
		entity work.MEMORY_ACCESS 
		port map( 
			--INPUTS
			CLK				=> CLK,
			RESET			=> RESET,
			WB_IN			=> WB_CR_AUX2,
			MEM				=> MEM_CR_AUX2,
			ADDRESS_IN		=> ALU_RES_AUX,
			WRITE_DATA		=> RT_AUX2,
			WRITE_REG_IN	=> RT_RD_ADDR_AUX,
			--Outputs to the WB stage
			WB_OUT			=> WB_CR_AUX3,
			READ_DATA		=> READ_DATA_AUX,
			ADDRESS_OUT		=> ADDRESS_AUX,
			WRITE_REG_OUT	=> WRITE_REG_AUX1
		);

	WR_BK:
		entity work.WRITE_BACK 
		port map( 
			--INPUTS			
			RESET			=> RESET,
			WB				=> WB_CR_AUX3,
			READ_DATA		=> READ_DATA_AUX,
			ADDRESS			=> ADDRESS_AUX,
			WRITE_REG		=> WRITE_REG_AUX1,
			--Outputs to ID stages
			RegWrite		=> RegWrite_AUX,
			WRITE_REG_OUT	=> WRITE_REG_AUX2,
			WRITE_DATA		=> WRITE_DATA_AUX
		);
		

	  MIPSfwd : 
	  entity work.forwarding_unit
		port map (
	 -- inputs
		ex_mem_regWrite => WB_CR_AUX2.RegWrite,--4
		ex_mem_registerRd => RT_RD_ADDR_AUX,
		
		mem_wb_regWrite => WB_CR_AUX3.RegWrite,--5
		mem_wb_registerRd => WRITE_REG_AUX1,

		id_ex_registerRs => RS_ADDR_AUX,
		id_ex_registerRt => RT_ADDR_AUX,
	-- outputs
 
		fordward_a => fordward_a_aux,
		fordward_b => fordward_b_aux
      );
	  
	  	MIPShazard_detector : entity work.hazard_detector
    port map (
				memory_read => MEM_CR_AUX1.MemRead,
				EX_reg_write => RT_ADDR_AUX, -- destination register of load instruction
				ID_reg_a => INSTRUCTION_AUX(25 downto 21),-- operand a of instruction in decode stage(RS)
				ID_reg_b => INSTRUCTION_AUX(20 downto 16), -- operand b of instruction in decode(RT)
				stall_pipeline => stall_hazard
	 );
		

end PIPELINE_MIPS_ARC;	