LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- 5. Timers
ENTITY timer IS
    GENERIC (
        W : NATURAL := 1000000 -- Valor padrão (ciclos de clk) para o timer
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        start_timer : IN STD_LOGIC;
        time_expired : OUT STD_LOGIC -- Ativado em '0'
    );
END timer;

ARCHITECTURE Behavioral OF timer IS
    CONSTANT TIME_LIMIT : INTEGER := W; -- Define o limite de tempo
    SIGNAL timer_count : INTEGER := 0; -- Contador interno
    SIGNAL counting : STD_LOGIC := '0'; -- Sinal para indicar que o timer está contando
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            -- Reseta o contador e desativa o sinal de tempo expirado
            timer_count <= 0;
            time_expired <= '1';
            counting <= '0';
        ELSIF rising_edge(clk) THEN
            -- Detecta a borda de subida de start_timer para iniciar a contagem
            IF start_timer = '1' AND counting = '0' THEN
                counting <= '1'; -- Inicia a contagem
                timer_count <= 0; -- Reinicia o contador
                time_expired <= '1'; -- Desativa o sinal de tempo expirado
            END IF;

            -- Se o timer estiver contando, incrementa o contador
            IF counting = '1' THEN
                IF timer_count < TIME_LIMIT THEN
                    timer_count <= timer_count + 1; -- Incrementa o contador
                ELSE
                    time_expired <= '0'; -- Ativa o sinal de tempo expirado
                    counting <= '0'; -- Para a contagem
                END IF;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;