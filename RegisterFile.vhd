LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY RegisterFile IS
   PORT (
         input_file : IN std_logic_vector (15 DOWNTO 0);
         clk :        IN std_logic;
         start  :      IN std_logic_vector (5 DOWNTO 0);
         Laddr, Raddr : IN std_logic_vector (1 DOWNTO 0);
         RFLwrite, RFHwrite : IN std_logic;
         Left_out, Right_out : OUT std_logic_vector (15 DOWNTO 0)
   );
END RegisterFile;

ARCHITECTURE behavioral OF RegisterFile IS 

   SIGNAL Laddress, Raddress : std_logic_vector (5 DOWNTO 0);
   TYPE Registers IS ARRAY (0 TO 63) OF std_logic_vector (15 DOWNTO 0);
   SIGNAL MemoryFile : Registers;

BEGIN
  PROCESS (clk)
   BEGIN
      IF (clk = '1') THEN
	   IF (RFHwrite = '1') THEN
            MemoryFile (CONV_INTEGER (Laddress)) (15 DOWNTO 8) <= input_file (15 DOWNTO 8);
         END IF;
	    IF (RFLwrite = '1') THEN
            MemoryFile (CONV_INTEGER (Laddress)) (7 DOWNTO 0) <= input_file (7 DOWNTO 0);
         END IF;
      END IF;
   END PROCESS;
   Laddress <= start + Laddr;
   Raddress <= start + Raddr;
   Left_out  <= MemoryFile (conv_integer(Laddress));
   Right_out <= MemoryFile (conv_integer(Raddress));
   
   
END behavioral;


------
--- Simplified Syntax
--- type type_name is array (range) of element_type
--- type INTEGER_VECTOR is array (1 to 8) of integer;
--- function conv_integer(arg: integer) return integer;
--- the library that you need is std_logic_unsigned