library IEEE;
use IEEE.std_logic_1164.all;

entity ram_cache is port (
  clk: in std_logic;
  reset_n: in std_logic;
  addr: in std_logic_vector(9 downto 0);
  write: in std_logic;
  read: in std_logic;
  wrdata:in std_logic_vector(31 downto 0);
  hit: out std_logic;
  rddata: out std_logic_vector(31 downto 0)
  );
end ram_cache;

architecture dataflow of ram_cache is
  component cache is port (
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
  end component;
  component ram is port (
  clk: in std_logic;
  address: in std_logic_vector(9 downto 0);
  rwite: in std_logic;
  data_input:in std_logic_vector(31 downto 0);
  data_output: out std_logic_vector(31 downto 0);
  data_ready: out std_logic :='0'
  );
end component;
component controller is port (
  clk: in std_logic;
  address: in std_logic_vector(9 downto 0);
  write: in std_logic;
  read: in std_logic;
  hit: in std_logic;
  ram_ready:in std_logic;
  invalidate: out std_logic;
  read_ram: out std_logic;
  read_cache: out std_logic;
  write_cache_enable: out std_logic;
  write_ram_enable: out std_logic
  );
end component;

signal hit_cache:std_logic:='0';
signal ram_ready_ram:std_logic;
signal invalidate_contr:std_logic:='0';
signal read_ram_contr:std_logic;
signal read_cache_contr:std_logic;
signal write_cache_enable_contr:std_logic:='0';
signal write_ram_enable_contr:std_logic:='0';
signal dataout_cache:std_logic_vector(31 downto 0);
signal dataout_ram:std_logic_vector(31 downto 0);

begin
  
  controller0: controller port map (clk,addr,write,read,hit_cache,ram_ready_ram,invalidate_contr,read_ram_contr,read_cache_contr,write_cache_enable_contr,write_ram_enable_contr);
  cache0: cache port map (clk,reset_n,addr(5 downto 0),addr(9 downto 6),invalidate_contr,write_cache_enable_contr,wrdata,hit_cache,dataout_cache);
  ram0: ram port map (clk,addr,write_ram_enable_contr,wrdata,dataout_cache,ram_ready_ram);
  hit<=hit_cache;  
  
  
  process (clk)

	begin
    if(rising_edge(clk)) then
      if(read_ram_contr='1') and (read_cache_contr='0') then
        rddata<=dataout_ram;
      elsif(read_ram_contr='0') and (read_cache_contr='1') then
        rddata<=dataout_cache;
      
      end if;
    end if;
  end process;
  
end dataflow;