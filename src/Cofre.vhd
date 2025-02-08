LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Cofre IS
    PORT (
        clock : IN STD_LOGIC; -- Clock do sistema
        reset : IN STD_LOGIC; -- Reset do sistema
        confirm : IN STD_LOGIC; -- Sinal de confirmação
        cancel : IN STD_LOGIC; -- Sinal de cancelamento
        password : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- Senha de entrada
        mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Modo de operação
        trava : OUT STD_LOGIC; -- Sinal de trava (1 = travado, 0 = destravado)
        led_verde : OUT STD_LOGIC; -- LED verde (acesso permitido)
        led_vermelho : OUT STD_LOGIC -- LED vermelho (acesso negado ou bloqueio)
    );
END Cofre;

ARCHITECTURE Behavioral OF Cofre IS
    -- Componentes
    COMPONENT Datapath
        PORT (
            clock : IN STD_LOGIC;
            password : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            mode_out : IN STD_LOGIC;
            load_password : IN STD_LOGIC;
            reset_system : IN STD_LOGIC;
            mode_in : OUT STD_LOGIC;
            corect_pass : OUT STD_LOGIC;
            block_system : OUT STD_LOGIC;
            time_remaining : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Controladora
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            confirm : IN STD_LOGIC;
            cancel : IN STD_LOGIC;
            mode : IN STD_LOGIC;
            correct_password : IN STD_LOGIC;
            block_system : IN STD_LOGIC;
            mode_out : OUT STD_LOGIC;
            load_password : OUT STD_LOGIC;
            reset_system : OUT STD_LOGIC;
            trava : OUT STD_LOGIC;
            led_verde : OUT STD_LOGIC;
            led_vermelho : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Sinais internos para conectar o Datapath e a Controladora
    SIGNAL mode_out : STD_LOGIC; -- Sinal de saída do modo (Controladora -> Datapath)
    SIGNAL load_password : STD_LOGIC; -- Sinal para carregar a senha (Controladora -> Datapath)
    SIGNAL reset_system : STD_LOGIC; -- Sinal de reset do sistema (Controladora -> Datapath)
    SIGNAL mode_in : STD_LOGIC; -- Sinal de entrada do modo (Datapath -> Controladora)
    SIGNAL corect_pass : STD_LOGIC; -- Sinal de senha correta (Datapath -> Controladora)
    SIGNAL block_system : STD_LOGIC; -- Sinal de bloqueio do sistema (Datapath -> Controladora)
    SIGNAL time_remaining : STD_LOGIC; -- Sinal de tempo restante (Datapath -> Controladora)

BEGIN
    -- Instanciação do Datapath
    dp : Datapath
    PORT MAP (
        clock => clock,
        password => password,
        mode => mode,
        mode_out => mode_out,
        load_password => load_password,
        reset_system => reset_system, -- Reset controlado pela Controladora
        mode_in => mode_in,
        corect_pass => corect_pass,
        block_system => block_system,
        time_remaining => time_remaining
    );

    -- Instanciação da Controladora
    ctrl : Controladora
    PORT MAP (
        clock => clock,
        reset => reset, -- Reset externo
        confirm => confirm,
        cancel => cancel,
        mode => mode(0), -- Usa o bit menos significativo do modo
        correct_password => corect_pass,
        block_system => block_system,
        mode_out => mode_out,
        load_password => load_password,
        reset_system => reset_system, -- Reset interno
        trava => trava,
        led_verde => led_verde,
        led_vermelho => led_vermelho
    );

END Behavioral;