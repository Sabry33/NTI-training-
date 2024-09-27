library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity ALU is
    Port ( A       : in STD_LOGIC_VECTOR(3 downto 0);
           B       : in STD_LOGIC_VECTOR(3 downto 0);
           ALU_Op  : in STD_LOGIC_VECTOR(2 downto 0);
           result  : out STD_LOGIC_VECTOR(7 downto 0));
end ALU;

architecture Behavioral of ALU is
begin
    process (A, B, ALU_Op)
    begin
        case ALU_Op is
            when "000" =>  result <= std_logic_vector(unsigned(A) + unsigned(B));         
            when "001" =>  result <= std_logic_vector(unsigned(A) * unsigned(B));          
            when "010" =>  result <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));        
            when "011" =>  result <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));       
            when "100" =>  result <= std_logic_vector(rotate_left(unsigned(A), to_integer(unsigned(B))));      
            when "101" =>  result <= std_logic_vector(rotate_right(unsigned(A), to_integer(unsigned(B))));      
            when others => result <= (others => '0'); -- Default
        end case;
    end process;
end Behavioral;

