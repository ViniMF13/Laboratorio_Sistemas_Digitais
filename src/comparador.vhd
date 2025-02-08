LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY comparador IS
    GENERIC (
        DATA_WIDTH : NATURAL := 16 -- Largura dos vetores A e B
    );
    PORT (
        a : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        maior : OUT STD_LOGIC;
        menor : OUT STD_LOGIC;
        igual : OUT STD_LOGIC
    );
END comparador;

ARCHITECTURE concorrente OF comparador IS
BEGIN
    -- Comparação considerando valores absolutos
    maior <= '1' WHEN (UNSIGNED(a) > UNSIGNED(b)) ELSE
        '0';
    menor <= '1' WHEN (UNSIGNED(a) < UNSIGNED(b)) ELSE
        '0';
    igual <= '1' WHEN (UNSIGNED(a) = UNSIGNED(b)) ELSE
        '0';
END concorrente;