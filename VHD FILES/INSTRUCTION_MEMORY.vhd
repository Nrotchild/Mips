library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTRUCTION_MEMORY is
	port(
			RESET		: in	STD_LOGIC;						
  			READ_ADDR	: in	STD_LOGIC_VECTOR (31 downto 0);--Address of the instruction to read
  			INST		: out	STD_LOGIC_VECTOR (31 downto 0)	--Instruction read	
	);
end INSTRUCTION_MEMORY;


architecture INSTRUCTION_MEMORY_ARC of INSTRUCTION_MEMORY is
   
begin

	
	process(READ_ADDR)
	begin
		case READ_ADDR is
			when "00000000000000000000000000000000" => --pc=0
				INST <= "00000001010000000010000000100000";--add $4,$10,$0 --$4=10--
			when "00000000000000000000000000000100" => --pc=4
				INST <= "00000000101010000001000000100000";--add $2,$5,$8 --$2=13--
			when "00000000000000000000000000001000" => --pc=8
				INST <= "00000001001000010001100000100010";--sub $3,$9,$1 --$3=8--
			when "00000000000000000000000000001100" => --pc=12
				INST <= "00000000110000000011100000100010";--sub $7,$6,$0 --$7=6--
			when "00000000000000000000000000010000" => --pc=16
				INST <= "10001100000101010000000000000000";--LW $21,add($0)
			when "00000000000000000000000000010100" => --pc=20
				INST <= "00010000100010100000000000000010";--beq $4,$10,8 if $4=$10 goto pc+4+2*4 
			when "00000000000000000000000000011000" => --pc=24 --- ==>00000000000000000000000000100000 goto --add $24,$6,$15
				INST <= "10101100000001000000001111111111";--sw $4,add($0)  put in mem[1023] the value of $4=10 --skip
			when "00000000000000000000000000011100" => --pc=28
				INST <= "00000011100111010111100000100010";--sub $15,$28,$29 --$15=-1-- skip
			when "00000000000000000000000000100000" => --pc=32
				INST <= "00000000110011111100000000100000";--add $24,$6,$15 --$24=21
			when "00000000000000000000000000100100" =>   --pc=36           				
				INST <= "00000000001011111011000000100000";--add $22,$1,$15  %22=16--
				
			when others => 
				INST <= "11111111111111111111111111111111";--others
		end case;

	end process;

	
end INSTRUCTION_MEMORY_ARC;