library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity REGISTERS is 
    port(
			--inputs
	        CLK 		: in	STD_LOGIC;				
			RESET		: in	STD_LOGIC;				
			RW			: in	STD_LOGIC;	--enable (RegWrite)	
	        RS_ADDR 	: in  	STD_LOGIC_VECTOR (4 downto 0);--address of Rs
	        RT_ADDR 	: in  	STD_LOGIC_VECTOR (4 downto 0);--address of Rt
	        RD_ADDR 	: in	STD_LOGIC_VECTOR (4 downto 0);--address of Rd
	        WRITE_DATA	: in	STD_LOGIC_VECTOR (31 downto 0);--Data to be written
			--outputs
	        RS 			: out	STD_LOGIC_VECTOR (31 downto 0);--Data of Rs
	        RT 			: out	STD_LOGIC_VECTOR (31 downto 0)	--data of Rt
        );
end REGISTERS;

architecture REGISTERS_ARC of REGISTERS is
  
  -- Type to store the registers
  type REGS_T is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);

  signal REG_G 	: REGS_T;
  
begin

  REG_ASIG:
	  process(CLK,RESET,RW,WRITE_DATA,RD_ADDR)
	  begin
	  
		if  RESET='1' then
				for i in 0 to 31 loop
					REG_G(i) <= (others => '0');--reset regs
				end loop;
				
				REG_G(0) <= "00000000000000000000000000000000";
				REG_G(1) <= "00000000000000000000000000000001";
				REG_G(2) <= "00000000000000000000000000000010";
				REG_G(3) <= "00000000000000000000000000000011";
				REG_G(4) <= "00000000000000000000000000000100";
				REG_G(5) <= "00000000000000000000000000000101";
				REG_G(6) <= "00000000000000000000000000000110";
				REG_G(7) <= "00000000000000000000000000000111";
				REG_G(8) <= "00000000000000000000000000001000";
				REG_G(9) <= "00000000000000000000000000001001";
				REG_G(10) <= "00000000000000000000000000001010";
				REG_G(11) <= "00000000000000000000000000001011";
				REG_G(12) <= "00000000000000000000000000001100";				
				REG_G(13) <= "00000000000000000000000000001101";
				REG_G(14) <= "00000000000000000000000000001110";
				REG_G(15) <= "00000000000000000000000000001111";
				REG_G(16) <= "00000000000000000000000000010000";
				REG_G(17) <= "00000000000000000000000000010001";
				REG_G(18) <= "00000000000000000000000000010010";
				REG_G(19) <= "00000000000000000000000000010011";
				REG_G(20) <= "00000000000000000000000000010100";
				REG_G(21) <= "00000000000000000000000000010101";
				REG_G(22) <= "00000000000000000000000000010110";
				REG_G(23) <= "00000000000000000000000000010111";
				REG_G(24) <= "00000000000000000000000000011000";
				REG_G(25) <= "00000000000000000000000000011001";
				REG_G(26) <= "00000000000000000000000000011010";
				REG_G(27) <= "00000000000000000000000000011011";
				REG_G(28) <= "00000000000000000000000000011100";
				REG_G(29) <= "00000000000000000000000000011101";
				REG_G(30) <= "00000000000000000000000000011110";
				REG_G(31) <= "00000000000000000000000000011111";
				
		elsif rising_edge(CLK) then
			if  RW='1' then
				REG_G(to_integer(unsigned(RD_ADDR)))<=WRITE_DATA;--write to wanted reg
			end if;
		end if;
	  end process  REG_ASIG;
                ------reg zero & read-------
  RS <= (others=>'0') when RS_ADDR="00000"
         else REG_G(to_integer(unsigned(RS_ADDR)));
  RT <= (others=>'0') when RT_ADDR="00000"
         else REG_G(to_integer(unsigned(RT_ADDR)));

end REGISTERS_ARC;