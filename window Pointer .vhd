library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all;

entity WindowPointer is
   port (
		clk : std_logic;
      input :                  in std_logic_vector (5 downto 0);
      WPreset, WPadd :    in std_logic;
      output :                 out std_logic_vector (5 downto 0)
   );
end WindowPointer;
  
  
  
architecture dataflow OF WindowPointer is
   signal temp_output : std_logic_vector (5 downto 0);

begin

   process (clk)
   begin
      if (clk'event and clk = '1') then
           if (WPreset = '1') then
                temp_output <= "000000"  ;
         elsif (WPadd = '1') then
            temp_output  <= temp_output  +  input  ;
         end if;
      end if;
   end process;
   output  <=  temp_output  ;
   
end dataflow ;