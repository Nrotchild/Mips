library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.records_pkg.all;

entity MEMORY_ACCESS is
	port( 
		--inputs
		CLK				: in STD_LOGIC;					
		RESET			: in STD_LOGIC;					
		WB_IN			: in WB_CTRL_REG;--hold until WB stage
		MEM				: in MEM_CTRL_REG;	--These signals will be used at this stage
		ADDRESS_IN		: in STD_LOGIC_VECTOR (31 downto 0);--data memory address - from alu
		WRITE_DATA		: in STD_LOGIC_VECTOR (31 downto 0);--data to write
		WRITE_REG_IN	: in STD_LOGIC_VECTOR (4 downto 0);	--Write Register number
		--outputs to WB stage
		WB_OUT			: out WB_CTRL_REG; --hold until WB stage
		READ_DATA		: out STD_LOGIC_VECTOR (31 downto 0);--Data read from memory
		ADDRESS_OUT		: out STD_LOGIC_VECTOR (31 downto 0);--ALU Result
		WRITE_REG_OUT	: out STD_LOGIC_VECTOR (4 downto 0)--write Register number
	);
end MEMORY_ACCESS;

architecture MEMORY_ACCESS_ARC of MEMORY_ACCESS is
	
	signal READ_DATA_AUX : STD_LOGIC_VECTOR (31 downto 0);
 
begin

	DAT_MEM:--memory
		
	 	entity work.DATA_MEMORY 
		port map(
			RESET		=> RESET,
			ADDR		=> ADDRESS_IN,
			WRITE_DATA	=> WRITE_DATA,
			MemRead		=> MEM.MemRead,
			MemWrite	=> MEM.MemWrite,
			READ_DATA	=> READ_DATA_AUX

		);
	
	MEM_WB_REGS:--pipe4
		entity work.MEM_WB_REGISTERS 
		port map(
			--inputs
			CLK				=> CLK,
			RESET			=> RESET,
			WB				=> WB_IN,
			READ_DATA		=> READ_DATA_AUX,
			ADDRESS			=> ADDRESS_IN,
			WRITE_REG		=> WRITE_REG_IN,
			--outputs
			WB_OUT			=> WB_OUT,
			READ_DATA_OUT	=> READ_DATA,
			ADDRESS_OUT		=> ADDRESS_OUT,	
			WRITE_REG_OUT	=> WRITE_REG_OUT 
		);


end MEMORY_ACCESS_ARC;
	 