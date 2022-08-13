library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.records_pkg.all;

entity WRITE_BACK is
port( 
	--inputs
	RESET			: in STD_LOGIC;				
	WB				: in WB_CTRL_REG;				
	READ_DATA		: in STD_LOGIC_VECTOR (31 downto 0);	
	ADDRESS			: in STD_LOGIC_VECTOR (31 downto 0);	
	WRITE_REG		: in STD_LOGIC_VECTOR (4 downto 0);			
	--Outputs to ID stage
	RegWrite		: out STD_LOGIC;			
	WRITE_REG_OUT	: out STD_LOGIC_VECTOR (4 downto 0);	
	WRITE_DATA		: out STD_LOGIC_VECTOR (31 downto 0)	 			
);
end WRITE_BACK;

architecture WRITE_BACK_ARC of WRITE_BACK is 
begin

	MUX_WB: 
		process(RESET,WB.RegWrite,WRITE_REG,WB.MemtoReg,ADDRESS,READ_DATA)
		begin
			if( RESET = '1') then
				RegWrite <= '0';
				WRITE_REG_OUT <= "00000"; 
				WRITE_DATA <= x"00000000"; 
			else                               ---WB mux
				RegWrite <= WB.RegWrite;
				WRITE_REG_OUT <= WRITE_REG;
			 	if( WB.MemtoReg = '0') then
			 		WRITE_DATA <= ADDRESS; 
			 	else
			 		WRITE_DATA <= READ_DATA;
			 	end if;
			end if;
		 end process MUX_WB;
		 
end WRITE_BACK_ARC;