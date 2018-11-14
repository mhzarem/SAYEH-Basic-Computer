----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:29:25 04/01/2017 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    Port ( clk : in  STD_LOGIC;
           ShadowEn : in  STD_LOGIC;
           External_Reset : in  STD_LOGIC;
           MemDataReady : in  STD_LOGIC;
           Zout : in  STD_LOGIC;
           Cout : in  STD_LOGIC;
			  Instruction : in STD_LOGIC_VECTOR(7 downto 0);--contains the Instruction to be processed
           --Memory
			  ReadMem : out  STD_LOGIC;
           WriteMem : out  STD_LOGIC;
           --IR
			  IRLoad : out  STD_LOGIC;
           IR_on_LOpndBus : out  STD_LOGIC;
           IR_on_HOpndBus : out  STD_LOGIC;
           --Register File
			  RFright_on_OpndBus : out  STD_LOGIC;
           Rs_on_AddressUnitRSide : out  STD_LOGIC;
           Rd_on_AddressUnitRSide : out  STD_LOGIC;
           RFLwrite : out  STD_LOGIC;
           RFHwrite : out  STD_LOGIC;
			  --Arithmetic Unit
			  B15to0 : out  STD_LOGIC;
           AandB : out  STD_LOGIC;
           AorB : out  STD_LOGIC;
           NotB : out  STD_LOGIC;
           AaddB : out  STD_LOGIC;
           AsubB : out  STD_LOGIC;
           AmulB : out  STD_LOGIC;
           AcmpB : out  STD_LOGIC;
           ShrB : out  STD_LOGIC;
           ShlB : out  STD_LOGIC;
           ALUout_on_Databus : out  STD_LOGIC;
			  --Status Flag
			  CSet : out  STD_LOGIC;
           CReset : out  STD_LOGIC;
           ZSet : out  STD_LOGIC;
           ZReset : out  STD_LOGIC;
           SRLoad : out  STD_LOGIC;
			  --Address Logic
			  Address_on_Databus : out  STD_LOGIC;
			  EnablePC : out STD_LOGIC;
           ResetPC : out  STD_LOGIC;
           PCplus1 : out  STD_LOGIC;
           PCplusI : out  STD_LOGIC;
           R0plusI : out  STD_LOGIC;
           R0plus0 : out  STD_LOGIC;
           --Window Pointer
			  WPadd : out STD_LOGIC;
			  WPreset : out STD_LOGIC;
			  Shadow : out  STD_LOGIC);
end Controller;

architecture dataflow of Controller is
	type state is(reset,halt,fetch1,fetch2,decode,execute,
											Shadow_execute_first,
											Shadow_execute_second,
											memldafirst,memldasecond,memstafirst,memstasecond,final);
	constant nop : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	constant hlt : STD_LOGIC_VECTOR(3 downto 0) := "0001";
	constant szf : STD_LOGIC_VECTOR(3 downto 0) := "0010";
	constant czf : STD_LOGIC_VECTOR(3 downto 0) := "0011";
	constant scf : STD_LOGIC_VECTOR(3 downto 0) := "0100";
	constant ccf : STD_LOGIC_VECTOR(3 downto 0) := "0101";
	constant cwp : STD_LOGIC_VECTOR(3 downto 0) := "0110";
	constant mvr : STD_LOGIC_VECTOR(3 downto 0) := "0001";
	constant lda : STD_LOGIC_VECTOR(3 downto 0) := "0010";
	constant sta : STD_LOGIC_VECTOR(3 downto 0) := "0011";
	constant inp : STD_LOGIC_VECTOR(3 downto 0) := "0100";
	constant oup : STD_LOGIC_VECTOR(3 downto 0) := "0101";
	constant andd : STD_LOGIC_VECTOR(3 downto 0) := "0110";
	constant orr : STD_LOGIC_VECTOR(3 downto 0) := "0111";
	constant nott : STD_LOGIC_VECTOR(3 downto 0) := "1000";
	constant shl : STD_LOGIC_VECTOR(3 downto 0) := "1001";
	constant shr : STD_LOGIC_VECTOR(3 downto 0) := "1010";
	constant add : STD_LOGIC_VECTOR(3 downto 0) := "1011";
	constant sub : STD_LOGIC_VECTOR(3 downto 0) := "1100";
	constant mul : STD_LOGIC_VECTOR(3 downto 0) := "1101";
	constant cmp : STD_LOGIC_VECTOR(3 downto 0) := "1110";
	constant mil : STD_LOGIC_VECTOR(1 downto 0) := "00";
	constant mih : STD_LOGIC_VECTOR(1 downto 0) := "01";
	constant spc : STD_LOGIC_VECTOR(1 downto 0) := "10";
	constant jpa : STD_LOGIC_VECTOR(1 downto 0) := "11";
	constant jpr : STD_LOGIC_VECTOR(3 downto 0) := "0111";
	constant brz : STD_LOGIC_VECTOR(3 downto 0) := "1000";
	constant brc : STD_LOGIC_VECTOR(3 downto 0) := "1001";
	constant awp : STD_LOGIC_VECTOR(3 downto 0) := "1010";
	
	signal presentState,nextState : state;
