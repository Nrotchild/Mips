library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
	
entity hazard_detector is
    Port ( 
		memory_read     : in  STD_LOGIC;--enable
		EX_reg_write    : in STD_LOGIC_VECTOR(4 downto 0); --destination register of LW (RT)
		ID_reg_a        : in STD_LOGIC_VECTOR(4 downto 0); -- operand a of instruction in decode stage(RS)
		ID_reg_b        : in STD_LOGIC_VECTOR(4 downto 0); -- operand b of instruction in decode stage(RT)
		stall_pipeline  : out STD_LOGIC
	 );
end hazard_detector;

architecture Behavioral of hazard_detector is
		

begin
	stall_pipeline <= '1' when 
	((EX_reg_write = ID_reg_a) or (EX_reg_write = ID_reg_b))
	and (EX_reg_write /= "00000")
	and (memory_read = '1')
	
	else '0';
	
end Behavioral;