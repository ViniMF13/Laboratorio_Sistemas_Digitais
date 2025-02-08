LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_timer IS
END tb_timer;

ARCHITECTURE Behavioral OF tb_timer IS
    -- Declaração dos sinais para o testbench
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL start_timer : STD_LOGIC := '0';
    SIGNAL time_expired : STD_LOGIC;

    -- Instanciação do componente a ser testado
    COMPONENT timer
        GENERIC (
            W : NATURAL := 1000000
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            start_timer : IN STD_LOGIC;
            time_expired : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    -- Instanciação do timer
    uut: timer
        GENERIC MAP (W => 10) -- Define um limite menor para facilitar a simulação
        PORT MAP (
            clk => clk,
            reset => reset,
            start_timer => start_timer,
            time_expired => time_expired
        );

    -- Processo para gerar o clock
    clk_process: PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 5 ns;
        clk <= '1';
        WAIT FOR 5 ns;
    END PROCESS;

    -- Processo para aplicar os estímulos
    stim_process: PROCESS
    BEGIN
        -- Reseta o timer
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        WAIT FOR 20 ns;

        -- Inicia o timer
        start_timer <= '1';
        WAIT FOR 20 ns;
        start_timer <= '0';
        WAIT FOR 200 ns; -- Espera o tempo necessário para o timer expirar

        -- Verifica se o tempo expirou
        IF time_expired = '1' THEN
            REPORT "Timer expirado corretamente!" SEVERITY NOTE;
        ELSE
            REPORT "Timer não expirou!" SEVERITY ERROR;
        END IF;

        -- Finaliza a simulação
        WAIT;
    END PROCESS;
END Behavioral;