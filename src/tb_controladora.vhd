LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_controladora IS
END tb_controladora;

ARCHITECTURE Behavioral OF tb_controladora IS
    -- Sinais de entrada
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL clock : STD_LOGIC := '0';
    SIGNAL confirm : STD_LOGIC := '0';
    SIGNAL cancel : STD_LOGIC := '0';
    SIGNAL mode_in : STD_LOGIC := '0';
    SIGNAL correct_password : STD_LOGIC := '0';
    SIGNAL block_system : STD_LOGIC := '0';

    -- Sinais de saída
    SIGNAL mode_out : STD_LOGIC;
    SIGNAL load_password : STD_LOGIC;
    SIGNAL reset_system : STD_LOGIC;
    SIGNAL trava : STD_LOGIC;
    SIGNAL led_verde : STD_LOGIC;
    SIGNAL led_vermelho : STD_LOGIC;

BEGIN
    -- Instanciação da FSM
    uut : ENTITY work.controladora
        PORT MAP(
            reset => reset,
            clock => clock,
            confirm => confirm,
            cancel => cancel,
            mode_in => mode_in,
            correct_password => correct_password,
            block_system => block_system,
            mode_out => mode_out,
            load_password => load_password,
            reset_system => reset_system,
            trava => trava,
            led_verde => led_verde,
            led_vermelho => led_vermelho
        );

    -- Processo para gerar o clock
    clock_process : PROCESS
    BEGIN
        clock <= '0';
        WAIT FOR 10 ns;
        clock <= '1';
        WAIT FOR 10 ns;
    END PROCESS;

    -- Processo para aplicar os estímulos
    stim_process : PROCESS
    BEGIN
        -- Teste 1: Reset do sistema
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        WAIT FOR 20 ns;

        -- Teste 2: Seleção de modo (digitar senha)
        mode_in <= '0';
        WAIT FOR 20 ns;

        -- Teste 3: Digitação de senha correta
        confirm <= '1';
        correct_password <= '1';
        WAIT FOR 20 ns;
        confirm <= '0';
        WAIT FOR 20 ns;

        -- Teste 4: Acesso permitido
        ASSERT trava = '0' AND led_verde = '1' REPORT "Erro no Teste 4: Acesso permitido não funcionou!" SEVERITY ERROR;

        -- Finaliza a simulação
        WAIT;
    END PROCESS;
END Behavioral;