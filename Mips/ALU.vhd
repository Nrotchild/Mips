library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.all;
library work;
use work.REC_pkg.all;
entity ALU is
port(
			X			: in STD_LOGIC_VECTOR(31 downto 0);
			Y			: in STD_LOGIC_VECTOR(31 downto 0);
			ALU_IN		: in ALU_INPUT;
			R			: out STD_LOGIC_VECTOR(31 downto 0)
 );
end ALU;

architecture ARC_ALU of ALU is

signal result: std_logic_vector(31 downto 0);
signal ALU_INPUTS : std_logic_vector(2 downto 0);

begin
	ALU_INPUTS(2) <= ALU_IN.op2;
	ALU_INPUTS(1) <= ALU_IN.op1;
	ALU_INPUTS(0) <= ALU_IN.op0;
	process (ALU_INPUTS,X,Y)
	begin
	case ALU_INPUTS is
	
			when "000" =>
				result <= X and Y; 
			when "001" =>
				result <= X or Y; 
			when "010" => 
				result <= X + Y; -- add
			when "110" => 
				result <= X - Y; -- sub
			when "111" => 
		  if (X<Y) then
				result <= x"00000001";
		  else
				result <= x"00000000";
		  end if;		  
	when others =>	result <= x"FFFFFFFF";
	end case;
end process;
	R  <= result;
end ARC_ALU;