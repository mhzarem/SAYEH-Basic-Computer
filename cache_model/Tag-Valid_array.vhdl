library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tag_valid_array is port (
  clk: in std_logic;
  reset_n: in std_logic;
  address: in std_logic_vector(5 downto 0);
  wren: in std_logic;
  invalidate: in std_logic;
  wrdata:in std_logic_vector(3 downto 0);
  output: out std_logic_vector(4 downto 0)
  );
end tag_valid_array;

architecture arch of tag_valid_array is
  type validtag is array (63 downto 0 ) of std_logic_vector(4 downto 0 );
  signal validtag_set : validtag :=(("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"),("00000"));
  

begin
  
  process (clk)
  variable add: integer;
  
	begin
    if(rising_edge(clk)) then
       add:= conv_integer (address);
	     if(wren='0') then
	       
	      output <= validtag_set(add);
	       
	     elsif(wren='1') then
	       validtag_set(add)(3 downto 0 )<= wrdata ;
	      	     
	     end if;
	     
	     if(invalidate='0') then
	       validtag_set(add )( 4) <= '1';
	     elsif(invalidate='1') then
	       validtag_set(add )( 4) <= '0';
	     end if;  
	   end if;
  end process;
end arch;
