
library ieee;
use ieee.std_logic_1164.all;
entity LFO_freq is
 port (LFO_freq_in : in std_logic_vector(6 downto 0);
    rate : out std_logic_vector(14 downto 0));
 end entity LFO_freq;
 architecture arch_LFO_freq of LFO_freq is
    type mem is array ( 0 to 2**7 - 1) of std_logic_vector(14 downto 0);
    constant LFO_freq_rom : mem := (
    0 => "110000110101000",
    1 => "101110110101010",
    2 => "101100111010101",
    3 => "101011000101001",
    4 => "101001010100011",
    5 => "100111101000010",
    6 => "100110000000100",
    7 => "100100011101001",
    8 => "100010111101101",
    9 => "100001100010001",
    10 => "100000001010011",
    11 => "011110110110010",
    12 => "011101100101100",
    13 => "011100011000001",
    14 => "011011001101111",
    15 => "011010000110101",
    16 => "011001000010010",
    17 => "011000000000110",
    18 => "010111000001111",
    19 => "010110000101101",
    20 => "010101001011111",
    21 => "010100010100011",
    22 => "010011011111010",
    23 => "010010101100010",
    24 => "010001111011011",
    25 => "010001001100011",
    26 => "010000011111011",
    27 => "001111110100010",
    28 => "001111001010111",
    29 => "001110100011001",
    30 => "001101111101001",
    31 => "001101011000101",
    32 => "001100110101100",
    33 => "001100010100000",
    34 => "001011110011110",
    35 => "001011010100111",
    36 => "001010110111010",
    37 => "001010011010110",
    38 => "001001111111100",
    39 => "001001100101011",
    40 => "001001001100010",
    41 => "001000110100010",
    42 => "001000011101001",
    43 => "001000000111000",
    44 => "000111110001110",
    45 => "000111011101100",
    46 => "000111001001111",
    47 => "000110110111010",
    48 => "000110100101010",
    49 => "000110010100000",
    50 => "000110000011100",
    51 => "000101110011101",
    52 => "000101100100100",
    53 => "000101010101111",
    54 => "000101000111111",
    55 => "000100111010100",
    56 => "000100101101101",
    57 => "000100100001010",
    58 => "000100010101100",
    59 => "000100001010001",
    60 => "000011111111010",
    61 => "000011110100110",
    62 => "000011101010110",
    63 => "000011100001010",
    64 => "000011011000000",
    65 => "000011001111001",
    66 => "000011000110101",
    67 => "000010111110100",
    68 => "000010110110110",
    69 => "000010101111010",
    70 => "000010101000001",
    71 => "000010100001010",
    72 => "000010011010101",
    73 => "000010010100011",
    74 => "000010001110010",
    75 => "000010001000100",
    76 => "000010000010111",
    77 => "000001111101100",
    78 => "000001111000011",
    79 => "000001110011100",
    80 => "000001101110110",
    81 => "000001101010010",
    82 => "000001100101111",
    83 => "000001100001110",
    84 => "000001011101110",
    85 => "000001011001111",
    86 => "000001010110010",
    87 => "000001010010101",
    88 => "000001001111010",
    89 => "000001001100000",
    90 => "000001001001000",
    91 => "000001000110000",
    92 => "000001000011001",
    93 => "000001000000011",
    94 => "000000111101110",
    95 => "000000111011010",
    96 => "000000111000110",
    97 => "000000110110100",
    98 => "000000110100010",
    99 => "000000110010001",
    100 => "000000110000000",
    101 => "000000101110001",
    102 => "000000101100010",
    103 => "000000101010011",
    104 => "000000101000101",
    105 => "000000100111000",
    106 => "000000100101011",
    107 => "000000100011111",
    108 => "000000100010011",
    109 => "000000100001000",
    110 => "000000011111101",
    111 => "000000011110011",
    112 => "000000011101001",
    113 => "000000011011111",
    114 => "000000011010110",
    115 => "000000011001101",
    116 => "000000011000101",
    117 => "000000010111101",
    118 => "000000010110101",
    119 => "000000010101110",
    120 => "000000010100111",
    121 => "000000010100000",
    122 => "000000010011001",
    123 => "000000010010011",
    124 => "000000010001101",
    125 => "000000010000111",
    126 => "000000010000010",
    127 => "000000001111101");
