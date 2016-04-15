library ieee;
use ieee.std_logic_1164.all;
entity LFO_freq is
 port (LFO_freq_in : in std_logic_vector(7 downto 0);
    rate : out std_logic_vector(12 downto 0));
 end entity LFO_freq;
 architecture arch_LFO_freq of LFO_freq is
    type mem is array ( 0 to 2**8 - 1) of std_logic_vector(12 downto 0);
    constant LFO_freq_rom : mem := (
    0 => "1100100101000",
    1 => "1100010101000",
    2 => "1100000101011",
    3 => "1011110110001",
    4 => "1011100111001",
    5 => "1011011000011",
    6 => "1011001010000",
    7 => "1010111011111",
    8 => "1010101110000",
    9 => "1010100000011",
    10 => "1010010011001",
    11 => "1010000110000",
    12 => "1001111001010",
    13 => "1001101100110",
    14 => "1001100000011",
    15 => "1001010100011",
    16 => "1001001000100",
    17 => "1000111101000",
    18 => "1000110001101",
    19 => "1000100110100",
    20 => "1000011011101",
    21 => "1000010000111",
    22 => "1000000110100",
    23 => "0111111100001",
    24 => "0111110010001",
    25 => "0111101000010",
    26 => "0111011110101",
    27 => "0111010101001",
    28 => "0111001011111",
    29 => "0111000010110",
    30 => "0110111001110",
    31 => "0110110001000",
    32 => "0110101000100",
    33 => "0110100000001",
    34 => "0110010111111",
    35 => "0110001111110",
    36 => "0110000111111",
    37 => "0110000000001",
    38 => "0101111000100",
    39 => "0101110001000",
    40 => "0101101001110",
    41 => "0101100010100",
    42 => "0101011011100",
    43 => "0101010100101",
    44 => "0101001101111",
    45 => "0101000111010",
    46 => "0101000000110",
    47 => "0100111010100",
    48 => "0100110100010",
    49 => "0100101110001",
    50 => "0100101000001",
    51 => "0100100010010",
    52 => "0100011100100",
    53 => "0100010110111",
    54 => "0100010001011",
    55 => "0100001100000",
    56 => "0100000110101",
    57 => "0100000001100",
    58 => "0011111100011",
    59 => "0011110111011",
    60 => "0011110010100",
    61 => "0011101101101",
    62 => "0011101001000",
    63 => "0011100100011",
    64 => "0011011111111",
    65 => "0011011011011",
    66 => "0011010111000",
    67 => "0011010010110",
    68 => "0011001110101",
    69 => "0011001010100",
    70 => "0011000110100",
    71 => "0011000010101",
    72 => "0010111110110",
    73 => "0010111011000",
    74 => "0010110111010",
    75 => "0010110011101",
    76 => "0010110000001",
    77 => "0010101100101",
    78 => "0010101001001",
    79 => "0010100101110",
    80 => "0010100010100",
    81 => "0010011111010",
    82 => "0010011100001",
    83 => "0010011001000",
    84 => "0010010110000",
    85 => "0010010011000",
    86 => "0010010000001",
    87 => "0010001101010",
    88 => "0010001010100",
    89 => "0010000111110",
    90 => "0010000101001",
    91 => "0010000010011",
    92 => "0001111111111",
    93 => "0001111101011",
    94 => "0001111010111",
    95 => "0001111000011",
    96 => "0001110110000",
    97 => "0001110011101",
    98 => "0001110001011",
    99 => "0001101111001",
    100 => "0001101101000",
    101 => "0001101010110",
    102 => "0001101000101",
    103 => "0001100110101",
    104 => "0001100100101",
    105 => "0001100010101",
    106 => "0001100000101",
    107 => "0001011110110",
    108 => "0001011100111",
    109 => "0001011011000",
    110 => "0001011001010",
    111 => "0001010111011",
    112 => "0001010101110",
    113 => "0001010100000",
    114 => "0001010010011",
    115 => "0001010000110",
    116 => "0001001111001",
    117 => "0001001101100",
    118 => "0001001100000",
    119 => "0001001010100",
    120 => "0001001001000",
    121 => "0001000111101",
    122 => "0001000110001",
    123 => "0001000100110",
    124 => "0001000011011",
    125 => "0001000010001",
    126 => "0001000000110",
    127 => "0000111111100",
    128 => "0000111110010",
    129 => "0000111101000",
    130 => "0000111011110",
    131 => "0000111010101",
    132 => "0000111001100",
    133 => "0000111000010",
    134 => "0000110111010",
    135 => "0000110110001",
    136 => "0000110101000",
    137 => "0000110100000",
    138 => "0000110011000",
    139 => "0000110010000",
    140 => "0000110001000",
    141 => "0000110000000",
    142 => "0000101111000",
    143 => "0000101110001",
    144 => "0000101101010",
    145 => "0000101100010",
    146 => "0000101011011",
    147 => "0000101010100",
    148 => "0000101001110",
    149 => "0000101000111",
    150 => "0000101000001",
    151 => "0000100111010",
    152 => "0000100110100",
    153 => "0000100101110",
    154 => "0000100101000",
    155 => "0000100100010",
    156 => "0000100011100",
    157 => "0000100010111",
    158 => "0000100010001",
    159 => "0000100001100",
    160 => "0000100000111",
    161 => "0000100000001",
    162 => "0000011111100",
    163 => "0000011110111",
    164 => "0000011110010",
    165 => "0000011101110",
    166 => "0000011101001",
    167 => "0000011100100",
    168 => "0000011100000",
    169 => "0000011011011",
    170 => "0000011010111",
    171 => "0000011010011",
    172 => "0000011001110",
    173 => "0000011001010",
    174 => "0000011000110",
    175 => "0000011000010",
    176 => "0000010111111",
    177 => "0000010111011",
    178 => "0000010110111",
    179 => "0000010110100",
    180 => "0000010110000",
    181 => "0000010101100",
    182 => "0000010101001",
    183 => "0000010100110",
    184 => "0000010100010",
    185 => "0000010011111",
    186 => "0000010011100",
    187 => "0000010011001",
    188 => "0000010010110",
    189 => "0000010010011",
    190 => "0000010010000",
    191 => "0000010001101",
    192 => "0000010001010",
    193 => "0000010001000",
    194 => "0000010000101",
    195 => "0000010000010",
    196 => "0000010000000",
    197 => "0000001111101",
    198 => "0000001111011",
    199 => "0000001111000",
    200 => "0000001110110",
    201 => "0000001110100",
    202 => "0000001110001",
    203 => "0000001101111",
    204 => "0000001101101",
    205 => "0000001101011",
    206 => "0000001101001",
    207 => "0000001100111",
    208 => "0000001100101",
    209 => "0000001100011",
    210 => "0000001100001",
    211 => "0000001011111",
    212 => "0000001011101",
    213 => "0000001011011",
    214 => "0000001011001",
    215 => "0000001010111",
    216 => "0000001010110",
    217 => "0000001010100",
    218 => "0000001010010",
    219 => "0000001010001",
    220 => "0000001001111",
    221 => "0000001001110",
    222 => "0000001001100",
    223 => "0000001001010",
    224 => "0000001001001",
    225 => "0000001001000",
    226 => "0000001000110",
    227 => "0000001000101",
    228 => "0000001000011",
    229 => "0000001000010",
    230 => "0000001000001",
    231 => "0000000111111",
    232 => "0000000111110",
    233 => "0000000111101",
    234 => "0000000111100",
    235 => "0000000111011",
    236 => "0000000111001",
    237 => "0000000111000",
    238 => "0000000110111",
    239 => "0000000110110",
    240 => "0000000110101",
    241 => "0000000110100",
    242 => "0000000110011",
    243 => "0000000110010",
    244 => "0000000110001",
    245 => "0000000110000",
    246 => "0000000101111",
    247 => "0000000101110",
    248 => "0000000101101",
    249 => "0000000101100",
    250 => "0000000101011",
    251 => "0000000101011",
    252 => "0000000101010",
    253 => "0000000101001",
    254 => "0000000101000",
    255 => "0000000100111");
