LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_Datapath IS
END tb_Datapath;

ARCHITECTURE Behavioral OF tb_Datapath IS
    -- Sinais de entrada
    SIGNAL clock : STD_LOGIC := '0';
    SIGNAL password : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mode : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL mode_out : STD_LOGIC := '0';
    SIGNAL load_password : STD_LOGIC := '0';
    SIGNAL reset_system : STD_LOGIC := '0';

    -- Sinais de saída
    SIGNAL mode_in : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL corect_pass : STD_LOGIC;
    SIGNAL block_system : STD_LOGIC;
    SIGNAL time_remaining : STD_LOGIC;

    -- Instanciação do Datapath
    COMPONENT Datapath
        PORT (
            clock : IN STD_LOGIC;
            password : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            mode_out : IN STD_LOGIC;
            load_password : IN STD_LOGIC;
            reset_system : IN STD_LOGIC;
            mode_in : OUT STD_LOGIC;
            reset : OUT STD_LOGIC;
            corect_pass : OUT STD_LOGIC;
            block_system : OUT STD_LOGIC;
            time_remaining : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    -- Instanciação do Datapath
    uut: Datapath
        PORT MAP (
            clock => clock,
            password => password,
            mode => mode,
            mode_out => mode_out,
            load_password => load_password,
            reset_system => reset_system,
            mode_in => mode_in,
            reset => reset,
            corect_pass => corect_pass,
            block_system => block_system,
            time_remaining => time_remaining
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
        reset_system <= '1';
        WAIT FOR 20 ns;
        reset_system <= '0';
        WAIT FOR 20 ns;

        -- Teste 2: Carregar senha correta
        password <= "1010101010101010"; -- Senha correta
        load_password <= '1';
        WAIT FOR 20 ns;
        load_password <= '0';
        WAIT FOR 20 ns;

        -- Teste 3: Verificar senha correta
        password <= "1010101010101010"; -- Senha correta
        mode <= "00"; -- Modo de verificação
        WAIT FOR 20 ns;
        ASSERT corect_pass = '1' REPORT "Erro no Teste 3: Senha correta não detectada!" SEVERITY ERROR;

        -- Teste 4: Verificar senha incorreta
        password <= "1111111111111111"; -- Senha incorreta
        WAIT FOR 20 ns;
        ASSERT corect_pass = '0' REPORT "Erro no Teste 4: Senha incorreta detectada como correta!" SEVERITY ERROR;

        -- Teste 5: Contagem de erros
        -- Primeira tentativa incorreta
        password <= "1111111111111111"; -- Senha incorreta
        WAIT FOR 20 ns;
        ASSERT corect_pass = '0' REPORT "Erro no Teste 5.1: Senha incorreta não detectada!" SEVERITY ERROR;

        -- Segunda tentativa incorreta
        password <= "1111111111111111"; -- Senha incorreta
        WAIT FOR 20 ns;
        ASSERT corect_pass = '0' REPORT "Erro no Teste 5.2: Senha incorreta não detectada!" SEVERITY ERROR;

        -- Terceira tentativa incorreta (bloqueio do sistema)
        password <= "1111111111111111"; -- Senha incorreta
        WAIT FOR 20 ns;
        ASSERT corect_pass = '0' REPORT "Erro no Teste 5.3: Senha incorreta não detectada!" SEVERITY ERROR;
        ASSERT block_system = '1' REPORT "Erro no Teste 5.3: Sistema não bloqueado após 3 tentativas incorretas!" SEVERITY ERROR;

        -- Teste 6: Reset do sistema após bloqueio
        reset_system <= '1';
        WAIT FOR 20 ns;
        reset_system <= '0';
        WAIT FOR 20 ns;
        ASSERT block_system = '0' REPORT "Erro no Teste 6: Sistema não resetado corretamente!" SEVERITY ERROR;

        -- Finaliza a simulação
        WAIT;
    END PROCESS;
END Behavioral;