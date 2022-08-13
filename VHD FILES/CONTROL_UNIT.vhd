library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity CONTROL_UNIT is
	port( 
	
		OP				: in	STD_LOGIC_VECTOR (5 downto 0);
		STALL_HAZARD	: in	std_logic;
		RegWrite		: out	STD_LOGIC; 				--enable (RegWrite)
		MemtoReg		: out	STD_LOGIC;  			--enable  (MemToReg)
		Brach			: out	STD_LOGIC; 				--enable  (Branch)
		MemRead			: out	STD_LOGIC; 				--enable  (MemRead)
		MemWrite		: out	STD_LOGIC; 				--enable  (MemWrite)
		RegDst			: out	STD_LOGIC; 				--enable  (RegDst)
		JUMP			: out	STD_LOGIC; 				--enable  (JUMP)
		ALUSrc			: out	STD_LOGIC;				--enable  (ALUSrc)
		ALUOp0			: out	STD_LOGIC; 				--enable  (ALUOp0)
		ALUOP1			: out	STD_LOGIC 				--enable  (ALUOP)

	);
end CONTROL_UNIT;


architecture CONTROL_UNIT_ARC of CONTROL_UNIT is  
	
begin	

process(STALL_HAZARD,OP) is begin
				--default values for control signals
			if(STALL_HAZARD='1') then --only if load use
				regdst <= '0'; 
				brach <= '0';
				memread <= '0';
				memtoreg <= '0';
				aluop0 <= '0';
				aluop1 <= '0';
				memwrite <= '0';
				alusrc <= '0';
				regwrite <= '0';
				jump <= '0';
			elsif (OP = "000000") then -- R execution
				regdst <= '1';
				aluop0 <= '0';
				aluop1 <= '1';
				regwrite <= '1';
				memtoreg <= '0';
				brach <= '0';
				memread <= '0';
				memwrite <= '0';
				alusrc <= '0';
				jump <= '0';
			elsif (OP = "000010") then -- J execution
				jump <= '1';
				regdst <= '0'; 
				brach <= '0';
				memread <= '0';
				memtoreg <= '0';
				aluop0 <= '0';
				aluop1 <= '0';
				memwrite <= '0';
				alusrc <= '0';
				regwrite <= '0';
			elsif (OP = "100011") then -- LOAD execution
				regwrite <= '1';
				memread <= '1';
				alusrc <= '1';
				regdst <= '0'; 
				brach <= '0';
				memtoreg <= '1';
				aluop0 <= '0';
				aluop1 <= '0';
				memwrite <= '0';
				jump <= '0';
			elsif (OP = "101011") then -- STORE execution
				alusrc <= '1';
				memwrite <= '1';
				regdst <= '0'; 
				brach <= '0';
				memread <= '0';
				memtoreg <= '0';
				aluop0 <= '0';
				aluop1 <= '0';
				regwrite <= '0';
				jump <= '0';
			elsif (OP = "000100") then -- BRANCH execution
				brach <= '1';
				aluop0 <= '1';
				aluop1 <= '0';
				regdst <= '0'; 
				memread <= '0';
				memtoreg <= '0';
				memwrite <= '0';
				alusrc <= '0';
				regwrite <= '0';
				jump <= '0';
			else
				regdst <= '0'; 
				brach <= '0';
				memread <= '0';
				memtoreg <= '0';
				aluop0 <= '0';
				aluop1 <= '0';
				memwrite <= '0';
				alusrc <= '0';
				regwrite <= '0';
				jump <= '0';
			end if;
end process;
		
			
end CONTROL_UNIT_ARC;