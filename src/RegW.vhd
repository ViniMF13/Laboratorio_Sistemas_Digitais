LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY RegW IS
    GENERIC (
        W : INTEGER := 16 -- Largura padrão do registrador
    );
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC; -- Reset assíncrono ativo em '1'
        load : IN STD_LOGIC; -- Load síncrono ativo em '1'
        D : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(W - 1 DOWNTO 0)
    );
END RegW;

ARCHITECTURE behavior OF RegW IS
    SIGNAL reg_value : STD_LOGIC_VECTOR(W - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            reg_value <= (OTHERS => '0'); -- Reset do registrador
        ELSIF rising_edge(clock) THEN
            IF load = '1' THEN
                reg_value <= D; -- Carrega o valor de D no registrador
            END IF;
        END IF;
    END PROCESS;

    Q <= reg_value; -- Saída do registrador
END behavior;