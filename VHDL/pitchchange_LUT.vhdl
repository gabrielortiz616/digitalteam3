-------------------------------------------------------
--! @file
--! @brief Translates the pitch bend value change to a Multiplicator used to calculate the new phase increment in the NCO
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--! Receives the Pitch bend rotation value from MIDI interface, returns phase increment multiplicator
entity Pitch_LUT is
 port ( address : in std_logic_vector(7 downto 0); --! Pitch Bend Value
    data : out std_logic_vector(20 downto 0)); --! Multiplicator for calculating new phase increment
 end entity Pitch_LUT;
 
 --! Translates the pitch bend value change to a Multiplicator used to calculate the new phase increment in the NCO
 architecture arch_Pitch_LUT of Pitch_LUT is
    type mem is array ( 0 to 127) of std_logic_vector(20 downto 0);
    constant pitch_rom : mem := (
    0 => "000000000110101111110", -- 3454 
    1 => "000000000110110000111", -- 3463 
    2 => "000000000110110010000", -- 3472 
    3 => "000000000110110011010", -- 3482 
    4 => "000000000110110100011", -- 3491 
    5 => "000000000110110101101", -- 3501 
    6 => "000000000110110110110", -- 3510 
    7 => "000000000110111000000", -- 3520 
    8 => "000000000110111001001", -- 3529 
    9 => "000000000110111010011", -- 3539 
    10 => "000000000110111011100", -- 3548 
    11 => "000000000110111100110", -- 3558 
    12 => "000000000110111110000", -- 3568 
    13 => "000000000110111111001", -- 3577 
    14 => "000000000111000000011", -- 3587 
    15 => "000000000111000001101", -- 3597 
    16 => "000000000111000010111", -- 3607 
    17 => "000000000111000100000", -- 3616 
    18 => "000000000111000101010", -- 3626 
    19 => "000000000111000110100", -- 3636 
    20 => "000000000111000111110", -- 3646 
    21 => "000000000111001001000", -- 3656 
    22 => "000000000111001010010", -- 3666 
    23 => "000000000111001011100", -- 3676 
    24 => "000000000111001100110", -- 3686 
    25 => "000000000111001110000", -- 3696 
    26 => "000000000111001111010", -- 3706 
    27 => "000000000111010000100", -- 3716 
    28 => "000000000111010001110", -- 3726 
    29 => "000000000111010011000", -- 3736 
    30 => "000000000111010100010", -- 3746 
    31 => "000000000111010101100", -- 3756 
    32 => "000000000111010110110", -- 3766 
    33 => "000000000111011000000", -- 3776 
    34 => "000000000111011001011", -- 3787 
    35 => "000000000111011010101", -- 3797 
    36 => "000000000111011011111", -- 3807 
    37 => "000000000111011101010", -- 3818 
    38 => "000000000111011110100", -- 3828 
    39 => "000000000111011111110", -- 3838 
    40 => "000000000111100001001", -- 3849 
    41 => "000000000111100010011", -- 3859 
    42 => "000000000111100011110", -- 3870 
    43 => "000000000111100101000", -- 3880 
    44 => "000000000111100110011", -- 3891 
    45 => "000000000111100111101", -- 3901 
    46 => "000000000111101001000", -- 3912 
    47 => "000000000111101010010", -- 3922 
    48 => "000000000111101011101", -- 3933 
    49 => "000000000111101101000", -- 3944 
    50 => "000000000111101110010", -- 3954 
    51 => "000000000111101111101", -- 3965 
    52 => "000000000111110001000", -- 3976 
    53 => "000000000111110010011", -- 3987 
    54 => "000000000111110011101", -- 3997 
    55 => "000000000111110101000", -- 4008 
    56 => "000000000111110110011", -- 4019 
    57 => "000000000111110111110", -- 4030 
    58 => "000000000111111001001", -- 4041 
    59 => "000000000111111010100", -- 4052 
    60 => "000000000111111011111", -- 4063 
    61 => "000000000111111101010", -- 4074 
    62 => "000000000111111110101", -- 4085 
    63 => "000000001000000000000", -- 4096 
    64 => "000000001000000000000", -- 4096 
    65 => "000000001000000001011", -- 4107 
    66 => "000000001000000010110", -- 4118 
    67 => "000000001000000100001", -- 4129 
    68 => "000000001000000101101", -- 4141 
    69 => "000000001000000111000", -- 4152 
    70 => "000000001000001000011", -- 4163 
    71 => "000000001000001001110", -- 4174 
    72 => "000000001000001011010", -- 4186 
    73 => "000000001000001100101", -- 4197 
    74 => "000000001000001110000", -- 4208 
    75 => "000000001000001111100", -- 4220 
    76 => "000000001000010000111", -- 4231 
    77 => "000000001000010010011", -- 4243 
    78 => "000000001000010011110", -- 4254 
    79 => "000000001000010101010", -- 4266 
    80 => "000000001000010110101", -- 4277 
    81 => "000000001000011000001", -- 4289 
    82 => "000000001000011001101", -- 4301 
    83 => "000000001000011011000", -- 4312 
    84 => "000000001000011100100", -- 4324 
    85 => "000000001000011110000", -- 4336 
    86 => "000000001000011111011", -- 4347 
    87 => "000000001000100000111", -- 4359 
    88 => "000000001000100010011", -- 4371 
    89 => "000000001000100011111", -- 4383 
    90 => "000000001000100101011", -- 4395 
    91 => "000000001000100110111", -- 4407 
    92 => "000000001000101000011", -- 4419 
    93 => "000000001000101001111", -- 4431 
    94 => "000000001000101011011", -- 4443 
    95 => "000000001000101100111", -- 4455 
    96 => "000000001000101110011", -- 4467 
    97 => "000000001000101111111", -- 4479 
    98 => "000000001000110001011", -- 4491 
    99 => "000000001000110010111", -- 4503 
    100 => "000000001000110100011", -- 4515 
    101 => "000000001000110110000", -- 4528 
    102 => "000000001000110111100", -- 4540 
    103 => "000000001000111001000", -- 4552 
    104 => "000000001000111010101", -- 4565 
    105 => "000000001000111100001", -- 4577 
    106 => "000000001000111101101", -- 4589 
    107 => "000000001000111111010", -- 4602 
    108 => "000000001001000000110", -- 4614 
    109 => "000000001001000010011", -- 4627 
    110 => "000000001001000011111", -- 4639 
    111 => "000000001001000101100", -- 4652 
    112 => "000000001001000111000", -- 4664 
    113 => "000000001001001000101", -- 4677 
    114 => "000000001001001010010", -- 4690 
    115 => "000000001001001011111", -- 4703 
    116 => "000000001001001101011", -- 4715 
    117 => "000000001001001111000", -- 4728 
    118 => "000000001001010000101", -- 4741 
    119 => "000000001001010010010", -- 4754 
    120 => "000000001001010011111", -- 4767 
    121 => "000000001001010101100", -- 4780 
    122 => "000000001001010111000", -- 4792 
    123 => "000000001001011000101", -- 4805 
    124 => "000000001001011010011", -- 4819 
    125 => "000000001001011100000", -- 4832 
    126 => "000000001001011101101", -- 4845 
    127 => "000000001001011111010"); -- 4858 
