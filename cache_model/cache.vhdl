library IEEE;
use IEEE.std_logic_1164.all;

entity cache is port (
  clk: in std_logic;
  reset_n: in std_logic;
  index: in std_logic_vector(5 downto 0);
  tag: in std_logic_vector(3 downto 0);
  invalidate: in std_logic;
  write_enable: in std_logic;
  data_in:in std_logic_vector(31 downto 0);
  hit: out std_logic;
  data_out: out std_logic_vector(31 downto 0)
  );
end cache;

architecture arch of cache is
  component data_array is port (
  clk: in std_logic;
  address: in std_logic_vector(5 downto 0);
  wren: in std_logic;
  wrdata:in std_logic_vector(31 downto 0);
  data: out std_logic_vector(31 downto 0)
  );
end component;
component tag_valid_array is port (
  clk: in std_logic;
  reset_n: in std_logic;
  address: in std_logic_vector(5 downto 0);
  wren: in std_logic;
  invalidate: in std_logic;
  wrdata:in std_logic_vector(3 downto 0);
  output: out std_logic_vector(4 downto 0)
  );
end component;
component miss_hit_logic is port (
  
  tag: in std_logic_vector(3 downto 0);
  w0:in std_logic_vector(4 downto 0);
  w1:in std_logic_vector(4 downto 0);
  hit: out std_logic;
  w0_valid: out std_logic;
  w1_valid: out std_logic
  );
end component;
component mru_array is port (
  clk: in std_logic;
  address: in std_logic_vector(5 downto 0);
  write_enable: in std_logic;
  w1_now: out std_logic
  );
end component;

signal tag0_tagvalid_misshit:std_logic_vector (4 downto 0);
signal tag1_tagvalid_misshit:std_logic_vector (4 downto 0);
signal write_mru_dataarray:std_logic;
signal hit0:std_logic:='0';
signal hit1:std_logic:='0';
signal mustwrite0:std_logic;
signal mustwrite1:std_logic;
signal mru_out:std_logic;
signal out0:std_logic_vector(31 downto 0);
signal out1:std_logic_vector(31 downto 0);

begin
    mruarray: mru_array port map(clk,index,write_enable,mru_out);
    mustwrite1 <= mru_out and write_enable;
    mustwrite0 <= (not mru_out) and write_enable;
	
    tagvalidarray0: tag_valid_array port map (clk,reset_n,index,mustwrite0,invalidate,tag,tag0_tagvalid_misshit);
    tagvalidarray1: tag_valid_array port map (clk,reset_n,index,mustwrite1,invalidate,tag,tag1_tagvalid_misshit);
    misshitlogic: miss_hit_logic port map (tag,tag0_tagvalid_misshit,tag1_tagvalid_misshit,hit,hit0,hit1);
    dataarray0:data_array port map (clk,index,mustwrite0,data_in,out0);
    dataarray1:data_array port map (clk,index,mustwrite1,data_in,out1);
 
 process (clk)

	begin
    if(rising_edge(clk)) then
    
      if(hit0='1')and (hit1='0') then
        data_out<=out0;
      elsif(hit1='1')and (hit0='0') then
        data_out<=out1;
      end if;
      
    end if;
  end process;
end arch;