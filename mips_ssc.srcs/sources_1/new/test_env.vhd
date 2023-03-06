library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity test_env is
    --Port ( clk : in std_logic;
    --       btn : in std_logic_vector (4 downto 0);
    --       sw : in std_logic_vector (15 downto 0);
    --       led : out std_logic_vector (15 downto 0);
    --       an : out std_logic_vector (3 downto 0);
    --       cat : out std_logic_vector (6 downto 0));
    Port (clk : in std_logic;
          reset : in std_logic;
          en: in std_logic;
          btn : in std_logic_vector (4 downto 0);
          sw : in std_logic_vector (15 downto 0);
          led : out std_logic_vector (15 downto 0);
          an : out std_logic_vector (3 downto 0);
          cat : out std_logic_vector (6 downto 0)
          );

end test_env;


--MIPS
architecture Behavioral of test_env is

 --component mpg is
 --   Port (  en : out std_logic;
 --           input : in std_logic;
 --           clock : in std_logic
 --         );
 --end component;
 
 --component ssd is
 --    Port (  dig: in std_logic_vector(15 downto 0);
 --            clk: in std_logic;
 --            cat: out std_logic_vector(6 downto 0);
 --            an: out std_logic_vector(3 downto 0)  
 --         );
 --end component;
 
 component instructionFetch is
     Port(
         clk: in std_logic;
         en: in std_logic;
         rst: in std_logic;    
         PCsrc : in std_logic;
         jump: in std_logic;
         JumpAddress: in std_logic_vector(31 downto 0);
         BranchAdd: in std_logic_vector(31 downto 0);
         instruction: out std_logic_vector(31 downto 0);
         pc: out std_logic_vector(31 downto 0)
        );
 end component;
 
 
 component uc is
     Port(
          opcode: in std_logic_vector(5 downto 0); --instr
          reset: in std_logic;
          ALUOp: out std_logic_vector(3 downto 0);
          RegDst,MemToReg,Jump,Branch,MemRead,MemWrite,ALUSrc,RegWrite,ExtOp: out std_logic
         );
 end component;
 
 component id is
     Port(
         clk: in std_logic;
         en: in std_logic;
         instruction: in std_logic_vector(25 downto 0);
         wd: in std_logic_vector(31 downto 0);
         RegDst: in std_logic;
         ExtOp: in std_logic; 
         RegWrite: in std_logic;
         Ext_Imm: out std_logic_vector(31 downto 0);
         rd1: out std_logic_vector(31 downto 0);
         rd2: out std_logic_vector(31 downto 0);
         func: out std_logic_vector(5 downto 0);
         sa: out std_logic_vector(4 downto 0)
         );
 end component;
 
 component mem is
     Port(
         clk: in std_logic;
         en: in std_logic;
         MemAddress: in std_logic_vector(31 downto 0);
         MemWrite: in std_logic;
         rd2: in std_logic_vector(31 downto 0);
         MemReadData: out std_logic_vector(31 downto 0);
         ALUres: out std_logic_vector(31 downto 0)
         );
 end component;
 
 component ex is
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
 end component;
 
 signal out1: std_logic_vector(31 downto 0);
 signal instruction, pc, rd1, rd2, wd, Ext_Imm: std_logic_vector(31 downto 0);
 signal jump_add, BranchAdd, ALUres, ALUres1, MemData: std_logic_vector(31 downto 0);
 signal PCsrc: std_logic;
 signal func: std_logic_vector(5 downto 0);
 signal ALUOp: std_logic_vector(3 downto 0);
 signal RegDst, ExtOp, ALUsrc, MemToReg, branch, MemRead, MemWrite, RegWrite, jump: std_logic;
 signal zero: std_logic;
 signal sa: std_logic_vector(4 downto 0);
 
 
 begin

--led <= sw;

 --mpg1: mpg port map(en, btn(0), clk);
 --ssd1: ssd port map(out1, clk, cat, an);
 uc1: uc port map (instruction(31 downto 26), reset, ALUOp, RegDst,MemToReg,jump,branch,MemRead,MemWrite, ALUsrc, RegWrite, ExtOp);
 id1: id port map (clk, en, instruction(25 downto 0), wd, RegDst, ExtOp, RegWrite, Ext_Imm, rd1,rd2,func,sa);
 ex1: ex port map (pc, rd1, rd2, Ext_Imm, sa, ALUsrc, ALUOp, func, BranchAdd, ALUres, zero);
 mem1: mem port map (clk, en, ALUres, MemWrite, rd2, MemData, ALUres1); 
 instruction_f1: instructionFetch port map (clk,en,reset,PCsrc, jump, jump_add, BranchAdd,instruction,pc);
  

jump_add <= pc(31 downto 28) & instruction(25 downto 0) & "00";
PCsrc <= branch and zero;
wd <= MemData when MemToReg = '1' else ALUres;

 
process(sw, instruction, pc, rd1, MemData, wd, rd2, ALUres, Ext_Imm, ALUres1)
 begin
 
 case sw(7 downto 5) is
    when "000" =>
         out1 <= instruction;
    when "001" =>
         out1 <= pc;
    when "010" =>
         out1 <= rd1;
    when "011" =>
         out1 <= rd2;
    when "100" =>
         out1 <= Ext_Imm;
    when "101" =>
         out1 <= ALUres1;
    when "110" =>
         out1 <= MemData;
    when "111" =>
         out1 <= wd;  
    when others =>
         out1 <= X"00000000";
 end case;
 end process;
  
    
 end Behavioral;
 
 