LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY tb_RegW IS
END tb_RegW;

ARCHITECTURE behavior OF tb_RegW IS

    -- Component Declaration
    COMPONENT RegW
        GENERIC (
            W : INTEGER := 16
        );
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            load : IN STD_LOGIC;
            D : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(W - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for the testbench
    SIGNAL meu_clock : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC;
    SIGNAL load : STD_LOGIC;
    SIGNAL D : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Q : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    -- Instantiate the RegW with W=4
    uut : RegW
    GENERIC MAP(
        W => 16
    )
    PORT MAP(
        clock => meu_clock,
        reset => reset,
        load => load,
        D => D,
        Q => Q
    );

    -- Clock stimulus generation
    meu_clock <= NOT meu_clock AFTER 5 ns;

    -- Testbench process to apply inputs
    stimulus : PROCESS
    BEGIN
        -- Initialize inputs
        reset <= '0';
        load <= '0';
        D <= (OTHERS => '0');

        -- Hold reset for 20 ns
        WAIT FOR 20 ns;
        reset <= '1';

        -- Test Case 1: Load data into register
        WAIT FOR 10 ns;
        load <= '1';
        D <= x"10";
        WAIT FOR 10 ns;
        load <= '0';

        -- Test Case 2: Change data without load
        WAIT FOR 20 ns;
        load <= '1';
        D <= x"12";
        WAIT FOR 10 ns;

        -- Test Case 3: Reset the register
        reset <= '0';
        WAIT FOR 10 ns;
        reset <= '1';

        -- End simulation
        WAIT FOR 50 ns;
        ASSERT FALSE REPORT "End of simulation" SEVERITY NOTE;
        WAIT;
    END PROCESS;

END behavior;