begin
 process (LFO_freq_in)
 begin
  case LFO_freq_in is
     when "0000000" => rate <= LFO_freq_rom(0);
     when "0000001" => rate <= LFO_freq_rom(1);
     when "0000010" => rate <= LFO_freq_rom(2);
     when "0000011" => rate <= LFO_freq_rom(3);
     when "0000100" => rate <= LFO_freq_rom(4);
     when "0000101" => rate <= LFO_freq_rom(5);
     when "0000110" => rate <= LFO_freq_rom(6);
     when "0000111" => rate <= LFO_freq_rom(7);
     when "0001000" => rate <= LFO_freq_rom(8);
     when "0001001" => rate <= LFO_freq_rom(9);
     when "0001010" => rate <= LFO_freq_rom(10);
     when "0001011" => rate <= LFO_freq_rom(11);
     when "0001100" => rate <= LFO_freq_rom(12);
     when "0001101" => rate <= LFO_freq_rom(13);
     when "0001110" => rate <= LFO_freq_rom(14);
     when "0001111" => rate <= LFO_freq_rom(15);
     when "0010000" => rate <= LFO_freq_rom(16);
     when "0010001" => rate <= LFO_freq_rom(17);
     when "0010010" => rate <= LFO_freq_rom(18);
     when "0010011" => rate <= LFO_freq_rom(19);
     when "0010100" => rate <= LFO_freq_rom(20);
     when "0010101" => rate <= LFO_freq_rom(21);
     when "0010110" => rate <= LFO_freq_rom(22);
     when "0010111" => rate <= LFO_freq_rom(23);
     when "0011000" => rate <= LFO_freq_rom(24);
     when "0011001" => rate <= LFO_freq_rom(25);
     when "0011010" => rate <= LFO_freq_rom(26);
     when "0011011" => rate <= LFO_freq_rom(27);
     when "0011100" => rate <= LFO_freq_rom(28);
     when "0011101" => rate <= LFO_freq_rom(29);
     when "0011110" => rate <= LFO_freq_rom(30);
     when "0011111" => rate <= LFO_freq_rom(31);
     when "0100000" => rate <= LFO_freq_rom(32);
     when "0100001" => rate <= LFO_freq_rom(33);
     when "0100010" => rate <= LFO_freq_rom(34);
     when "0100011" => rate <= LFO_freq_rom(35);
     when "0100100" => rate <= LFO_freq_rom(36);
     when "0100101" => rate <= LFO_freq_rom(37);
     when "0100110" => rate <= LFO_freq_rom(38);
     when "0100111" => rate <= LFO_freq_rom(39);
     when "0101000" => rate <= LFO_freq_rom(40);
     when "0101001" => rate <= LFO_freq_rom(41);
     when "0101010" => rate <= LFO_freq_rom(42);
     when "0101011" => rate <= LFO_freq_rom(43);
     when "0101100" => rate <= LFO_freq_rom(44);
     when "0101101" => rate <= LFO_freq_rom(45);
     when "0101110" => rate <= LFO_freq_rom(46);
     when "0101111" => rate <= LFO_freq_rom(47);
     when "0110000" => rate <= LFO_freq_rom(48);
     when "0110001" => rate <= LFO_freq_rom(49);
     when "0110010" => rate <= LFO_freq_rom(50);
     when "0110011" => rate <= LFO_freq_rom(51);
     when "0110100" => rate <= LFO_freq_rom(52);
     when "0110101" => rate <= LFO_freq_rom(53);
     when "0110110" => rate <= LFO_freq_rom(54);
     when "0110111" => rate <= LFO_freq_rom(55);
     when "0111000" => rate <= LFO_freq_rom(56);
     when "0111001" => rate <= LFO_freq_rom(57);
     when "0111010" => rate <= LFO_freq_rom(58);
     when "0111011" => rate <= LFO_freq_rom(59);
     when "0111100" => rate <= LFO_freq_rom(60);
     when "0111101" => rate <= LFO_freq_rom(61);
     when "0111110" => rate <= LFO_freq_rom(62);
     when "0111111" => rate <= LFO_freq_rom(63);
     when "1000000" => rate <= LFO_freq_rom(64);
     when "1000001" => rate <= LFO_freq_rom(65);
     when "1000010" => rate <= LFO_freq_rom(66);
     when "1000011" => rate <= LFO_freq_rom(67);
     when "1000100" => rate <= LFO_freq_rom(68);
     when "1000101" => rate <= LFO_freq_rom(69);
     when "1000110" => rate <= LFO_freq_rom(70);
     when "1000111" => rate <= LFO_freq_rom(71);
     when "1001000" => rate <= LFO_freq_rom(72);
     when "1001001" => rate <= LFO_freq_rom(73);
     when "1001010" => rate <= LFO_freq_rom(74);
     when "1001011" => rate <= LFO_freq_rom(75);
     when "1001100" => rate <= LFO_freq_rom(76);
     when "1001101" => rate <= LFO_freq_rom(77);
     when "1001110" => rate <= LFO_freq_rom(78);
     when "1001111" => rate <= LFO_freq_rom(79);
     when "1010000" => rate <= LFO_freq_rom(80);
     when "1010001" => rate <= LFO_freq_rom(81);
     when "1010010" => rate <= LFO_freq_rom(82);
     when "1010011" => rate <= LFO_freq_rom(83);
     when "1010100" => rate <= LFO_freq_rom(84);
     when "1010101" => rate <= LFO_freq_rom(85);
     when "1010110" => rate <= LFO_freq_rom(86);
     when "1010111" => rate <= LFO_freq_rom(87);
     when "1011000" => rate <= LFO_freq_rom(88);
     when "1011001" => rate <= LFO_freq_rom(89);
     when "1011010" => rate <= LFO_freq_rom(90);
     when "1011011" => rate <= LFO_freq_rom(91);
     when "1011100" => rate <= LFO_freq_rom(92);
     when "1011101" => rate <= LFO_freq_rom(93);
     when "1011110" => rate <= LFO_freq_rom(94);
     when "1011111" => rate <= LFO_freq_rom(95);
     when "1100000" => rate <= LFO_freq_rom(96);
     when "1100001" => rate <= LFO_freq_rom(97);
     when "1100010" => rate <= LFO_freq_rom(98);
     when "1100011" => rate <= LFO_freq_rom(99);
     when "1100100" => rate <= LFO_freq_rom(100);
     when "1100101" => rate <= LFO_freq_rom(101);
     when "1100110" => rate <= LFO_freq_rom(102);
     when "1100111" => rate <= LFO_freq_rom(103);
     when "1101000" => rate <= LFO_freq_rom(104);
     when "1101001" => rate <= LFO_freq_rom(105);
     when "1101010" => rate <= LFO_freq_rom(106);
     when "1101011" => rate <= LFO_freq_rom(107);
     when "1101100" => rate <= LFO_freq_rom(108);
     when "1101101" => rate <= LFO_freq_rom(109);
     when "1101110" => rate <= LFO_freq_rom(110);
     when "1101111" => rate <= LFO_freq_rom(111);
     when "1110000" => rate <= LFO_freq_rom(112);
     when "1110001" => rate <= LFO_freq_rom(113);
     when "1110010" => rate <= LFO_freq_rom(114);
     when "1110011" => rate <= LFO_freq_rom(115);
     when "1110100" => rate <= LFO_freq_rom(116);
     when "1110101" => rate <= LFO_freq_rom(117);
     when "1110110" => rate <= LFO_freq_rom(118);
     when "1110111" => rate <= LFO_freq_rom(119);
     when "1111000" => rate <= LFO_freq_rom(120);
     when "1111001" => rate <= LFO_freq_rom(121);
     when "1111010" => rate <= LFO_freq_rom(122);
     when "1111011" => rate <= LFO_freq_rom(123);
     when "1111100" => rate <= LFO_freq_rom(124);
     when "1111101" => rate <= LFO_freq_rom(125);
     when "1111110" => rate <= LFO_freq_rom(126);
     when "1111111" => rate <= LFO_freq_rom(127);
     when others => rate <= "000000000000000";
    end case;
 end process;
end arch_LFO_freq;
