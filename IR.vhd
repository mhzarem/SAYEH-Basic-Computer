library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all;

entity InstructionRegister IS
   port (
      input : in std_logic_vector (15 downto 0);
      IRload, clk : in std_logic;
      output : out std_logic_vector (15 downto 0)
   );
end InstructionRegister;

architecture dataflow of InstructionRegister is
begin
   process (clk)
   begin
      if (clk = '1') then
         if (IRload = '1') then
            output <= input;
         end if;
      end if;
   end process;
   
end dataflow;
  
  

  
  
  
  
  
  
  
  