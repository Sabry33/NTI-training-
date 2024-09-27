library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CPU is
    Port (
        Clock        : in  STD_LOGIC;
        Reset        : in  STD_LOGIC;
        ALU_Result   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end CPU;

architecture Behavioral of CPU is

    -- State definitions for FSM
    type state_type is (FETCH_INSTRUCTION, FETCH_A, FETCH_B, DECODE, EXECUTE, WRITE_BACK);
    signal current_state, next_state : state_type := FETCH_INSTRUCTION;

    
    signal PC : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    -- Instruction Register (ACC)
    signal IR : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal A, B : STD_LOGIC_VECTOR(3 downto 0);
    signal ALU_Op : STD_LOGIC_VECTOR(2 downto 0);
    signal ALU_Result_Internal : STD_LOGIC_VECTOR(7 downto 0);


    signal Mem_Address      : STD_LOGIC_VECTOR(3 downto 0);
    signal Mem_Data_in      : STD_LOGIC_VECTOR(7 downto 0);
    signal Mem_Write_enable : STD_LOGIC;
    signal RAM_Data_out     : STD_LOGIC_VECTOR(7 downto 0);

    -- Component Declarations
    component ALU
        port (
            A       : in  STD_LOGIC_VECTOR(3 downto 0);
            B       : in  STD_LOGIC_VECTOR(3 downto 0);
            ALU_Op  : in  STD_LOGIC_VECTOR(2 downto 0);
            Result  : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component RAM
        port (
            Address       : in  STD_LOGIC_VECTOR(3 downto 0);
            Data_in       : in  STD_LOGIC_VECTOR(7 downto 0);
            Write_enable  : in  STD_LOGIC;
            Clock         : in  STD_LOGIC;
            Data_out      : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component Decoder
        port (
            Instruction : in  STD_LOGIC_VECTOR(7 downto 0);
            ALU_Op      : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

begin

    -- ALU Instantiation
    alu_inst : ALU
        port map (
            A       => A,
            B       => B,
            ALU_Op  => ALU_Op,
            Result  => ALU_Result_Internal
        );

    -- RAM Instantiation
    ram_inst : RAM
        port map (
            Address       => Mem_Address,
            Data_in       => Mem_Data_in,
            Write_enable  => Mem_Write_enable,
            Clock         => Clock,
            Data_out      => RAM_Data_out
        );

    -- Decoder Instantiation
    decoder_inst : Decoder
        port map (
            Instruction => IR,
            ALU_Op      => ALU_Op
        );

    -- FSM process: Current state transitions
    process (Clock, Reset)
    begin
        if Reset = '1' then
            current_state <= FETCH_INSTRUCTION;
            PC            <= "0000";
        elsif rising_edge(Clock) then
            current_state <= next_state;
        end if;
    end process;

    -- FSM process: State behavior and next state transitions
    process (current_state)
    begin
        case current_state is
            when FETCH_INSTRUCTION =>
                next_state <= FETCH_A;
            when FETCH_A =>
                next_state <= FETCH_B;
            when FETCH_B =>
                next_state <= DECODE;
            when DECODE =>
                next_state <= EXECUTE;
            when EXECUTE =>
                next_state <= WRITE_BACK;
            when WRITE_BACK =>
                next_state <= FETCH_INSTRUCTION;
            when others =>
                next_state <= FETCH_INSTRUCTION;
        end case;
    end process;

    -- Output Logic and Memory Access Control
    process (Clock)
    begin
        if rising_edge(Clock) then
            case current_state is
                when FETCH_INSTRUCTION =>
                    Mem_Address      <= PC;
                    Mem_Data_in      <= (others => '0');
                    Mem_Write_enable <= '0';
                    IR <= RAM_Data_out;  -- Fetch the instruction
                    PC <= PC + 1;

                when FETCH_A =>
                    Mem_Address      <= IR(3 downto 0);  -- Fetch operand A
                    Mem_Data_in      <= (others => '0');
                    Mem_Write_enable <= '0';
                    A <= RAM_Data_out;
                    PC <= PC + 1;

                when FETCH_B =>
                    Mem_Address      <= IR(7 downto 4);  -- Fetch operand B
                    Mem_Data_in      <= (others => '0');
                    Mem_Write_enable <= '0';
                    B <= RAM_Data_out;
                    PC <= PC + 1;

                when DECODE =>
                    -- ALU control signal set via Decoder component
                    null;

                when EXECUTE =>
                    -- ALU performs operation
                    null;

                when WRITE_BACK =>
                    Mem_Address      <= IR(3 downto 0);       
                    Mem_Data_in      <= ALU_Result_Internal;  
                    Mem_Write_enable <= '1';                  
                    ALU_Result       <= ALU_Result_Internal;  

                when others =>
                    null;
            end case;
        end if;
    end process;

end Behavioral;


