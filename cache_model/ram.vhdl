library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity ram is port (
  clk: in std_logic;
  address: in std_logic_vector(9 downto 0);
  rwite: in std_logic;
  data_input:in std_logic_vector(31 downto 0);
  data_output: out std_logic_vector(31 downto 0);
  data_ready: out std_logic :='0'
  );
end ram;

architecture dataflow of ram is
  
type data is array (1023 downto 0) of std_logic_vector(31 downto 0 );
signal data_ram : data;
begin
   process (clk)
  variable add: integer;
	begin
    if(rising_edge(clk)) then
       add:=conv_integer (address);
	     if(rwite='0') then
	         data_output   <=  data_ram(add);
	         data_ready<='0';
	         
	     elsif(rwite='1') then
	       data_ram( add ) <= data_input ;
	       data_ready<='1';
	     end if;
	  end if;
	end process;
end dataflow;