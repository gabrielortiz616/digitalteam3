library ieee;
use ieee.std_logic_1164.all;
entity LFO_freq is
 port (LFO_freq_in : in std_logic_vector(6 downto 0);
    rate : out std_logic_vector(13 downto 0));
 end entity LFO_freq;
 architecture arch_LFO_freq of LFO_freq is
    type mem is array ( 0 to 2**7 - 1) of std_logic_vector(13 downto 0);
    constant LFO_freq_rom : mem := (
    0 => "10101101100111",
    1 => "10100110100001",
    2 => "10011111101101",
    3 => "10011001001011",
    4 => "10010010111010",
    5 => "10001100111010",
    6 => "10000111001001",
    7 => "10000001100111",
    8 => "01111100010100",
    9 => "01110111001111",
    10 => "01110010010111",
    11 => "01101101101011",
    12 => "01101001001100",
    13 => "01100100111001",
    14 => "01100000110001",
    15 => "01011100110100",
    16 => "01011001000001",
    17 => "01010101011000",
    18 => "01010001111001",
    19 => "01001110100010",
    20 => "01001011010101",
    21 => "01001000010000",
    22 => "01000101010011",
    23 => "01000010011101",
    24 => "00111111101111",
    25 => "00111101001001",
    26 => "00111010101001",
    27 => "00111000001111",
    28 => "00110101111100",
    29 => "00110011101111",
    30 => "00110001100111",
    31 => "00101111100110",
    32 => "00101101101001",
    33 => "00101011110010",
    34 => "00101001111111",
    35 => "00101000010001",
    36 => "00100110101000",
    37 => "00100101000011",
    38 => "00100011100010",
    39 => "00100010000101",
    40 => "00100000101100",
    41 => "00011111010110",
    42 => "00011110000100",
    43 => "00011100110101",
    44 => "00011011101010",
    45 => "00011010100010",
    46 => "00011001011100",
    47 => "00011000011010",
    48 => "00010111011010",
    49 => "00010110011100",
    50 => "00010101100010",
    51 => "00010100101001",
    52 => "00010011110011",
    53 => "00010011000000",
    54 => "00010010001110",
    55 => "00010001011110",
    56 => "00010000110000",
    57 => "00010000000101",
    58 => "00001111011011",
    59 => "00001110110010",
    60 => "00001110001011",
    61 => "00001101100110",
    62 => "00001101000011",
    63 => "00001100100001",
    64 => "00001100000000",
    65 => "00001011100001",
    66 => "00001011000010",
    67 => "00001010100110",
    68 => "00001010001010",
    69 => "00001001101111",
    70 => "00001001010110",
    71 => "00001000111101",
    72 => "00001000100110",
    73 => "00001000001111",
    74 => "00000111111010",
    75 => "00000111100101",
    76 => "00000111010001",
    77 => "00000110111110",
    78 => "00000110101100",
    79 => "00000110011011",
    80 => "00000110001010",
    81 => "00000101111010",
    82 => "00000101101010",
    83 => "00000101011011",
    84 => "00000101001101",
    85 => "00000101000000",
    86 => "00000100110010",
    87 => "00000100100110",
    88 => "00000100011010",
    89 => "00000100001110",
    90 => "00000100000011",
    91 => "00000011111001",
    92 => "00000011101111",
    93 => "00000011100101",
    94 => "00000011011011",
    95 => "00000011010010",
    96 => "00000011001010",
    97 => "00000011000010",
    98 => "00000010111010",
    99 => "00000010110010",
    100 => "00000010101011",
    101 => "00000010100100",
    102 => "00000010011101",
    103 => "00000010010111",
    104 => "00000010010001",
    105 => "00000010001011",
    106 => "00000010000101",
    107 => "00000010000000",
    108 => "00000001111010",
    109 => "00000001110101",
    110 => "00000001110001",
    111 => "00000001101100",
    112 => "00000001101000",
    113 => "00000001100011",
    114 => "00000001011111",
    115 => "00000001011011",
    116 => "00000001011000",
    117 => "00000001010100",
    118 => "00000001010001",
    119 => "00000001001101",
    120 => "00000001001010",
    121 => "00000001000111",
    122 => "00000001000100",
    123 => "00000001000001",
    124 => "00000000111111",
    125 => "00000000111100",
    126 => "00000000111010",
    127 => "00000000110111");
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
     when others => rate <= "00000000000000";
    end case;
 end process;
end arch_LFO_freq;

