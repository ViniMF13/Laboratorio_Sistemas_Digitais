LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_demux_2bits IS
END tb_demux_2bits;

ARCHITECTURE Behavioral OF tb_demux_2bits IS
    -- Declaração dos sinais para o testbench
    SIGNAL D : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00"; -- Entrada de dados (2 bits para teste)
    SIGNAL C1 : STD_LOGIC := '0'; -- Entrada de controle 1
    SIGNAL C0 : STD_LOGIC := '0'; -- Entrada de controle 0
    SIGNAL Y0 : STD_LOGIC_VECTOR(1 DOWNTO 0); -- Saída 0
    SIGNAL Y1 : STD_LOGIC_VECTOR(1 DOWNTO 0); -- Saída 1
    SIGNAL Y2 : STD_LOGIC_VECTOR(1 DOWNTO 0); -- Saída 2
    SIGNAL Y3 : STD_LOGIC_VECTOR(1 DOWNTO 0); -- Saída 3

    -- Instanciação do componente a ser testado
    COMPONENT demux_2bits
        GENERIC (
            DATA_WIDTH : INTEGER := 2 -- Define o tamanho dos dados como 2 bits para o teste
        );
        PORT (
            D : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            C1 : IN STD_LOGIC;
            C0 : IN STD_LOGIC;
            Y0 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            Y1 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            Y2 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            Y3 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    -- Instanciação do demux
    uut : demux_2bits
    GENERIC MAP(DATA_WIDTH => 2) -- Define o tamanho dos dados como 2 bits para o teste
    PORT MAP(
        D => D,
        C1 => C1,
        C0 => C0,
        Y0 => Y0,
        Y1 => Y1,
        Y2 => Y2,
        Y3 => Y3
    );

    -- Processo para aplicar os estímulos
    stim_process : PROCESS
    BEGIN
        -- Teste 1: C1=0, C0=0 (Y0 deve receber D)
        D <= "01";
        C1 <= '0';
        C0 <= '0';
        WAIT FOR 10 ns;
        ASSERT Y0 = "01" REPORT "Erro no Teste 1: Y0 não recebeu D corretamente!" SEVERITY ERROR;

        -- Teste 2: C1=0, C0=1 (Y1 deve receber D)
        D <= "10";
        C1 <= '0';
        C0 <= '1';
        WAIT FOR 10 ns;
        ASSERT Y1 = "10" REPORT "Erro no Teste 2: Y1 não recebeu D corretamente!" SEVERITY ERROR;

        -- Teste 3: C1=1, C0=0 (Y2 deve receber D)
        D <= "11";
        C1 <= '1';
        C0 <= '0';
        WAIT FOR 10 ns;
        ASSERT Y2 = "11" REPORT "Erro no Teste 3: Y2 não recebeu D corretamente!" SEVERITY ERROR;

        -- Teste 4: C1=1, C0=1 (Y3 deve receber D)
        D <= "00";
        C1 <= '1';
        C0 <= '1';
        WAIT FOR 10 ns;
        ASSERT Y3 = "00" REPORT "Erro no Teste 4: Y3 não recebeu D corretamente!" SEVERITY ERROR;

        -- Finaliza a simulação
        WAIT;
    END PROCESS;
END Behavioral;