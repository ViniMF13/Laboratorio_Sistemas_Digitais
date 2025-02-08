LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- Para operações aritméticas

ENTITY Datapath IS
    PORT (
        clock : IN STD_LOGIC; -- clock externo
        password : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- Senha de entrada
        mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Modo de operação
        mode_out : IN STD_LOGIC; -- Sinal de saída do modo
        load_password : IN STD_LOGIC; -- Sinal para carregar a senha
        reset_system : IN STD_LOGIC; -- Reset do sistema
        mode_in : OUT STD_LOGIC; -- Sinal de entrada do modo
        reset : OUT STD_LOGIC; -- Sinal de reset
        corect_pass : OUT STD_LOGIC; -- Sinal de senha correta
        block_system : OUT STD_LOGIC; -- Sinal de bloqueio do sistema
        time_remaining : OUT STD_LOGIC -- Sinal de tempo restante
    );
END Datapath;

ARCHITECTURE estrutural OF Datapath IS

    -- Declaração dos componentes

    COMPONENT RegW
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
    END COMPONENT;

    COMPONENT comparador
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
    END COMPONENT;

    COMPONENT timer
        GENERIC (
            W : NATURAL := 1000000 -- Valor padrão (ciclos de clk) para o timer
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            start_timer : IN STD_LOGIC;
            time_expired : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT fulladder_4bits
        PORT (
            A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Cin : IN STD_LOGIC;
            S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            Cout : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Sinais internos
    SIGNAL reg_password_out : STD_LOGIC_VECTOR(15 DOWNTO 0); -- Saída do registrador de senha
    SIGNAL reg_error_count_out : STD_LOGIC_VECTOR(1 DOWNTO 0); -- Saída do registrador de contagem de erros
    SIGNAL comp_password_out : STD_LOGIC; -- Saída do comparador de senhas
    SIGNAL comp_error_count_out : STD_LOGIC; -- Saída do comparador de contagem de erros
    SIGNAL timer_led_out : STD_LOGIC; -- Saída do timer para piscar o LED
    SIGNAL timer_block_out : STD_LOGIC; -- Saída do timer para bloquear o sistema
    SIGNAL counter_out : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Saída do contador de 4 bits
    SIGNAL load_error_count : STD_LOGIC; -- Sinal intermediário para o load do registrador de contagem de erros
    SIGNAL counter_input : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Sinal intermediário para a entrada do contador
    SIGNAL start_timer_led : STD_LOGIC; -- Sinal intermediário para o start_timer do timer_led

BEGIN

    -- Sinal intermediário para o load do registrador de contagem de erros
    load_error_count <= NOT comp_password_out;

    -- Sinal intermediário para a entrada do contador
    counter_input <= "00" & reg_error_count_out;

    -- Sinal intermediário para o start_timer do timer_led
    start_timer_led <= NOT comp_error_count_out;

    -- Instanciação do registrador de senha
    reg_password : RegW
    GENERIC MAP(
        W => 16
    )
    PORT MAP(
        clock => clock,
        reset => reset_system,
        load => load_password,
        D => password,
        Q => reg_password_out
    );

    -- Instanciação do registrador de contagem de erros
    reg_error_count : RegW
    GENERIC MAP(
        W => 2
    )
    PORT MAP(
        clock => clock,
        reset => reset_system,
        load => load_error_count, -- Usa o sinal intermediário
        D => counter_out(1 DOWNTO 0), -- Usa os 2 bits menos significativos do contador
        Q => reg_error_count_out
    );

    -- Instanciação do comparador de senhas
    comp_password : comparador
    GENERIC MAP(
        DATA_WIDTH => 16
    )
    PORT MAP(
        a => password,
        b => reg_password_out,
        igual => comp_password_out,
        maior => OPEN,
        menor => OPEN
    );

    -- Instanciação do comparador de contagem de erros
    comp_error_count : comparador
    GENERIC MAP(
        DATA_WIDTH => 2
    )
    PORT MAP(
        a => reg_error_count_out,
        b => "11", -- Compara com 3 (em binário: "11")
        igual => comp_error_count_out,
        maior => OPEN,
        menor => OPEN
    );

    -- Instanciação do contador de 4 bits
    counter : fulladder_4bits
    PORT MAP(
        A => counter_input, -- Usa o sinal intermediário
        B => "0001", -- Incremento de 1
        Cin => '0', -- Sem carry inicial
        S => counter_out,
        Cout => OPEN
    );

    -- Instanciação do timer para piscar o LED
    timer_led : timer
    GENERIC MAP(
        W => 1000000 -- Define o tempo para piscar o LED
    )
    PORT MAP(
        clk => clock,
        reset => reset_system,
        start_timer => start_timer_led, -- Usa o sinal intermediário
        time_expired => timer_led_out
    );

    -- Instanciação do timer para bloquear o sistema
    timer_block : timer
    GENERIC MAP(
        W => 5000000 -- Define o tempo para bloquear o sistema
    )
    PORT MAP(
        clk => clock,
        reset => reset_system,
        start_timer => comp_error_count_out, -- Inicia o timer quando a contagem de erros atinge 3
        time_expired => timer_block_out
    );

    -- Lógica de saída
    mode_in <= mode(0); -- Modo de operação
    reset <= reset_system; -- Reset do sistema
    corect_pass <= comp_password_out; -- Senha correta
    block_system <= timer_block_out; -- Bloqueio do sistema
    time_remaining <= timer_led_out; -- Tempo restante

END estrutural;