begin
 process (address)
 begin
  case address is
     when "00000000" => data <= pitch_rom(0);  -- 0
     when "00000001" => data <= pitch_rom(1);  -- 1
     when "00000010" => data <= pitch_rom(2);  -- 2
     when "00000011" => data <= pitch_rom(3);  -- 3
     when "00000100" => data <= pitch_rom(4);  -- 4
     when "00000101" => data <= pitch_rom(5);  -- 5
     when "00000110" => data <= pitch_rom(6);  -- 6
     when "00000111" => data <= pitch_rom(7);  -- 7
     when "00001000" => data <= pitch_rom(8);  -- 8
     when "00001001" => data <= pitch_rom(9);  -- 9
     when "00001010" => data <= pitch_rom(10);  -- 10
     when "00001011" => data <= pitch_rom(11);  -- 11
     when "00001100" => data <= pitch_rom(12);  -- 12
     when "00001101" => data <= pitch_rom(13);  -- 13
     when "00001110" => data <= pitch_rom(14);  -- 14
     when "00001111" => data <= pitch_rom(15);  -- 15
     when "00010000" => data <= pitch_rom(16);  -- 16
     when "00010001" => data <= pitch_rom(17);  -- 17
     when "00010010" => data <= pitch_rom(18);  -- 18
     when "00010011" => data <= pitch_rom(19);  -- 19
     when "00010100" => data <= pitch_rom(20);  -- 20
     when "00010101" => data <= pitch_rom(21);  -- 21
     when "00010110" => data <= pitch_rom(22);  -- 22
     when "00010111" => data <= pitch_rom(23);  -- 23
     when "00011000" => data <= pitch_rom(24);  -- 24
     when "00011001" => data <= pitch_rom(25);  -- 25
     when "00011010" => data <= pitch_rom(26);  -- 26
     when "00011011" => data <= pitch_rom(27);  -- 27
     when "00011100" => data <= pitch_rom(28);  -- 28
     when "00011101" => data <= pitch_rom(29);  -- 29
     when "00011110" => data <= pitch_rom(30);  -- 30
     when "00011111" => data <= pitch_rom(31);  -- 31
     when "00100000" => data <= pitch_rom(32);  -- 32
     when "00100001" => data <= pitch_rom(33);  -- 33
     when "00100010" => data <= pitch_rom(34);  -- 34
     when "00100011" => data <= pitch_rom(35);  -- 35
     when "00100100" => data <= pitch_rom(36);  -- 36
     when "00100101" => data <= pitch_rom(37);  -- 37
     when "00100110" => data <= pitch_rom(38);  -- 38
     when "00100111" => data <= pitch_rom(39);  -- 39
     when "00101000" => data <= pitch_rom(40);  -- 40
     when "00101001" => data <= pitch_rom(41);  -- 41
     when "00101010" => data <= pitch_rom(42);  -- 42
     when "00101011" => data <= pitch_rom(43);  -- 43
     when "00101100" => data <= pitch_rom(44);  -- 44
     when "00101101" => data <= pitch_rom(45);  -- 45
     when "00101110" => data <= pitch_rom(46);  -- 46
     when "00101111" => data <= pitch_rom(47);  -- 47
     when "00110000" => data <= pitch_rom(48);  -- 48
     when "00110001" => data <= pitch_rom(49);  -- 49
     when "00110010" => data <= pitch_rom(50);  -- 50
     when "00110011" => data <= pitch_rom(51);  -- 51
     when "00110100" => data <= pitch_rom(52);  -- 52
     when "00110101" => data <= pitch_rom(53);  -- 53
     when "00110110" => data <= pitch_rom(54);  -- 54
     when "00110111" => data <= pitch_rom(55);  -- 55
     when "00111000" => data <= pitch_rom(56);  -- 56
     when "00111001" => data <= pitch_rom(57);  -- 57
     when "00111010" => data <= pitch_rom(58);  -- 58
     when "00111011" => data <= pitch_rom(59);  -- 59
     when "00111100" => data <= pitch_rom(60);  -- 60
     when "00111101" => data <= pitch_rom(61);  -- 61
     when "00111110" => data <= pitch_rom(62);  -- 62
     when "00111111" => data <= pitch_rom(63);  -- 63
     when "01000000" => data <= pitch_rom(64);  -- 64
     when "01000001" => data <= pitch_rom(65);  -- 65
     when "01000010" => data <= pitch_rom(66);  -- 66
     when "01000011" => data <= pitch_rom(67);  -- 67
     when "01000100" => data <= pitch_rom(68);  -- 68
     when "01000101" => data <= pitch_rom(69);  -- 69
     when "01000110" => data <= pitch_rom(70);  -- 70
     when "01000111" => data <= pitch_rom(71);  -- 71
     when "01001000" => data <= pitch_rom(72);  -- 72
     when "01001001" => data <= pitch_rom(73);  -- 73
     when "01001010" => data <= pitch_rom(74);  -- 74
     when "01001011" => data <= pitch_rom(75);  -- 75
     when "01001100" => data <= pitch_rom(76);  -- 76
     when "01001101" => data <= pitch_rom(77);  -- 77
     when "01001110" => data <= pitch_rom(78);  -- 78
     when "01001111" => data <= pitch_rom(79);  -- 79
     when "01010000" => data <= pitch_rom(80);  -- 80
     when "01010001" => data <= pitch_rom(81);  -- 81
     when "01010010" => data <= pitch_rom(82);  -- 82
     when "01010011" => data <= pitch_rom(83);  -- 83
     when "01010100" => data <= pitch_rom(84);  -- 84
     when "01010101" => data <= pitch_rom(85);  -- 85
     when "01010110" => data <= pitch_rom(86);  -- 86
     when "01010111" => data <= pitch_rom(87);  -- 87
     when "01011000" => data <= pitch_rom(88);  -- 88
     when "01011001" => data <= pitch_rom(89);  -- 89
     when "01011010" => data <= pitch_rom(90);  -- 90
     when "01011011" => data <= pitch_rom(91);  -- 91
     when "01011100" => data <= pitch_rom(92);  -- 92
     when "01011101" => data <= pitch_rom(93);  -- 93
     when "01011110" => data <= pitch_rom(94);  -- 94
     when "01011111" => data <= pitch_rom(95);  -- 95
     when "01100000" => data <= pitch_rom(96);  -- 96
     when "01100001" => data <= pitch_rom(97);  -- 97
     when "01100010" => data <= pitch_rom(98);  -- 98
     when "01100011" => data <= pitch_rom(99);  -- 99
     when "01100100" => data <= pitch_rom(100);  -- 100
     when "01100101" => data <= pitch_rom(101);  -- 101
     when "01100110" => data <= pitch_rom(102);  -- 102
     when "01100111" => data <= pitch_rom(103);  -- 103
     when "01101000" => data <= pitch_rom(104);  -- 104
     when "01101001" => data <= pitch_rom(105);  -- 105
     when "01101010" => data <= pitch_rom(106);  -- 106
     when "01101011" => data <= pitch_rom(107);  -- 107
     when "01101100" => data <= pitch_rom(108);  -- 108
     when "01101101" => data <= pitch_rom(109);  -- 109
     when "01101110" => data <= pitch_rom(110);  -- 110
     when "01101111" => data <= pitch_rom(111);  -- 111
     when "01110000" => data <= pitch_rom(112);  -- 112
     when "01110001" => data <= pitch_rom(113);  -- 113
     when "01110010" => data <= pitch_rom(114);  -- 114
     when "01110011" => data <= pitch_rom(115);  -- 115
     when "01110100" => data <= pitch_rom(116);  -- 116
     when "01110101" => data <= pitch_rom(117);  -- 117
     when "01110110" => data <= pitch_rom(118);  -- 118
     when "01110111" => data <= pitch_rom(119);  -- 119
     when "01111000" => data <= pitch_rom(120);  -- 120
     when "01111001" => data <= pitch_rom(121);  -- 121
     when "01111010" => data <= pitch_rom(122);  -- 122
     when "01111011" => data <= pitch_rom(123);  -- 123
     when "01111100" => data <= pitch_rom(124);  -- 124
     when "01111101" => data <= pitch_rom(125);  -- 125
     when "01111110" => data <= pitch_rom(126);  -- 126
     when "01111111" => data <= pitch_rom(127);  -- 127
     when others => data <= "000000000000000000000";
    end case;
 end process;
end arch_Pitch_LUT;
