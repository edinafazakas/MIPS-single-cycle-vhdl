library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ssd is
    Port (  dig: in std_logic_vector(15 downto 0);
            clk: in std_logic;
            cat: out std_logic_vector(6 downto 0);
            an: out std_logic_vector(3 downto 0)  
         );
end ssd;


architecture Behavioral of SSD is

signal out1: std_logic_vector(3 downto 0):= "0000";
signal count: std_logic_vector(15 downto 0);


begin

process (out1)
begin
    case out1 is
        when "0000"=> cat <="1000000";  -- '0'
        when "0001"=> cat <="1111001";  -- '1'
        when "0010"=> cat <="0100100";  -- '2'
        when "0011"=> cat <="0110000";  -- '3'
        when "0100"=> cat <="0011001";  -- '4' 
        when "0101"=> cat <="0010010";  -- '5'
        when "0110"=> cat <="0000010";  -- '6'
        when "0111"=> cat <="1111000";  -- '7'
        when "1000"=> cat <="0000000";  -- '8'
        when "1001"=> cat <="0010000";  -- '9'
        when "1010"=> cat <="0001000";  -- 'A'
        when "1011"=> cat <="0000011";  -- 'b'
        when "1100"=> cat <="1000110";  -- 'C'
        when "1101"=> cat <="0100001";  -- 'd'
        when "1110"=> cat <="0000110";  -- 'E'
        when "1111"=> cat <="0001110";  -- 'F'
        when others =>  cat <= "0000000";
    end case;
end process;
        
process (clk) 
begin
   if clk'event and clk='1' then
           count <= count + 1;
   end if;
end process;
                  
                  
process(count, dig)
begin
    case count(15 downto 14) is 
       when "00" => out1 <= dig(3 downto 0);
       when "01" => out1 <= dig(7 downto 4);
       when "10" => out1 <= dig(11 downto 8);
       when "11" => out1 <= dig(15 downto 12);      
       when others => out1 <= (others => '0');
       end case;
end process;
                  
                  
                  
process(count)
begin
    case count(15 downto 14) is 
       when "00" => an <= "1110";
       when "01" => an <= "1101";
       when "10" => an <= "1011";
       when others => an <= "0111";
       end case;
end process;         
      
         
    
end Behavioral;
