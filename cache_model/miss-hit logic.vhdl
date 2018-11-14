library IEEE;
use IEEE.std_logic_1164.all;

entity miss_hit_logic is port (
  
  tag: in std_logic_vector(3 downto 0);
  w0:in std_logic_vector(4 downto 0);
  w1:in std_logic_vector(4 downto 0);
  hit: out std_logic;
  w0_valid: out std_logic;
  w1_valid: out std_logic
  );
end miss_hit_logic;

architecture arch of miss_hit_logic is
  signal tag_out0 : std_logic_vector (3 downto 0);
  signal tag_out1 : std_logic_vector (3 downto 0);  
--  signal c0:std_logic;
--  signal c1:std_logic;
--  signal c2:std_logic;
--  signal c3:std_logic;
  signal a0:std_logic;
  signal a1:std_logic;
  signal a2:std_logic;
  
 
  
  signal a20:std_logic;
  signal a21:std_logic;
  signal a22:std_logic;
  
  signal w0_valid_temp:std_logic;
  signal w1_valid_temp:std_logic;
  
  
begin
  tag_out0 <= tag xnor w0(3 downto 0 ) ;
  a0 <= tag_out0(0) and tag_out0(1);
  a1 <= tag_out0(2) and tag_out0(3);
  a2 <= a0 and a1; --out of tag and w0 
  w0_valid <= a2 and w0(4);  --valid-
  w0_valid_temp <= a2 and w0(4);
  --------end of wo  
  tag_out1 <= tag xnor w1(3 downto 0 ) ;
  a20 <= tag_out1(0) and tag_out1(1);
  a21 <= tag_out1(2) and tag_out1(3);
  a22 <= a20 and a21;
  w1_valid <= a22 and w1(4);
  w1_valid_temp <= a22 and w1(4);
  -----------------end of w1
  hit <= w0_valid_temp or w1_valid_temp;
  
  
  end arch;