LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Cofre_tb IS
END Cofre_tb;

ARCHITECTURE Behavioral OF Cofre_tb IS
    -- Sinais de entrada
    SIGNAL clock : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL confirm : STD_LOGIC := '0';
    SIGNAL cancel : STD_LOGIC := '0';
    SIGNAL password : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mode : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

    -- Sinais de saída
    SIGNAL trava : STD_LOGIC;
    SIGNAL led_verde : STD_LOGIC;
    SIGNAL led_vermelho : STD_LOGIC;

BEGIN
    -- Instanciação do Cofre
    uut: ENTITY work.Cofre
        PORT MAP (
            clock => clock,
            reset => reset,
            confirm => confirm,
            cancel => cancel,
            password => password,
            mode => mode,
            trava => trava,
            led_verde => led_verde,
            led_vermelho => led_vermelho
        );

    -- Processo para gerar o clock
    clock_process: PROCESS
    BEGIN
        clock <= '0';
        WAIT FOR 10 ns;
        clock <= '1';
        WAIT FOR 10 ns;
    END PROCESS;

    -- Processo para aplicar os estímulos
    stim_process: PROCESS
    BEGIN
        -- Teste 1: Reset do sistema
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        WAIT FOR 20 ns;

        -- Teste 2: Carregar senha correta
        password <= "1010101010101010"; -- Senha correta
        mode <= "01"; -- Modo de definição de senha
        confirm <= '1';
        WAIT FOR 20 ns;
        confirm <= '0';
        WAIT FOR 20 ns;

        -- Teste 3: Verificar senha correta
        password <= "1010101010101010"; -- Senha correta
        mode <= "00"; -- Modo de verificação de senha
        confirm <= '1';
        WAIT FOR 20 ns;
        confirm <= '0';
        WAIT FOR 20 ns;
        ASSERT led_verde = '1' AND trava = '0' REPORT "Erro no Teste 3: Acesso permitido não funcionou!" SEVERITY ERROR;

        -- Teste 4: Verificar senha incorreta
        password <= "1111111111111111"; -- Senha incorreta
        confirm <= '1';
        WAIT FOR 20 ns;
        confirm <= '0';
        WAIT FOR 20 ns;
        ASSERT led_vermelho = '1' AND trava = '1' REPORT "Erro no Teste 4: Acesso negado não funcionou!" SEVERITY ERROR;

        -- Finaliza a simulação
        WAIT;
    END PROCESS;
END Behavioral;