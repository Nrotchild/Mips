library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.REC_pkg.all;

entity ID_EX_REGISTERS is 
	port(
		--inputs
		CLK					: in	STD_LOGIC;				 
		RESET				: in	STD_LOGIC;				
		--Outputs generated from the instruction
		OFFSET_IN			: in	STD_LOGIC_VECTOR (31 downto 0);-- Offset [15-0]
		RT_ADDR_IN			: in	STD_LOGIC_VECTOR (4 downto 0);--  RT [20-16]
		RD_ADDR_IN			: in	STD_LOGIC_VECTOR (4 downto 0);--  RD [15-11]
		RS_ADDR_IN			: in	STD_LOGIC_VECTOR (4 downto 0);--  RD [26-21]
		--Outputs from the registers group (bor)
		RS_IN	 			: in	STD_LOGIC_VECTOR (31 downto 0); -- data of rs
		RT_IN 				: in	STD_LOGIC_VECTOR (31 downto 0);-- data of rt
		--outputs from the control unit
		WB_IN				: in	WB_CTRL_REG;	-- Control signals WB stage
		M_IN				: in	MEM_CTRL_REG;	-- Control signals MEM stage
		EX_IN				: in	EX_CTRL_REG;	-- Control signals EX stage
		--outputs
		--Outputs of the Instruction fetch stage (IF)
		OFFSET_OUT			: out	STD_LOGIC_VECTOR (31 downto 0);-- Offset [15-0]
		RS_ADDR_OUT			: out	STD_LOGIC_VECTOR (4 downto 0);--  RD [26-21]		
		RT_ADDR_OUT			: out	STD_LOGIC_VECTOR (4 downto 0);-- RT [20-16]
		RD_ADDR_OUT			: out	STD_LOGIC_VECTOR (4 downto 0);-- RD [15-11]
		--Outputs from the registers group (bor)
		RS_OUT	 			: out	STD_LOGIC_VECTOR (31 downto 0);--data Rs
		RT_OUT 				: out	STD_LOGIC_VECTOR (31 downto 0);--data Rt
		--outputs from the control unit
		WB_OUT				: out	WB_CTRL_REG;	-- Control signals WB stage
		M_OUT				: out	MEM_CTRL_REG;	-- Control signals MEM stage
		EX_OUT				: out	EX_CTRL_REG	    -- Control signals EX stage
	);
end ID_EX_REGISTERS;

architecture ID_EX_REGISTERS_ARC of ID_EX_REGISTERS is
begin
	SYNC_ID_EX:
	  process(CLK,RESET,OFFSET_IN,RT_ADDR_IN,RD_ADDR_IN,RS_IN,RT_IN,WB_IN,M_IN,EX_IN)
	  begin
		if RESET = '1' then
				
				OFFSET_OUT		<= (others => '0');
				RS_ADDR_OUT		<= (others => '0');				
				RT_ADDR_OUT		<= (others => '0');
				RD_ADDR_OUT		<= (others => '0');
				RS_OUT	 		<= (others => '0');
				RT_OUT 			<= (others => '0');
				WB_OUT			<= ('0','0');
				M_OUT			<= ('0','0','0');
				EX_OUT			<= ('0',('0','0'),'0'); --2 kinds of typs
				
		elsif rising_edge(CLK) then
		
				OFFSET_OUT		<= OFFSET_IN;
				RS_ADDR_OUT		<= RS_ADDR_IN;
				RT_ADDR_OUT		<= RT_ADDR_IN;
				RD_ADDR_OUT		<= RD_ADDR_IN;	
				RS_OUT	 		<= RS_IN;
				RT_OUT 			<= RT_IN;
				WB_OUT			<= WB_IN;
				M_OUT			<= M_IN;
				EX_OUT			<= EX_IN;
		end if;
	  end process;

end ID_EX_REGISTERS_ARC;