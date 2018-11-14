library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mru_array is port (
  clk: in std_logic;
  address: in std_logic_vector(5 downto 0);
  write_enable: in std_logic;
  w1_now: out std_logic
  );
end mru_array;
 architecture dataflow of mru_array is
type datastore is array (63 downto 0 , 1 downto 0) of integer;
signal data_counter : datastore:=((0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0));
--signal data_set2 : datastore;--

begin
    
  process (clk)
  variable add: integer;
	begin
    if(rising_edge(clk)) then
       add:=conv_integer (address);
	     if(write_enable='1') then
	        if(data_counter(add,0)=data_counter(add,1)) then
	           data_counter(add,0)<=data_counter(add,0)+1;
	           w1_now<='0';
	        elsif(data_counter(add,0)>data_counter(add,1)) then
	           data_counter(add,1)<=data_counter(add,1)+1;
	           w1_now<='0';
	        elsif(data_counter(add,0)<data_counter(add,1)) then
	           data_counter(add,0)<=data_counter(add,0)+1;
	           w1_now<='1';
	        end if;
	     end if;
	  end if;
	end process;
end dataflow;