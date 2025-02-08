LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controladora IS
    PORT (
        reset : IN STD_LOGIC;
        clock : IN STD_LOGIC;
        confirm : IN STD_LOGIC;
        cancel : IN STD_LOGIC;
        mode_in : IN STD_LOGIC;
        correct_password : IN STD_LOGIC;
        block_system : IN STD_LOGIC;
        mode_out : OUT STD_LOGIC;
        load_password : OUT STD_LOGIC;
        reset_system : OUT STD_LOGIC;
        trava : OUT STD_LOGIC;
        led_verde : OUT STD_LOGIC;
        led_vermelho : OUT STD_LOGIC
    );
END controladora;

ARCHITECTURE arch OF controladora IS
    -- Enumerated type for state machine states
    TYPE state_type IS (INIT, SELECIONA_MODO, DIGITANDO_SENHA, DEFININDO_SENHA, VERIFICANDO, ACESSO_PERMITIDO, ACESSO_NEGADO, BLOQUEADO);

    -- Signal to hold the current state
    SIGNAL current_state, next_state : state_type;

BEGIN
    -- Process for state transitions (sequential logic)
    PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            current_state <= INIT; -- Initial state
        ELSIF RISING_EDGE(clock) THEN
            current_state <= next_state;
        END IF;
    END PROCESS;

    -- Process for next state logic and output generation (combinational logic)
    PROCESS (current_state, confirm, cancel, mode_in, correct_password, block_system)
    BEGIN
        -- Default assignments for outputs
        mode_out <= '0';
        load_password <= '0';
        reset_system <= '0';
        trava <= '1';
        led_verde <= '0';
        led_vermelho <= '0';
        next_state <= current_state; -- Default state

        CASE current_state IS
            WHEN INIT =>
                -- Estado inicial: trava ativada, LEDs desligados
                reset_system <= '1'; -- Reseta o sistema
                trava <= '1'; -- Trava ativada
                led_verde <= '0';
                led_vermelho <= '0';
                next_state <= SELECIONA_MODO;

            WHEN SELECIONA_MODO =>
                -- Aguarda seleção do modo (digitar senha ou definir senha)
                IF mode_in = '1' AND confirm = '1' THEN
                    next_state <= DEFININDO_SENHA; -- Modo de definir senha
                ELSE
                    next_state <= DIGITANDO_SENHA; -- Modo de digitar senha
                END IF;

            WHEN DEFININDO_SENHA =>
                -- Modo de definir senha
                mode_out <= '1'; -- Indica modo de definição de senha
                IF confirm = '1' THEN
                    load_password <= '1'; -- Carrega a nova senha
                    next_state <= SELECIONA_MODO; -- Volta para seleção de modo
                END IF;

            WHEN DIGITANDO_SENHA =>
                -- Modo de digitar senha
                mode_out <= '0'; -- Indica modo de digitação de senha
                IF confirm = '1' THEN
                    next_state <= VERIFICANDO; -- Vai para verificação de senha
                END IF;

            WHEN VERIFICANDO =>
                -- Verifica a senha digitada
                IF correct_password = '1' THEN
                    next_state <= ACESSO_PERMITIDO; -- Senha correta
                ELSE
                    next_state <= ACESSO_NEGADO; -- Senha incorreta
                END IF;

            WHEN ACESSO_PERMITIDO =>
                -- Acesso permitido: trava desativada, LED verde aceso
                trava <= '0'; -- Trava desativada
                led_verde <= '1'; -- LED verde aceso
                IF cancel = '1' THEN
                    next_state <= SELECIONA_MODO; -- Volta para seleção de modo
                END IF;

            WHEN ACESSO_NEGADO =>
                -- Acesso negado: trava ativada, LED vermelho aceso
                trava <= '1'; -- Trava ativada
                led_vermelho <= '1'; -- LED vermelho aceso
                IF block_system = '1' THEN
                    next_state <= BLOQUEADO; -- Bloqueia o sistema após várias tentativas
                ELSIF cancel = '1' THEN
                    next_state <= SELECIONA_MODO; -- Volta para seleção de modo
                END IF;

            WHEN BLOQUEADO =>
                -- Sistema bloqueado: trava ativada, LED vermelho aceso
                trava <= '1'; -- Trava ativada
                led_vermelho <= '1'; -- LED vermelho aceso
                IF reset = '1' THEN
                    next_state <= INIT; -- Reseta o sistema
                END IF;

            WHEN OTHERS =>
                next_state <= INIT; -- Default state
        END CASE;
    END PROCESS;

END arch;