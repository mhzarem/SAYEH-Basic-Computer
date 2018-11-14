library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity data_array is port (
  clk: in std_logic;
  address: in std_logic_vector(5 downto 0);
  wren: in std_logic;
  wrdata:in std_logic_vector(31 downto 0);
  data: out std_logic_vector(31 downto 0)
  );
end data_array;

 architecture dataflow of data_array is
type datastore is array (63 downto 0) of std_logic_vector (31 downto 0);
signal data_set1 : datastore;
begin
   process (clk)
  variable add: integer;
	begin
    if(rising_edge(clk)) then
		  add := conv_integer (address);
	     if(wren='1') then
	         data_set1( add ) <= wrdata ;
	         
	     elsif(wren='0') then
		   data  <= data_set1( add );
	    end if;
	  end if;
	end process;
end dataflow;
