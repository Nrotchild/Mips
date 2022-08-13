library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all; 
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
library work;
use work.REC_pkg.all;

entity INSTRUCTION_DECODING is

	port(
			CLK				:	in	STD_LOGIC;	
			RESET			:	in	STD_LOGIC;				
			--Instruction Fetch stage inputs (IF)
			INSTRUCTION		:	in	STD_LOGIC_VECTOR (31 downto 0);
			NEW_PC_ADDR_IN	:	in	STD_LOGIC_VECTOR (31 downto 0);-- pc+4
			-- Entries (WB)	  
			RegWrite		:	in	STD_LOGIC;	--enable		 
			WRITE_DATA		:	in	STD_LOGIC_VECTOR (31 downto 0);--Data to be written
			WRITE_REG 		:	in	STD_LOGIC_VECTOR (4 downto 0);--Register number Rd
			--input enable when hazard detection is on
			STALL_HAZARD	:	in std_logic;
			--Outputs of the Instruction fetch stage (IF)
			NEW_PC_ADDR_OUT	:	out	STD_LOGIC_VECTOR (31 downto 0);--New PC address
			--Outputs generated from the instruction
			OFFSET			:	out	STD_LOGIC_VECTOR (31 downto 0);--Instruction Offset[15-0] after sign extent
			RT_ADDR			:	out	STD_LOGIC_VECTOR (4 downto 0);-- RT [20-16]
			RD_ADDR			:	out	STD_LOGIC_VECTOR (4 downto 0);-- RD [15-11]
			RS_ADDR 		:	out std_logic_vector (4 downto 0); -- RS [25-21]
			--Outputs from the registers group(bor)
			RS	 			:	out	STD_LOGIC_VECTOR (31 downto 0);--data of RS
			RT 				:	out	STD_LOGIC_VECTOR (31 downto 0);--data of RT
			--Control Unit Outputs
			WB_CR			:	out	WB_CTRL_REG;	--hold until WB stage
			MEM_CR			:	out	MEM_CTRL_REG;	--hold until MEM stage
			EX_CR			:	out	EX_CTRL_REG;		--hold until EX stage 
			---for branch--
			PCSrc			:   out STD_LOGIC;
			-- for jump
			JUMP_ADDR		:	out std_logic_vector(31 downto 0);	
			JUMP_EN			:	out std_logic
			
	);
end INSTRUCTION_DECODING;

architecture INSTRUCTION_DECODING_ARC of INSTRUCTION_DECODING is	
	--signals
	signal OFFSET_AUX		: STD_LOGIC_VECTOR (31 downto 0);
	signal OFFSET_AUX2		: STD_LOGIC_VECTOR (31 downto 0);
	signal RS_AUX			: STD_LOGIC_VECTOR (31 downto 0);
	signal RT_AUX			: STD_LOGIC_VECTOR (31 downto 0);
	signal AUX  			: std_logic_vector (31 downto 0);
	signal WB_AUX			: WB_CTRL_REG;
	signal MEM_AUX			: MEM_CTRL_REG;
	signal EX_AUX			: EX_CTRL_REG;

begin
--calc of jump address
JUMP_ADDR <= NEW_PC_ADDR_IN(31 downto 28) & INSTRUCTION(25 downto 0) & "00";
	--Port maps--
	REGS: 
		entity work.REGISTERS 
		port map(
			CLK 		=> CLK,
			RESET		=> RESET,
			RW			=> RegWrite,
			RS_ADDR 	=> INSTRUCTION(25 downto 21),
			RT_ADDR 	=> INSTRUCTION(20 downto 16),
			RD_ADDR 	=> WRITE_REG,
			WRITE_DATA	=> WRITE_DATA,
			RS 			=> RS_AUX,
			RT 			=> RT_AUX
		);
        
	CTRL : 
		entity work.CONTROL_UNIT 
		port map(
			--input 	
			OP			=> INSTRUCTION(31 downto 26),--OP_A,
			STALL_HAZARD=>STALL_HAZARD,
			--outputs
			RegWrite	=> WB_AUX.RegWrite,
			MemtoReg	=> WB_AUX.MemtoReg,
			Brach		=> MEM_AUX.Branch,
			MemRead		=> MEM_AUX.MemRead,
			MemWrite	=> MEM_AUX.MemWrite,
			RegDst		=> EX_AUX.RegDst,
			JUMP		=> JUMP_EN,
			ALUSrc		=> EX_AUX.ALUSrc,
		  	ALUOp0		=> EX_AUX.ALUOp.Op0,
			ALUOp1		=> EX_AUX.ALUOp.Op1
			);
			
	            --------sing extent----------
		
		OFFSET_AUX	<=  "0000000000000000" & INSTRUCTION(15 downto 0)
			when INSTRUCTION(15) = '0'
				else  "1111111111111111" & INSTRUCTION(15 downto 0);
		
		OFFSET_AUX2 <= OFFSET_AUX(29 downto 0) & "00" + NEW_PC_ADDR_IN  ; --shift left 2 + PC+4 -- for beq
		
		
		
	OUT_Branch:	---chack if branch target
		process(RESET,RS_AUX,RT_AUX,OFFSET_AUX2,NEW_PC_ADDR_IN)
		begin
			if( RESET = '1') then
				PCSrc <= '0';
				NEW_PC_ADDR_OUT <= x"00000000";
			
			elsif((RS_AUX = RT_AUX) and (MEM_AUX.Branch = '1')) then
					PCSrc <= '1';
					NEW_PC_ADDR_OUT <= OFFSET_AUX2;
					
				else
					NEW_PC_ADDR_OUT <= NEW_PC_ADDR_IN;
					PCSrc <= '0';
				
			end if;
		end process OUT_Branch;



	ID_EX_REGS:
		entity work.ID_EX_REGISTERS 
		port map(
			--inputs
			CLK				=> CLK,
			RESET			=> RESET,
			--NEW_PC_ADDR_IN	=> NEW_PC_ADDR_IN,
			OFFSET_IN		=> OFFSET_AUX,
			RT_ADDR_IN		=> INSTRUCTION(20 downto 16),
			RD_ADDR_IN		=> INSTRUCTION(15 downto 11),
			RS_ADDR_IN		=> INSTRUCTION(25 downto 21),
			RS_IN			=> RS_AUX,
			RT_IN			=> RT_AUX,
			WB_IN			=> WB_AUX,
			M_IN			=> MEM_AUX,
			EX_IN			=> EX_AUX,
			--outputs
			--NEW_PC_ADDR_OUT	=> NEW_PC_ADDR_OUT,
			OFFSET_OUT		=> OFFSET,
			RT_ADDR_OUT		=> RT_ADDR,
			RD_ADDR_OUT		=> RD_ADDR,
			RS_ADDR_OUT		=> RS_ADDR,
			RS_OUT			=> RS,
			RT_OUT			=> RT,
			WB_OUT			=> WB_CR,
			M_OUT			=> MEM_CR,
			EX_OUT			=> EX_CR
		);	

end INSTRUCTION_DECODING_ARC;