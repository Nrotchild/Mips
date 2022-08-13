--Fetch Unit--
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all; 
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Fetch is
port(

clk  			: in std_logic;
reset  			: in std_logic;
PCSrc			: in std_logic; --enable
JUMP_ADDR		: in std_logic_vector(31 downto 0);	
JUMP_EN			: in std_logic;
new_pc_addr_in	: in std_logic_vector(31 downto 0);-- input from pc mux
stall_hazard 	: in STD_LOGIC;
inst_curr_stall : in std_logic_vector(31 downto 0);--for stall
new_pc_addr_out	: out std_logic_vector(31 downto 0);--output from pc
instruction 	: out std_logic_vector(31 downto 0)--instruction mem output


);

end Fetch;

architecture arc_fetch of Fetch is

         ------------------signals------------------
	signal PC_ADDR_AUX1		: std_logic_vector(31 downto 0);	
	signal PC_ADDR_AUX2		: std_logic_vector(31 downto 0);
	signal PC_ADDR_AUX3		: std_logic_vector(31 downto 0);
	signal PC_ADDR_AUX4		: std_logic_vector(31 downto 0);
	signal INST_AUX			: std_logic_vector(31 downto 0);
	signal INST_AUX_STALL	: STD_LOGIC_VECTOR(31 downto 0);

	
	begin
	
	PC_ADDR_AUX2 <= PC_ADDR_AUX1 + "00000000000000000000000000000100"; --pc+4
	
	MUX_PC:
		process(clk,PCSrc,PC_ADDR_AUX2,NEW_PC_ADDR_IN,stall_hazard,INST_AUX)
		begin
			if (stall_hazard = '1') then	
				PC_ADDR_AUX3 <= PC_ADDR_AUX1;
			elsif ( PCSrc = '0') then
				if (INST_AUX(31 downto 26) /= "000100") then 
					PC_ADDR_AUX3 <= PC_ADDR_AUX2;
				else
					PC_ADDR_AUX3 <= PC_ADDR_AUX1;
					end if;
			else
				PC_ADDR_AUX3 <= NEW_PC_ADDR_IN;
				
			end if;
		end process MUX_PC; 

			
		
	MUX_PC2: --ONLY IF JUMP
		process(JUMP_EN,PC_ADDR_AUX3,JUMP_ADDR)
		begin
			if( JUMP_EN = '0') then
				PC_ADDR_AUX4 <= PC_ADDR_AUX3;
			else
				PC_ADDR_AUX4 <= JUMP_ADDR;
			end if;
		end process MUX_PC2; 
		
		MUX_STALL: --FOR INST STALL
		process(STALL_HAZARD,INST_AUX,inst_curr_stall)
		begin
			if( STALL_HAZARD = '1') then
				INST_AUX_STALL <= inst_curr_stall;
			else
				INST_AUX_STALL <= INST_AUX;
			end if;
		end process MUX_STALL; 
		
		
	PC : 
		entity work.REG 
		port map(
			CLK			=> CLK,
			RESET		=> RESET,
			DATA_IN		=> PC_ADDR_AUX4,
			DATA_OUT	=> PC_ADDR_AUX1 
		);
	
	INST_MEM:
		entity work.INSTRUCTION_MEMORY 
		port map(
			RESET		=>	RESET,
			READ_ADDR	=>	PC_ADDR_AUX1, 
			INST		=> 	INST_AUX --instruction from instmem to IF_ID_REG
		);
		
	IF_ID_REG:
	
		entity work.IF_ID_REGISTERS 
		port map(
			CLK				=> CLK,
			RESET			=> RESET,
			NEW_PC_ADDR_IN	=> PC_ADDR_AUX2,
			INST_REG_IN		=> INST_AUX_STALL,
			NEW_PC_ADDR_OUT	=> NEW_PC_ADDR_OUT,
			INST_REG_OUT	=> INSTRUCTION
		);	
	
end arc_fetch;