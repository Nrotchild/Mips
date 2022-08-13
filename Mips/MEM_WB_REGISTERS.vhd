library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.REC_pkg.all;

entity MEM_WB_REGISTERS is
 	port(
		--inputs
		CLK				: in STD_LOGIC;
		RESET			: in STD_LOGIC;
		WB				: in WB_CTRL_REG;
		READ_DATA		: in STD_LOGIC_VECTOR (31 downto 0);
		ADDRESS			: in STD_LOGIC_VECTOR (31 downto 0);
		WRITE_REG		: in STD_LOGIC_VECTOR (4 downto 0);	
		--outputs
		WB_OUT			: out WB_CTRL_REG;
		READ_DATA_OUT	: out STD_LOGIC_VECTOR (31 downto 0);
		ADDRESS_OUT		: out STD_LOGIC_VECTOR (31 downto 0);
		WRITE_REG_OUT	: out STD_LOGIC_VECTOR (4 downto 0)
	);
end MEM_WB_REGISTERS;

architecture MEM_WB_REGISTERS_ARC of MEM_WB_REGISTERS is        
begin
	SYNC_MEM_WB:
		process(CLK,RESET,WB,READ_DATA,ADDRESS,WRITE_REG)
		begin
			if RESET = '1' then
			    WB_OUT			<= ('0','0');
				READ_DATA_OUT	<= x"00000000";
				ADDRESS_OUT		<= x"00000000";
				WRITE_REG_OUT	<= "00000";
			elsif rising_edge(CLK) then
			    WB_OUT			<= WB;
				READ_DATA_OUT	<= READ_DATA;
				ADDRESS_OUT		<= ADDRESS;
				WRITE_REG_OUT	<= WRITE_REG;
			end if;
		end process; 

end MEM_WB_REGISTERS_ARC;