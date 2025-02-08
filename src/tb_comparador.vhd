LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_comparador IS
END tb_comparador;

ARCHITECTURE teste OF tb_comparador IS

	COMPONENT comparador IS

		GENERIC (
			DATA_WIDTH : NATURAL := 16
		);

		PORT (
			a : IN STD_LOGIC_VECTOR ((DATA_WIDTH - 1) DOWNTO 0);
			b : IN STD_LOGIC_VECTOR ((DATA_WIDTH - 1) DOWNTO 0);
			maior : OUT STD_LOGIC;
			menor : OUT STD_LOGIC;
			igual : OUT STD_LOGIC
		);

	END COMPONENT;

	SIGNAL fio_A, fio_B : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL fio_maior, fio_menor, fio_igual : STD_LOGIC;

BEGIN

	-- Note que o componente é instanciado com apenas 4 bits nas entradas para facilitar a simulação:
	instancia_comparador : comparador
	GENERIC MAP(DATA_WIDTH => 4)
	PORT MAP(
		a => fio_A,
		b => fio_B,
		maior => fio_maior,
		menor => fio_menor,
		igual => fio_igual
	);

	-- Dados de entrada de 4 bits são expressos em "hexadecimal" usando "x":
	fio_A <= x"0", x"8" AFTER 20 ns, x"7" AFTER 40 ns, x"4" AFTER 60 ns;
	fio_B <= x"0", x"7" AFTER 10 ns, x"8" AFTER 30 ns, x"1" AFTER 50 ns;
END teste;