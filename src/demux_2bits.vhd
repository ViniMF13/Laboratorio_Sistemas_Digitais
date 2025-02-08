LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY demux_2bits IS
    GENERIC (
        DATA_WIDTH : INTEGER := 1 -- Tamanho padrão de D 
    );
    PORT (
        D : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); -- Entrada de dados (tamanho genérico)
        C1 : IN STD_LOGIC; -- Entrada de controle 1
        C0 : IN STD_LOGIC; -- Entrada de controle 0
        Y0 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); -- Saída 0 (tamanho genérico)
        Y1 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); -- Saída 1 (tamanho genérico)
        Y2 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); -- Saída 2 (tamanho genérico)
        Y3 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) -- Saída 3 (tamanho genérico)
    );
END demux_2bits;

ARCHITECTURE Behavioral OF demux_2bits IS
BEGIN
    -- Lógica do demux
    Y0 <= D WHEN (C1 = '0' AND C0 = '0') ELSE
        (OTHERS => '0'); -- Saída Y0 ativa quando C1=0 e C0=0
    Y1 <= D WHEN (C1 = '0' AND C0 = '1') ELSE
        (OTHERS => '0'); -- Saída Y1 ativa quando C1=0 e C0=1
    Y2 <= D WHEN (C1 = '1' AND C0 = '0') ELSE
        (OTHERS => '0'); -- Saída Y2 ativa quando C1=1 e C0=0
    Y3 <= D WHEN (C1 = '1' AND C0 = '1') ELSE
        (OTHERS => '0'); -- Saída Y3 ativa quando C1=1 e C0=1
END Behavioral;