begin
	process(MemDataReady,presentState,Instruction,External_Reset,Cout,Zout,ShadowEn)
	begin
		--In the case of transfering into a new state , we would be in (terrible) state if we want to know the previuos
 		--signal(s) and then resetting all of them.So we reset all the signals as the first step
   	--Memory
 	   ReadMem <= '0';
	   WriteMem <= '0';
	   --IR
	   IRLoad <= '0';
	   IR_on_LOpndBus <= '0';
	   IR_on_HOpndBus <= '0';
	   --Register File
	   RFright_on_OpndBus <= '0';
	   Rs_on_AddressUnitRSide <= '0';
	   Rd_on_AddressUnitRSide <= '0';
	   RFLwrite <= '0';
	   RFHwrite <= '0';
	   --Arithmetic Unit
	   B15to0 <= '0';
	   AandB <= '0';
	   AorB <= '0';
	   NotB <= '0';
	   AaddB <= '0';
	   AsubB <= '0';
	   AmulB <= '0';
	   AcmpB <= '0';
	   ShrB <= '0';
	   ShlB <= '0';
	   ALUout_on_Databus <= '0';
	   --Status Flag
	   CSet <= '0';
	   CReset <= '0';
	   ZSet <= '0';
	   ZReset <= '0';
	   SRLoad <= '0';
	   --Address Logic
	   Address_on_Databus <= '0';
	   EnablePC <= '0';
	   ResetPC <= '0';
	   PCplus1 <= '0';
	   PCplusI <= '0';
	   R0plusI <= '0';
	   R0plus0 <= '0';
	   --Window Pointer
	   WPadd <= '0';
	   WPreset <= '0';
	   Shadow <= '0';
		case presentState is -- in all cases the External_Reset can reset the controller asynchronously
			when reset => -- reset all the elements of the DataPath having a Reset signal
				CReset <= '1';
				ZReset <= '1';
				WPreset <= '1';
				ResetPC <= '1';
				EnablePC <= '1';
				if(External_Reset = '1') then 
					nextState <= reset;
				else
					nextState <= fetch1;
					
				end if;	
			when halt =>
				if(External_Reset = '1') then 
					nextState <= reset;
				else
					nextState <= halt;	
				end if;		
			when fetch1 =>
				if(External_Reset = '1') then 
					nextState <= reset;
				else
				ReadMem <= '1';--Memory cell is put on Data Bus in order to load IR
				
				nextState <= fetch2;
				end if;	
			when fetch2 =>
				if(External_Reset = '1') then 
					nextState <= reset;
				else
				IRLoad <= '1';--Load the new Instruction into IR
				nextState <= decode;
				end if;
			when decode => 
				
				if(Instruction(7 downto 4) = "0000") then
					if(Instruction(3 downto 0) = nop) then
						nextState <= Shadow_execute_first;
						
					elsif(Instruction(3 downto 0) = hlt) then
						nextState <= Shadow_execute_first;
					elsif(Instruction(3 downto 0) = szf) then
						nextState <= Shadow_execute_first;
					elsif(Instruction(3 downto 0) = czf) then
						nextState <= Shadow_execute_first;
					elsif(Instruction(3 downto 0) = scf) then
						nextState <= Shadow_execute_first;
					elsif(Instruction(3 downto 0) = ccf) then
						nextState <= Shadow_execute_first;
					elsif(Instruction(3 downto 0) = cwp) then
						nextState <= Shadow_execute_first;
					elsif(Instruction(3 downto 0) = jpr) then
						nextState <= execute;
					elsif(Instruction(3 downto 0) = brz) then
						nextState <= execute;
					elsif(Instruction(3 downto 0) = brc) then
						nextState <= execute;
					elsif(Instruction(3 downto 0) = awp) then
						nextState <= execute;
					else
						nextState <= fetch1;
						
					end if;		
				elsif(Instruction(7 downto 4) = mvr) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = lda) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = sta) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = inp) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = oup) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = andd) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = orr) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = nott) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = shl) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = shr) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = add) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = sub) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = mul) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = cmp) then
					nextState <= Shadow_execute_first;
				elsif(Instruction(7 downto 4) = "1111") then
					if(Instruction(1 downto 0) = mil) then
						nextState <= execute;
					elsif(Instruction(1 downto 0) = mih) then
						nextState <= execute;
					elsif(Instruction(1 downto 0) = spc) then
						nextState <= execute;
					elsif(Instruction(1 downto 0) = jpa) then
						nextState <= execute;
					else
						nextState <= fetch1;
					end if;
				else --Other cases
					nextState <= fetch1;
				end if;
			when execute =>	
				if(External_Reset = '1') then 
					nextState <= reset;
				else
					if(Instruction(7 downto 4) = "0000") then
						if(Instruction(3 downto 0) = jpr) then
							PCplusI <= '1';
							EnablePC <= '1';
							nextState <= fetch1;--read The next Unstruction from newly determined location of Memory
						elsif(Instruction(3 downto 0) = brz) then
							if(Zout = '1') then
								PCplusI <= '1';
								EnablePC <= '1';
								nextState <= fetch1;--read The next Unstruction from newly determined location of Memory
							else
								nextState <= final;
							end if;
						elsif(Instruction(3 downto 0) = brc) then
							if(Cout = '1') then
								PCplusI <= '1';
								EnablePC <= '1';
								nextState <= fetch1;
							else
								nextState <= final;
							end if;	
						elsif(Instruction(3 downto 0) = awp) then
							WPadd <= '1';
							nextState <= final;	
						end if;
					elsif(Instruction(7 downto 4) = "1111") then	
						
						if(Instruction(1 downto 0) = mil) then
							IR_on_LOpndBus <= '1';
							B15to0 <= '1';
							ALUout_on_Databus <= '1';
							RFLwrite <= '1';--write Immediate
							nextState <= final;
						elsif(Instruction(1 downto 0) = mih) then
							IR_on_HOpndBus <= '1';
							B15to0 <= '1';
							ALUout_on_Databus <= '1';
							RFHwrite <= '1';--write Immediate
							nextState <= final;
						elsif(Instruction(1 downto 0) = spc) then
						   PCplusI <= '1';
							Address_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							nextState <= final;
						elsif(Instruction(1 downto 0) = jpa) then
							Rd_on_AddressUnitRSide <= '1';
							R0plusI <= '1';
							EnablePC <= '1';
							nextState <= fetch1;--read The next Unstruction from newly determined location of Memory
						end if;
					end
					if;
				end if;
			
			when Shadow_execute_first =>
				if(External_Reset = '1') then 
					nextState <= reset;
				else
					
					if(Instruction(7 downto 4) = "0000") then
					
						if(Instruction(3 downto 0) = nop) then
							nextState <= Shadow_execute_second;--goto final State in order to increment PC and being prepared
																			--for reading the next Instruction
						elsif(Instruction(3 downto 0) = hlt) then
							nextState <= halt;
						elsif(Instruction(3 downto 0) = szf) then
							ZSet <= '1';
							nextState <= Shadow_execute_second;
						elsif(Instruction(3 downto 0) = czf) then
							ZReset <= '1';
							nextState <= Shadow_execute_second;
						elsif(Instruction(3 downto 0) = scf) then
							CSet <= '1';
							nextState <= Shadow_execute_second;
						elsif(Instruction(3 downto 0) = ccf) then
							CReset <= '1';
							nextState <= Shadow_execute_second;
						elsif(Instruction(3 downto 0) = cwp) then
							WPreset <= '1';
							nextState <= Shadow_execute_second;
						else
							nextState <= final;
						end if;
					
					elsif(Instruction(7 downto 4) = mvr) then
						RFright_on_OpndBus <= '1';
						B15to0 <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = lda) then
						Rs_on_AddressUnitRSide <= '1';
						R0plus0 <= '1';
						ReadMem <= '1';
						nextState <= memldafirst;
					elsif(Instruction(7 downto 4) = sta) then
						B15to0 <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						Rd_on_AddressUnitRSide <= '1';
						R0plus0 <= '1';
						RFright_on_OpndBus <= '1';
						WriteMem <= '1';	
						nextState <= memstafirst;
					elsif(Instruction(7 downto 4) = inp) then -- optional
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = oup) then --optional
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = andd) then 
						AandB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = orr) then
						AorB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = nott) then
						NotB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = shl) then
						ShlB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = shr) then
						ShrB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = add) then
						AaddB <= '1';
						SRLoad <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = sub) then
						AsubB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = mul) then
						AmulB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';	
						nextState <= Shadow_execute_second;
					elsif(Instruction(7 downto 4) = cmp) then
						AcmpB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						nextState <= Shadow_execute_second;
					end if;
				end if;
				
			when Shadow_execute_second =>
				Shadow <= '1';
				if(External_Reset = '1') then 
					nextState <= reset;
				else
				if(Instruction(7 downto 4) = "0000") then
				
						if(Instruction(3 downto 0) = nop) then
							nextState <= final;--goto final State in order to incremnt PC and fetch the next Instruction
						elsif(Instruction(3 downto 0) = hlt) then
							nextState <= halt;
						elsif(Instruction(3 downto 0) = szf) then
							ZSet <= '1';
							nextState <= final;
						elsif(Instruction(3 downto 0) = czf) then
							ZReset <= '1';
							nextState <= final;
						elsif(Instruction(3 downto 0) = scf) then
							CSet <= '1';
							nextState <= final;
						elsif(Instruction(3 downto 0) = ccf) then
							CReset <= '1';
							nextState <= final;
						elsif(Instruction(3 downto 0) = cwp) then
							WPreset <= '1';
							nextState <= final;
						else
							nextState <= final;
						end if;
					
					elsif(Instruction(7 downto 4) = mvr) then
						RFright_on_OpndBus <= '1';
						B15to0 <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= final;
					elsif(Instruction(7 downto 4) = lda) then
						Rs_on_AddressUnitRSide <= '1';
						R0plus0 <= '1';
						ReadMem <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= memldasecond;
					elsif(Instruction(7 downto 4) = sta) then
						B15to0 <= '1';
						SRLoad <= '1';
						ALUout_on_Databus <= '1';
						Rd_on_AddressUnitRSide <= '1';
						R0plus0 <= '1';
						RFright_on_OpndBus <= '1';
						WriteMem <= '1';	
						nextState <= memstasecond;
					elsif(Instruction(7 downto 4) = inp) then -- optional
						nextState <= final;
					elsif(Instruction(7 downto 4) = oup) then --optional
						nextState <= final;
					elsif(Instruction(7 downto 4) = andd) then 
						AandB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= final;
					elsif(Instruction(7 downto 4) = orr) then
						AorB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= final;
					elsif(Instruction(7 downto 4) = nott) then
						NotB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= final;
					elsif(Instruction(7 downto 4) = shl) then
						ShlB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= final;
					elsif(Instruction(7 downto 4) = shr) then
						ShrB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= final;
					elsif(Instruction(7 downto 4) = add) then
						AaddB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= final;
					elsif(Instruction(7 downto 4) = sub) then
						AsubB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						nextState <= final;
					elsif(Instruction(7 downto 4) = mul) then
						AmulB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';	
						nextState <= final;
					elsif(Instruction(7 downto 4) = cmp) then
						AcmpB <= '1';
						RFright_on_OpndBus <= '1';
						ALUout_on_Databus <= '1';
						SRLoad <= '1';
						nextState <= final;
					else
						nextState <= final;
					end if;
				end if;	
				
			when memldafirst =>
				if(External_Reset = '1') then 
					nextState <= reset;	
				else
					if(MemDataReady = '1') then
						nextState <= Shadow_execute_second;	
						RFLwrite <= '1';
						RFHwrite <= '1';
					else
						nextState <= memldafirst;
						Rs_on_AddressUnitRSide <= '1';
						R0plus0 <= '1';
					end if;
				end if;
			when	memldasecond =>
				if(External_reset = '1') then
					nextState <= reset;
				else
					shadow <= '1'; 
					if(MemDataReady = '1') then
						nextState <= final;	
					else
						nextState <= memldasecond;
						Rs_on_AddressUnitRSide <= '1';
						R0plus0 <= '1';
						ReadMem <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
					end if;
				end if;	
			
			when memstafirst =>
				if(External_Reset = '1') then 
					nextState <= reset;
				else
					if(MemDataReady = '1') then
						nextState <= Shadow_execute_second;
					else
						Rd_on_AddressUnitRSide <= '1';
						RFRight_on_OpndBus <= '1';
						B15to0 <= '1';
						ALUout_on_Databus <= '1';
						WriteMem <= '1';
						nextState <= memstafirst;
					end if;
					
				end if;	
			when memstasecond =>
				if(External_Reset = '1') then 
					nextState <= reset;
				else
					Shadow <= '1';
					if(MemDataReady = '1') then
						nextState <= final;
					else
						Rd_on_AddressUnitRSide <= '1';
						RFRight_on_OpndBus <= '1';
						B15to0 <= '1';
						ALUout_on_Databus <= '1';
						WriteMem <= '1';
						nextState <= memstasecond;
					end if;
					
				end if;
			when final => --For each instruction we should increment PC register at last
				PCplus1 <= '1';
				EnablePC <= '1';
				nextState <= fetch1; --Execution of the current instruction Completed . Next instruction is to be executed. 
		end case;	
	end process;
	
	process(clk)
	begin
		if(clk = '1') then
			presentState <= nextState;
		end if;		
	end process;
end dataflow;

