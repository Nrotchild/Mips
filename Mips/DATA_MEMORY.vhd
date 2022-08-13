library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DATA_MEMORY is
	
	port(
		RESET		:	in  STD_LOGIC;			
		ADDR		:	in  STD_LOGIC_VECTOR (31 downto 0);
		WRITE_DATA	:	in  STD_LOGIC_VECTOR (31 downto 0);	
		MemRead		:	in  STD_LOGIC;				
		MemWrite	:	in  STD_LOGIC;				
		READ_DATA	:	out STD_LOGIC_VECTOR (31 downto 0)	
	);
end DATA_MEMORY;


architecture DATA_MEMORY_ARC of DATA_MEMORY is
  
	type MEM_T is array (1023 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
	signal MEM : MEM_T;
  
begin

	MEM_PROC:
		process(RESET,MemWrite,MemRead,WRITE_DATA,MEM,ADDR)
		begin	
			if (RESET = '1') then 
				for i in 0 to 1023 loop
					MEM(i) <= (others => '0');
				end loop;
			 
			elsif MemWrite='1' then 
				MEM(to_integer(unsigned( ADDR(9 downto 0) ))) <= WRITE_DATA;--where to write
			elsif MemRead='1' then
			    	READ_DATA <= MEM(to_integer(unsigned( ADDR(9 downto 0) )));--from where to read
			end if;
		end process MEM_PROC;

end DATA_MEMORY_ARC;