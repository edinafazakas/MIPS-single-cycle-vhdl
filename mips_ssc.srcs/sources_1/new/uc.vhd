library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uc is
    Port(
         opcode: in std_logic_vector(5 downto 0); --instr
         reset: in std_logic;
         ALUOp: out std_logic_vector(3 downto 0);
         RegDst,MemToReg,Jump,Branch,MemRead,MemWrite,ALUSrc,RegWrite,ExtOp: out std_logic
        );
end uc;

architecture Behavioral of uc is

begin
process(reset,opcode)
begin
 if(reset = '1') then
          RegDst <= '0';
          MemToReg <= '0';
          ALUOp <= "0000";
          Jump <= '0';
          Branch <= '0';
          MemRead <= '0';
          MemWrite <= '0';
          ALUSrc <= '0';
          RegWrite <= '0';
          ExtOp <= '1';
   
 else 
 case opcode is
  when "000000" => -- r type
          RegDst <= '1';
          RegWrite <= '1';
          ALUSrc <= '0';
          ExtOp <= '0';
          ALUOp <= "0000";
          MemWrite <= '0';
          MemToReg <= '0';
          Branch <= '0';
          Jump <= '0';
          MemRead <= '0'; 
    
  when "000001" => -- lw
          RegDst <= '0';
          RegWrite <= '1';
          ALUSrc <= '1';
          ExtOp <= '1';
          ALUOp <= "0001";
          MemWrite <= '0';
          MemToReg <= '1';
          Branch <= '0';
          Jump <= '0';
          MemRead <= '1'; 

  when "000010" => -- sw
          RegDst <= '1';
          RegWrite <= '0';
          ALUSrc <= '1';
          ExtOp <= '1';
          ALUOp <= "0001";
          MemWrite <= '1';
          MemToReg <= '0';
          Branch <= '0';
          Jump <= '0';
          MemRead <= '0';
      
  when "000011" => -- addi
          RegDst <= '0';
          RegWrite <= '1';
          ALUSrc <= '1';
          ExtOp <= '1';
          ALUOp <= "0001";
          MemWrite <= '0';
          MemToReg <= '0';
          Branch <= '0';
          Jump <= '0';
          MemRead <= '1';    
          
  when "000100" => -- subi
          RegDst <= '0';
          RegWrite <= '1';
          ALUSrc <= '1';
          ExtOp <= '1';
          ALUOp <= "0010";
          MemWrite <= '0';
          MemToReg <= '0';
          Branch <= '0';
          Jump <= '0';
          MemRead <= '0';
          
  when "000101" => -- andi
          RegDst <= '0';
          RegWrite <= '1';
          ALUSrc <= '1';
          ExtOp <= '1';
          ALUOp <= "0011";
          MemWrite <= '0';
          MemToReg <= '0';
          Branch <= '0';
          Jump <= '0';
          MemRead <= '1';
          
  when "000110" => -- ori
          RegDst <= '0';
          RegWrite <= '1';
          ALUSrc <= '1';
          ExtOp <= '0';
          ALUOp <= "0100";
          MemWrite <= '0';
          MemToReg <= '0';
          Branch <= '0';
          Jump <= '0';
          MemRead <= '1'; 
          
  when "000111" => -- nandi
          RegDst <= '0';
          RegWrite <= '1';
          ALUSrc <= '1';
          ExtOp <= '0';
          ALUOp <= "0101";
          MemWrite <= '0';
          MemToReg <= '0';
          Branch <= '0';
          Jump <= '0';
          MemRead <= '1';
          
  when "001000" => --xori
          RegDst <= '0';
          RegWrite <= '1';
          ALUSrc <= '1';
          ExtOp <= '0';
          ALUOp <= "0110";
          MemWrite <= '0';
          MemToReg <= '0';
          Branch <= '0';
          Jump <= '0';
          MemRead <= '1'; 
          
  when "001001" => -- nori
          RegDst <= '0';
          RegWrite <= '1';
          ALUSrc <= '1';
          ExtOp <= '0';
          ALUOp <= "0111";
          MemWrite <= '0';
          MemToReg <= '0';
          Branch <= '0';
          Jump <= '0';
          MemRead <= '1';
          
  when "001010" => -- beq
          RegDst <= '0';
          RegWrite <= '0';
          ALUSrc <= '0';
          ExtOp <= '1';
          ALUOp <= "0010";
          MemWrite <= '0';
          MemToReg <= '0';
          Branch <= '1';
          Jump <= '0';
          MemRead <= '1'; 
          
  when "001011" => -- jump
          RegDst <= '0';
          RegWrite <= '0';
          ALUSrc <= '0';
          ExtOp <= '0';
          ALUOp <= "0000";
          MemWrite <= '0';
          MemToReg <= '0';
          Branch <= '0';
          Jump <= '1';
          MemRead <= '0';                  
      
  when others => 
          RegDst <= '0';
          MemToReg <= '0';
          ALUOp <= "0000";
          Jump <= '0';
          Branch <= '0';
          MemRead <= '0';
          MemWrite <= '0';
          ALUSrc <= '0';
          RegWrite <= '0';
          ExtOp <= '0';
 end case;
 end if;
end process;

end Behavioral;