begin
 process (LFO_freq_in)
 begin
  case LFO_freq_in is
     when "00000000" => rate <= LFO_freq_rom(0);
     when "00000001" => rate <= LFO_freq_rom(1);
     when "00000010" => rate <= LFO_freq_rom(2);
     when "00000011" => rate <= LFO_freq_rom(3);
     when "00000100" => rate <= LFO_freq_rom(4);
     when "00000101" => rate <= LFO_freq_rom(5);
     when "00000110" => rate <= LFO_freq_rom(6);
     when "00000111" => rate <= LFO_freq_rom(7);
     when "00001000" => rate <= LFO_freq_rom(8);
     when "00001001" => rate <= LFO_freq_rom(9);
     when "00001010" => rate <= LFO_freq_rom(10);
     when "00001011" => rate <= LFO_freq_rom(11);
     when "00001100" => rate <= LFO_freq_rom(12);
     when "00001101" => rate <= LFO_freq_rom(13);
     when "00001110" => rate <= LFO_freq_rom(14);
     when "00001111" => rate <= LFO_freq_rom(15);
     when "00010000" => rate <= LFO_freq_rom(16);
     when "00010001" => rate <= LFO_freq_rom(17);
     when "00010010" => rate <= LFO_freq_rom(18);
     when "00010011" => rate <= LFO_freq_rom(19);
     when "00010100" => rate <= LFO_freq_rom(20);
     when "00010101" => rate <= LFO_freq_rom(21);
     when "00010110" => rate <= LFO_freq_rom(22);
     when "00010111" => rate <= LFO_freq_rom(23);
     when "00011000" => rate <= LFO_freq_rom(24);
     when "00011001" => rate <= LFO_freq_rom(25);
     when "00011010" => rate <= LFO_freq_rom(26);
     when "00011011" => rate <= LFO_freq_rom(27);
     when "00011100" => rate <= LFO_freq_rom(28);
     when "00011101" => rate <= LFO_freq_rom(29);
     when "00011110" => rate <= LFO_freq_rom(30);
     when "00011111" => rate <= LFO_freq_rom(31);
     when "00100000" => rate <= LFO_freq_rom(32);
     when "00100001" => rate <= LFO_freq_rom(33);
     when "00100010" => rate <= LFO_freq_rom(34);
     when "00100011" => rate <= LFO_freq_rom(35);
     when "00100100" => rate <= LFO_freq_rom(36);
     when "00100101" => rate <= LFO_freq_rom(37);
     when "00100110" => rate <= LFO_freq_rom(38);
     when "00100111" => rate <= LFO_freq_rom(39);
     when "00101000" => rate <= LFO_freq_rom(40);
     when "00101001" => rate <= LFO_freq_rom(41);
     when "00101010" => rate <= LFO_freq_rom(42);
     when "00101011" => rate <= LFO_freq_rom(43);
     when "00101100" => rate <= LFO_freq_rom(44);
     when "00101101" => rate <= LFO_freq_rom(45);
     when "00101110" => rate <= LFO_freq_rom(46);
     when "00101111" => rate <= LFO_freq_rom(47);
     when "00110000" => rate <= LFO_freq_rom(48);
     when "00110001" => rate <= LFO_freq_rom(49);
     when "00110010" => rate <= LFO_freq_rom(50);
     when "00110011" => rate <= LFO_freq_rom(51);
     when "00110100" => rate <= LFO_freq_rom(52);
     when "00110101" => rate <= LFO_freq_rom(53);
     when "00110110" => rate <= LFO_freq_rom(54);
     when "00110111" => rate <= LFO_freq_rom(55);
     when "00111000" => rate <= LFO_freq_rom(56);
     when "00111001" => rate <= LFO_freq_rom(57);
     when "00111010" => rate <= LFO_freq_rom(58);
     when "00111011" => rate <= LFO_freq_rom(59);
     when "00111100" => rate <= LFO_freq_rom(60);
     when "00111101" => rate <= LFO_freq_rom(61);
     when "00111110" => rate <= LFO_freq_rom(62);
     when "00111111" => rate <= LFO_freq_rom(63);
     when "01000000" => rate <= LFO_freq_rom(64);
     when "01000001" => rate <= LFO_freq_rom(65);
     when "01000010" => rate <= LFO_freq_rom(66);
     when "01000011" => rate <= LFO_freq_rom(67);
     when "01000100" => rate <= LFO_freq_rom(68);
     when "01000101" => rate <= LFO_freq_rom(69);
     when "01000110" => rate <= LFO_freq_rom(70);
     when "01000111" => rate <= LFO_freq_rom(71);
     when "01001000" => rate <= LFO_freq_rom(72);
     when "01001001" => rate <= LFO_freq_rom(73);
     when "01001010" => rate <= LFO_freq_rom(74);
     when "01001011" => rate <= LFO_freq_rom(75);
     when "01001100" => rate <= LFO_freq_rom(76);
     when "01001101" => rate <= LFO_freq_rom(77);
     when "01001110" => rate <= LFO_freq_rom(78);
     when "01001111" => rate <= LFO_freq_rom(79);
     when "01010000" => rate <= LFO_freq_rom(80);
     when "01010001" => rate <= LFO_freq_rom(81);
     when "01010010" => rate <= LFO_freq_rom(82);
     when "01010011" => rate <= LFO_freq_rom(83);
     when "01010100" => rate <= LFO_freq_rom(84);
     when "01010101" => rate <= LFO_freq_rom(85);
     when "01010110" => rate <= LFO_freq_rom(86);
     when "01010111" => rate <= LFO_freq_rom(87);
     when "01011000" => rate <= LFO_freq_rom(88);
     when "01011001" => rate <= LFO_freq_rom(89);
     when "01011010" => rate <= LFO_freq_rom(90);
     when "01011011" => rate <= LFO_freq_rom(91);
     when "01011100" => rate <= LFO_freq_rom(92);
     when "01011101" => rate <= LFO_freq_rom(93);
     when "01011110" => rate <= LFO_freq_rom(94);
     when "01011111" => rate <= LFO_freq_rom(95);
     when "01100000" => rate <= LFO_freq_rom(96);
     when "01100001" => rate <= LFO_freq_rom(97);
     when "01100010" => rate <= LFO_freq_rom(98);
     when "01100011" => rate <= LFO_freq_rom(99);
     when "01100100" => rate <= LFO_freq_rom(100);
     when "01100101" => rate <= LFO_freq_rom(101);
     when "01100110" => rate <= LFO_freq_rom(102);
     when "01100111" => rate <= LFO_freq_rom(103);
     when "01101000" => rate <= LFO_freq_rom(104);
     when "01101001" => rate <= LFO_freq_rom(105);
     when "01101010" => rate <= LFO_freq_rom(106);
     when "01101011" => rate <= LFO_freq_rom(107);
     when "01101100" => rate <= LFO_freq_rom(108);
     when "01101101" => rate <= LFO_freq_rom(109);
     when "01101110" => rate <= LFO_freq_rom(110);
     when "01101111" => rate <= LFO_freq_rom(111);
     when "01110000" => rate <= LFO_freq_rom(112);
     when "01110001" => rate <= LFO_freq_rom(113);
     when "01110010" => rate <= LFO_freq_rom(114);
     when "01110011" => rate <= LFO_freq_rom(115);
     when "01110100" => rate <= LFO_freq_rom(116);
     when "01110101" => rate <= LFO_freq_rom(117);
     when "01110110" => rate <= LFO_freq_rom(118);
     when "01110111" => rate <= LFO_freq_rom(119);
     when "01111000" => rate <= LFO_freq_rom(120);
     when "01111001" => rate <= LFO_freq_rom(121);
     when "01111010" => rate <= LFO_freq_rom(122);
     when "01111011" => rate <= LFO_freq_rom(123);
     when "01111100" => rate <= LFO_freq_rom(124);
     when "01111101" => rate <= LFO_freq_rom(125);
     when "01111110" => rate <= LFO_freq_rom(126);
     when "01111111" => rate <= LFO_freq_rom(127);
     when "10000000" => rate <= LFO_freq_rom(128);
     when "10000001" => rate <= LFO_freq_rom(129);
     when "10000010" => rate <= LFO_freq_rom(130);
     when "10000011" => rate <= LFO_freq_rom(131);
     when "10000100" => rate <= LFO_freq_rom(132);
     when "10000101" => rate <= LFO_freq_rom(133);
     when "10000110" => rate <= LFO_freq_rom(134);
     when "10000111" => rate <= LFO_freq_rom(135);
     when "10001000" => rate <= LFO_freq_rom(136);
     when "10001001" => rate <= LFO_freq_rom(137);
     when "10001010" => rate <= LFO_freq_rom(138);
     when "10001011" => rate <= LFO_freq_rom(139);
     when "10001100" => rate <= LFO_freq_rom(140);
     when "10001101" => rate <= LFO_freq_rom(141);
     when "10001110" => rate <= LFO_freq_rom(142);
     when "10001111" => rate <= LFO_freq_rom(143);
     when "10010000" => rate <= LFO_freq_rom(144);
     when "10010001" => rate <= LFO_freq_rom(145);
     when "10010010" => rate <= LFO_freq_rom(146);
     when "10010011" => rate <= LFO_freq_rom(147);
     when "10010100" => rate <= LFO_freq_rom(148);
     when "10010101" => rate <= LFO_freq_rom(149);
     when "10010110" => rate <= LFO_freq_rom(150);
     when "10010111" => rate <= LFO_freq_rom(151);
     when "10011000" => rate <= LFO_freq_rom(152);
     when "10011001" => rate <= LFO_freq_rom(153);
     when "10011010" => rate <= LFO_freq_rom(154);
     when "10011011" => rate <= LFO_freq_rom(155);
     when "10011100" => rate <= LFO_freq_rom(156);
     when "10011101" => rate <= LFO_freq_rom(157);
     when "10011110" => rate <= LFO_freq_rom(158);
     when "10011111" => rate <= LFO_freq_rom(159);
     when "10100000" => rate <= LFO_freq_rom(160);
     when "10100001" => rate <= LFO_freq_rom(161);
     when "10100010" => rate <= LFO_freq_rom(162);
     when "10100011" => rate <= LFO_freq_rom(163);
     when "10100100" => rate <= LFO_freq_rom(164);
     when "10100101" => rate <= LFO_freq_rom(165);
     when "10100110" => rate <= LFO_freq_rom(166);
     when "10100111" => rate <= LFO_freq_rom(167);
     when "10101000" => rate <= LFO_freq_rom(168);
     when "10101001" => rate <= LFO_freq_rom(169);
     when "10101010" => rate <= LFO_freq_rom(170);
     when "10101011" => rate <= LFO_freq_rom(171);
     when "10101100" => rate <= LFO_freq_rom(172);
     when "10101101" => rate <= LFO_freq_rom(173);
     when "10101110" => rate <= LFO_freq_rom(174);
     when "10101111" => rate <= LFO_freq_rom(175);
     when "10110000" => rate <= LFO_freq_rom(176);
     when "10110001" => rate <= LFO_freq_rom(177);
     when "10110010" => rate <= LFO_freq_rom(178);
     when "10110011" => rate <= LFO_freq_rom(179);
     when "10110100" => rate <= LFO_freq_rom(180);
     when "10110101" => rate <= LFO_freq_rom(181);
     when "10110110" => rate <= LFO_freq_rom(182);
     when "10110111" => rate <= LFO_freq_rom(183);
     when "10111000" => rate <= LFO_freq_rom(184);
     when "10111001" => rate <= LFO_freq_rom(185);
     when "10111010" => rate <= LFO_freq_rom(186);
     when "10111011" => rate <= LFO_freq_rom(187);
     when "10111100" => rate <= LFO_freq_rom(188);
     when "10111101" => rate <= LFO_freq_rom(189);
     when "10111110" => rate <= LFO_freq_rom(190);
     when "10111111" => rate <= LFO_freq_rom(191);
     when "11000000" => rate <= LFO_freq_rom(192);
     when "11000001" => rate <= LFO_freq_rom(193);
     when "11000010" => rate <= LFO_freq_rom(194);
     when "11000011" => rate <= LFO_freq_rom(195);
     when "11000100" => rate <= LFO_freq_rom(196);
     when "11000101" => rate <= LFO_freq_rom(197);
     when "11000110" => rate <= LFO_freq_rom(198);
     when "11000111" => rate <= LFO_freq_rom(199);
     when "11001000" => rate <= LFO_freq_rom(200);
     when "11001001" => rate <= LFO_freq_rom(201);
     when "11001010" => rate <= LFO_freq_rom(202);
     when "11001011" => rate <= LFO_freq_rom(203);
     when "11001100" => rate <= LFO_freq_rom(204);
     when "11001101" => rate <= LFO_freq_rom(205);
     when "11001110" => rate <= LFO_freq_rom(206);
     when "11001111" => rate <= LFO_freq_rom(207);
     when "11010000" => rate <= LFO_freq_rom(208);
     when "11010001" => rate <= LFO_freq_rom(209);
     when "11010010" => rate <= LFO_freq_rom(210);
     when "11010011" => rate <= LFO_freq_rom(211);
     when "11010100" => rate <= LFO_freq_rom(212);
     when "11010101" => rate <= LFO_freq_rom(213);
     when "11010110" => rate <= LFO_freq_rom(214);
     when "11010111" => rate <= LFO_freq_rom(215);
     when "11011000" => rate <= LFO_freq_rom(216);
     when "11011001" => rate <= LFO_freq_rom(217);
     when "11011010" => rate <= LFO_freq_rom(218);
     when "11011011" => rate <= LFO_freq_rom(219);
     when "11011100" => rate <= LFO_freq_rom(220);
     when "11011101" => rate <= LFO_freq_rom(221);
     when "11011110" => rate <= LFO_freq_rom(222);
     when "11011111" => rate <= LFO_freq_rom(223);
     when "11100000" => rate <= LFO_freq_rom(224);
     when "11100001" => rate <= LFO_freq_rom(225);
     when "11100010" => rate <= LFO_freq_rom(226);
     when "11100011" => rate <= LFO_freq_rom(227);
     when "11100100" => rate <= LFO_freq_rom(228);
     when "11100101" => rate <= LFO_freq_rom(229);
     when "11100110" => rate <= LFO_freq_rom(230);
     when "11100111" => rate <= LFO_freq_rom(231);
     when "11101000" => rate <= LFO_freq_rom(232);
     when "11101001" => rate <= LFO_freq_rom(233);
     when "11101010" => rate <= LFO_freq_rom(234);
     when "11101011" => rate <= LFO_freq_rom(235);
     when "11101100" => rate <= LFO_freq_rom(236);
     when "11101101" => rate <= LFO_freq_rom(237);
     when "11101110" => rate <= LFO_freq_rom(238);
     when "11101111" => rate <= LFO_freq_rom(239);
     when "11110000" => rate <= LFO_freq_rom(240);
     when "11110001" => rate <= LFO_freq_rom(241);
     when "11110010" => rate <= LFO_freq_rom(242);
     when "11110011" => rate <= LFO_freq_rom(243);
     when "11110100" => rate <= LFO_freq_rom(244);
     when "11110101" => rate <= LFO_freq_rom(245);
     when "11110110" => rate <= LFO_freq_rom(246);
     when "11110111" => rate <= LFO_freq_rom(247);
     when "11111000" => rate <= LFO_freq_rom(248);
     when "11111001" => rate <= LFO_freq_rom(249);
     when "11111010" => rate <= LFO_freq_rom(250);
     when "11111011" => rate <= LFO_freq_rom(251);
     when "11111100" => rate <= LFO_freq_rom(252);
     when "11111101" => rate <= LFO_freq_rom(253);
     when "11111110" => rate <= LFO_freq_rom(254);
     when "11111111" => rate <= LFO_freq_rom(255);
     when others => rate <= "0000000000000";
    end case;
 end process;
end arch_LFO_freq;
