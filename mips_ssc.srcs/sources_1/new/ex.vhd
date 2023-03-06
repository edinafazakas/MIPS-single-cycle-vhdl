library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ex is
    Port(
        pc_inc: in std_logic_vector(31 downto 0);
        rd1 : in std_logic_vector(31 downto 0); 
        rd2: in std_logic_vector(31 downto 0);
        Ext_Imm: in std_logic_vector(31 downto 0);
        sa: in std_logic_vector(4 downto 0);
        ALUSrc: in std_logic;
        ALUOp : in std_logic_vector(3 downto 0);
        func : in std_logic_vector(5 downto 0);
        BranchAdd: out std_logic_vector(31 downto 0);
        ALUresult: out std_logic_vector(31 downto 0); -- ALU Output Result
        zero: out std_logic-- Zero Flag;
        );
end ex;


architecture Behavioral of ex is
signal result: std_logic_vector(31 downto 0);
signal ALUControl: std_logic_vector(3 downto 0); --function select
signal alu2: std_logic_vector(31 downto 0);

begin


alu2 <= rd2 when ALUSrc = '0' else Ext_Imm;
 
process(ALUControl,rd1,alu2, sa)
begin
 case ALUControl is
    when "0000" =>
       result <= rd1 + alu2; -- add
    when "0001" =>
       result <= rd1 - alu2; -- sub
    when "0011" => 
       result <= rd1 and alu2; -- and
    when "0010" =>
       result <= rd1 or alu2; -- or
    when "0111" =>             -- sll
      case sa is
         when "00001" =>  result <= alu2(30 downto 0) & "0";
         when "00000" => result <= alu2;
         when others => result <= (others => '0');
      end case; 
    when "1000" =>              -- srl
       case sa is
             when "00001" =>  result <= "0" & alu2(31 downto 1);
             when "00000" =>  result <= alu2;
             when others => result <= (others => '0');
          end case; 
    when "0101" =>
       result <= rd1 xor alu2; -- xor
    when "0100" =>
       result <= rd1 nor alu2; -- nor
    when "0110" =>
       result <= rd1 nand alu2; -- nand
    when others => result <= rd1 + alu2; -- add
 end case;
end process;


process(result)
begin
  if (result = x"0000") then
    zero <= '1';
  else 
    zero <= '0';
  end if;
end process;


process(ALUOp,func)
    begin
     
     if (ALUop = "0000" and func = "000000") or (ALUop = "0001") then
               ALUControl <= "0000"; --add/+
        end if;
     
     if (ALUop = "0000" and func = "000001") or (ALUop = "0010") then
                ALUControl <= "0001"; --sub/-
         end if;
     
     if (ALUop = "0000" and func = "000011") or (ALUop = "0011") then
                ALUControl <= "0011"; --and/&
          end if;
     if (ALUop = "0000" and func = "000010") or (ALUop = "0100") then
                ALUControl <= "0010"; --or/|
               end if;
     if (ALUop = "0000" and func = "000111")then
                ALUControl <= "0111"; --sll
               end if;
     if (ALUop = "0000" and func = "001000") then
                ALUControl <= "1000"; --srl
               end if; 
     if (ALUop = "0000" and func = "000101") or (ALUOp = "0110")then
                ALUControl <= "0101"; --xor
               end if;  
     if (ALUop = "0000" and func = "000100") or (ALUOp = "0111") then
                ALUControl <= "0100"; --nor
                end if;            
     if (ALUop = "0000" and func = "000110") or (ALUOp = "0101") then
                ALUControl <= "0110"; --nand
                end if;                                                     
end process;


ALUresult <= result;
BranchAdd <= pc_inc + Ext_Imm;
 
end Behavioral;
