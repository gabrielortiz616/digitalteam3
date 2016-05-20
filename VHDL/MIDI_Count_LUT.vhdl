-------------------------------------------------------
--! @file
--! @brief Translate MIDI Note to number of clock cycle counts in the square wave counter
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--! Receive the MIDI Note number and returns the counter size for the square counter
entity MIDI_Count_LUT is
 port ( address : in std_logic_vector(7 downto 0); --! MIDI Note
    data : out std_logic_vector(11 downto 0)); --! Counter size of the square wave counter
 end entity MIDI_Count_LUT;
 
 --! Translate MIDI Note to number of clock cycle counts in the square wave counter
 architecture arch_MIDI_Count_LUT of MIDI_Count_LUT is
    type mem is array ( 0 to 82) of std_logic_vector(11 downto 0);
    constant MIDI_rom : mem := (
    0 => "010110101111", -- 1455 
    1 => "010101011101", -- 1373 
    2 => "010100010000", -- 1296 
    3 => "010011000111", -- 1223 
    4 => "010010000010", -- 1154 
    5 => "010001000010", -- 1090 
    6 => "010000000101", -- 1029 
    7 => "001111001011", -- 971 
    8 => "001110010100", -- 916 
    9 => "001101100001", -- 865 
    10 => "001100110000", -- 816 
    11 => "001100000011", -- 771 
    12 => "001011010111", -- 727 
    13 => "001010101110", -- 686 
    14 => "001010001000", -- 648 
    15 => "001001100100", -- 612 
    16 => "001001000001", -- 577 
    17 => "001000100001", -- 545 
    18 => "001000000010", -- 514 
    19 => "000111100101", -- 485 
    20 => "000111001010", -- 458 
    21 => "000110110000", -- 432 
    22 => "000110011000", -- 408 
    23 => "000110000001", -- 385 
    24 => "000101101100", -- 364 
    25 => "000101010111", -- 343 
    26 => "000101000100", -- 324 
    27 => "000100110010", -- 306 
    28 => "000100100001", -- 289 
    29 => "000100010000", -- 272 
    30 => "000100000001", -- 257 
    31 => "000011110011", -- 243 
    32 => "000011100101", -- 229 
    33 => "000011011000", -- 216 
    34 => "000011001100", -- 204 
    35 => "000011000001", -- 193 
    36 => "000010110110", -- 182 
    37 => "000010101100", -- 172 
    38 => "000010100010", -- 162 
    39 => "000010011001", -- 153 
    40 => "000010010000", -- 144 
    41 => "000010001000", -- 136 
    42 => "000010000001", -- 129 
    43 => "000001111001", -- 121 
    44 => "000001110011", -- 115 
    45 => "000001101100", -- 108 
    46 => "000001100110", -- 102 
    47 => "000001100000", -- 96 
    48 => "000001011011", -- 91 
    49 => "000001010110", -- 86 
    50 => "000001010001", -- 81 
    51 => "000001001100", -- 76 
    52 => "000001001000", -- 72 
    53 => "000001000100", -- 68 
    54 => "000001000000", -- 64 
    55 => "000000111101", -- 61 
    56 => "000000111001", -- 57 
    57 => "000000110110", -- 54 
    58 => "000000110011", -- 51 
    59 => "000000110000", -- 48 
    60 => "000000101101", -- 45 
    61 => "000000101011", -- 43 
    62 => "000000101000", -- 40 
    63 => "000000100110", -- 38 
    64 => "000000100100", -- 36 
    65 => "000000100010", -- 34 
    66 => "000000100000", -- 32 
    67 => "000000011110", -- 30 
    68 => "000000011101", -- 29 
    69 => "000000011011", -- 27 
    70 => "000000011010", -- 26 
    71 => "000000011000", -- 24 
    72 => "000000010111", -- 23 
    73 => "000000010101", -- 21 
    74 => "000000010100", -- 20 
    75 => "000000010011", -- 19 
    76 => "000000010010", -- 18 
    77 => "000000010001", -- 17 
    78 => "000000010000", -- 16 
    79 => "000000001111", -- 15 
    80 => "000000001110", -- 14 
    81 => "000000001110", -- 14 
    82 => "000000001101"); -- 13 
