LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY tb_fulladder_4bits IS
END tb_fulladder_4bits;

ARCHITECTURE behavior OF tb_fulladder_4bits IS

    -- Sinal para os testes
    SIGNAL A, B : std_logic_vector(3 DOWNTO 0);
    SIGNAL Cin  : std_logic;
    SIGNAL S    : std_logic_vector(3 DOWNTO 0);
    SIGNAL Cout : std_logic;

    -- Instanciação do somador
    COMPONENT fulladder_4bits
        PORT(
            A    : IN  std_logic_vector(3 DOWNTO 0);
            B    : IN  std_logic_vector(3 DOWNTO 0);
            Cin  : IN  std_logic;
            S    : OUT std_logic_vector(3 DOWNTO 0);
            Cout : OUT std_logic
        );
    END COMPONENT;

BEGIN

    -- Instanciando o somador
    uut: fulladder_4bits PORT MAP (A, B, Cin, S, Cout);		

    -- Processo para gerar estímulos
    stim_proc: PROCESS
    BEGIN
        -- Teste 1
        A <= "0001"; B <= "0011"; Cin <= '0';  -- 1 + 3 = 4
        WAIT FOR 10 ns;

        -- Teste 2
        A <= "1101"; B <= "1010"; Cin <= '0';  -- 13 + 10 = 23
        WAIT FOR 10 ns;

        -- Teste 3
        A <= "1111"; B <= "1111"; Cin <= '1';  -- 15 + 15 + 1 = 31
        WAIT FOR 10 ns;

        -- Teste 4
        A <= "1010"; B <= "0101"; Cin <= '1';  -- 10 + 5 + 1 = 16
        WAIT FOR 10 ns;

        -- Teste 5
        A <= "0000"; B <= "0000"; Cin <= '0';  -- 0 + 0 = 0
        WAIT FOR 10 ns;

        -- Teste 6
        A <= "1111"; B <= "0000"; Cin <= '0';  -- 15 + 0 = 15
        WAIT FOR 10 ns;

        WAIT;
    END PROCESS;

END behavior;