begin
 process (address)
 begin
  case address is
     when "00010101" => data <= MIDI_rom(0);  -- note 21
     when "00010110" => data <= MIDI_rom(1);  -- note 22
     when "00010111" => data <= MIDI_rom(2);  -- note 23
     when "00011000" => data <= MIDI_rom(3);  -- note 24
     when "00011001" => data <= MIDI_rom(4);  -- note 25
     when "00011010" => data <= MIDI_rom(5);  -- note 26
     when "00011011" => data <= MIDI_rom(6);  -- note 27
     when "00011100" => data <= MIDI_rom(7);  -- note 28
     when "00011101" => data <= MIDI_rom(8);  -- note 29
     when "00011110" => data <= MIDI_rom(9);  -- note 30
     when "00011111" => data <= MIDI_rom(10);  -- note 31
     when "00100000" => data <= MIDI_rom(11);  -- note 32
     when "00100001" => data <= MIDI_rom(12);  -- note 33
     when "00100010" => data <= MIDI_rom(13);  -- note 34
     when "00100011" => data <= MIDI_rom(14);  -- note 35
     when "00100100" => data <= MIDI_rom(15);  -- note 36
     when "00100101" => data <= MIDI_rom(16);  -- note 37
     when "00100110" => data <= MIDI_rom(17);  -- note 38
     when "00100111" => data <= MIDI_rom(18);  -- note 39
     when "00101000" => data <= MIDI_rom(19);  -- note 40
     when "00101001" => data <= MIDI_rom(20);  -- note 41
     when "00101010" => data <= MIDI_rom(21);  -- note 42
     when "00101011" => data <= MIDI_rom(22);  -- note 43
     when "00101100" => data <= MIDI_rom(23);  -- note 44
     when "00101101" => data <= MIDI_rom(24);  -- note 45
     when "00101110" => data <= MIDI_rom(25);  -- note 46
     when "00101111" => data <= MIDI_rom(26);  -- note 47
     when "00110000" => data <= MIDI_rom(27);  -- note 48
     when "00110001" => data <= MIDI_rom(28);  -- note 49
     when "00110010" => data <= MIDI_rom(29);  -- note 50
     when "00110011" => data <= MIDI_rom(30);  -- note 51
     when "00110100" => data <= MIDI_rom(31);  -- note 52
     when "00110101" => data <= MIDI_rom(32);  -- note 53
     when "00110110" => data <= MIDI_rom(33);  -- note 54
     when "00110111" => data <= MIDI_rom(34);  -- note 55
     when "00111000" => data <= MIDI_rom(35);  -- note 56
     when "00111001" => data <= MIDI_rom(36);  -- note 57
     when "00111010" => data <= MIDI_rom(37);  -- note 58
     when "00111011" => data <= MIDI_rom(38);  -- note 59
     when "00111100" => data <= MIDI_rom(39);  -- note 60
     when "00111101" => data <= MIDI_rom(40);  -- note 61
     when "00111110" => data <= MIDI_rom(41);  -- note 62
     when "00111111" => data <= MIDI_rom(42);  -- note 63
     when "01000000" => data <= MIDI_rom(43);  -- note 64
     when "01000001" => data <= MIDI_rom(44);  -- note 65
     when "01000010" => data <= MIDI_rom(45);  -- note 66
     when "01000011" => data <= MIDI_rom(46);  -- note 67
     when "01000100" => data <= MIDI_rom(47);  -- note 68
     when "01000101" => data <= MIDI_rom(48);  -- note 69
     when "01000110" => data <= MIDI_rom(49);  -- note 70
     when "01000111" => data <= MIDI_rom(50);  -- note 71
     when "01001000" => data <= MIDI_rom(51);  -- note 72
     when "01001001" => data <= MIDI_rom(52);  -- note 73
     when "01001010" => data <= MIDI_rom(53);  -- note 74
     when "01001011" => data <= MIDI_rom(54);  -- note 75
     when "01001100" => data <= MIDI_rom(55);  -- note 76
     when "01001101" => data <= MIDI_rom(56);  -- note 77
     when "01001110" => data <= MIDI_rom(57);  -- note 78
     when "01001111" => data <= MIDI_rom(58);  -- note 79
     when "01010000" => data <= MIDI_rom(59);  -- note 80
     when "01010001" => data <= MIDI_rom(60);  -- note 81
     when "01010010" => data <= MIDI_rom(61);  -- note 82
     when "01010011" => data <= MIDI_rom(62);  -- note 83
     when "01010100" => data <= MIDI_rom(63);  -- note 84
     when "01010101" => data <= MIDI_rom(64);  -- note 85
     when "01010110" => data <= MIDI_rom(65);  -- note 86
     when "01010111" => data <= MIDI_rom(66);  -- note 87
     when "01011000" => data <= MIDI_rom(67);  -- note 88
     when "01011001" => data <= MIDI_rom(68);  -- note 89
     when "01011010" => data <= MIDI_rom(69);  -- note 90
     when "01011011" => data <= MIDI_rom(70);  -- note 91
     when "01011100" => data <= MIDI_rom(71);  -- note 92
     when "01011101" => data <= MIDI_rom(72);  -- note 93
     when "01011110" => data <= MIDI_rom(73);  -- note 94
     when "01011111" => data <= MIDI_rom(74);  -- note 95
     when "01100000" => data <= MIDI_rom(75);  -- note 96
     when "01100001" => data <= MIDI_rom(76);  -- note 97
     when "01100010" => data <= MIDI_rom(77);  -- note 98
     when "01100011" => data <= MIDI_rom(78);  -- note 99
     when "01100100" => data <= MIDI_rom(79);  -- note 100
     when "01100101" => data <= MIDI_rom(80);  -- note 101
     when "01100110" => data <= MIDI_rom(81);  -- note 102
     when "01100111" => data <= MIDI_rom(82);  -- note 103
     when others => data <= "000000000000";
    end case;
 end process;
end arch_MIDI_Count_LUT;
