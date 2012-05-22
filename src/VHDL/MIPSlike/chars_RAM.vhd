--------------------------------------------------------------------------------
----                                                                        ----
---- This file is part of the yaVGA project                                 ----
---- http://www.opencores.org/?do=project&who=yavga                         ----
----                                                                        ----
---- Description                                                            ----
---- Implementation of yaVGA IP core                                        ----
----                                                                        ----
---- To Do:                                                                 ----
----                                                                        ----
----                                                                        ----
---- Author(s):                                                             ----
---- Sandro Amato, sdroamt@netscape.net                                     ----
----                                                                        ----
--------------------------------------------------------------------------------
----                                                                        ----
---- Copyright (c) 2009, Sandro Amato                                       ----
---- All rights reserved.                                                   ----
----                                                                        ----
---- Redistribution  and  use in  source  and binary forms, with or without ----
---- modification,  are  permitted  provided that  the following conditions ----
---- are met:                                                               ----
----                                                                        ----
----     * Redistributions  of  source  code  must  retain the above        ----
----       copyright   notice,  this  list  of  conditions  and  the        ----
----       following disclaimer.                                            ----
----     * Redistributions  in  binary form must reproduce the above        ----
----       copyright   notice,  this  list  of  conditions  and  the        ----
----       following  disclaimer in  the documentation and/or  other        ----
----       materials provided with the distribution.                        ----
----     * Neither  the  name  of  SANDRO AMATO nor the names of its        ----
----       contributors may be used to  endorse or  promote products        ----
----       derived from this software without specific prior written        ----
----       permission.                                                      ----
----                                                                        ----
---- THIS SOFTWARE IS PROVIDED  BY THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS ----
---- "AS IS"  AND  ANY EXPRESS OR  IMPLIED  WARRANTIES, INCLUDING,  BUT NOT ----
---- LIMITED  TO, THE  IMPLIED  WARRANTIES  OF MERCHANTABILITY  AND FITNESS ----
---- FOR  A PARTICULAR  PURPOSE  ARE  DISCLAIMED. IN  NO  EVENT  SHALL  THE ----
---- COPYRIGHT  OWNER  OR CONTRIBUTORS  BE LIABLE FOR ANY DIRECT, INDIRECT, ----
---- INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, ----
---- BUT  NOT LIMITED  TO,  PROCUREMENT OF  SUBSTITUTE  GOODS  OR SERVICES; ----
---- LOSS  OF  USE,  DATA,  OR PROFITS;  OR  BUSINESS INTERRUPTION) HOWEVER ----
---- CAUSED  AND  ON  ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT, STRICT ----
---- LIABILITY,  OR  TORT  (INCLUDING  NEGLIGENCE  OR OTHERWISE) ARISING IN ----
---- ANY  WAY OUT  OF THE  USE  OF  THIS  SOFTWARE,  EVEN IF ADVISED OF THE ----
---- POSSIBILITY OF SUCH DAMAGE.                                            ----
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

use work.yavga_pkg.all;

-- Uncomment the following lines to use the declarations that are
-- provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity chars_RAM is
  port (
    i_clock_rw : in  std_logic;         -- Write Clock
    i_EN_rw    : in  std_logic;         -- Write RAM Enable Input
    i_WE_rw    : in  std_logic_vector(c_CHR_WE_BUS_W - 1 downto 0);  -- Write Enable Input
    i_ADDR_rw  : in  std_logic_vector(10 downto 0);  -- Write 11-bit Address Input
    i_DI_rw    : in  std_logic_vector(31 downto 0);  -- Write 32-bit Data Input
    o_DI_rw    : out std_logic_vector(31 downto 0);  -- Write 32-bit Data Input

    i_SSR : in std_logic;               -- Synchronous Set/Reset Input

    i_clock_r : in  std_logic;          -- Read Clock
    i_EN_r    : in  std_logic;
    i_ADDR_r  : in  std_logic_vector(12 downto 0);  -- Read 13-bit Address Input
    o_DO_r    : out std_logic_vector(7 downto 0)    -- Read 8-bit Data Output
    );
end chars_RAM;

architecture Behavioral of chars_RAM is
  signal s0_DO_r : std_logic_vector(7 downto 0);
  signal s1_DO_r : std_logic_vector(7 downto 0);
  signal s2_DO_r : std_logic_vector(7 downto 0);
  signal s3_DO_r : std_logic_vector(7 downto 0);

  constant c_ram_size : natural := 2**(c_CHR_ADDR_BUS_W);

  type t_ram is array (c_ram_size-1 downto 0) of
    std_logic_vector (c_INTCHR_DATA_BUS_W - 1 downto 0);

  shared variable v_ram0 : t_ram := (
    27 => X"05",  -- config "bg and curs color" (108/4 = 27)
11 => X"4E", 12 => X"4F", 13 => X"2E", 14 => X"30", 68 => X"38", 69 => X"2E", 72 => X"34", 73 => X"38", 76 => X"38", 83 => X"38", 84 => X"62", 100 => X"38", 101 => X"62", 107 => X"64", 108 => X"38", 109 => X"2E", 115 => X"38", 116 => X"38", 132 => X"59", 133 => X"38", 139 => X"38", 140 => X"50", 141 => X"38", 147 => X"22", 148 => X"59", 164 => X"7C", 165 => X"38", 171 => X"38", 172 => X"7C", 173 => X"38", 179 => X"6F", 180 => X"7C", 197 => X"38", 203 => X"38", 205 => X"38", 207 => X"64", 208 => X"68", 212 => X"2E", 228 => X"5F", 229 => X"59", 235 => X"38", 236 => X"2E", 237 => X"38", 243 => X"2E", 259 => X"64", 261 => X"60", 267 => X"2F", 269 => X"38", 277 => X"2E", 291 => X"50", 292 => X"2E", 294 => X"62", 301 => X"59", 306 => X"64", 309 => X"38", 323 => X"27", 324 => X"22", 325 => X"60", 326 => X"38", 331 => X"27", 333 => X"3A", 338 => X"3A", 341 => X"38", 354 => X"64", 358 => X"38", 362 => X"64", 365 => X"27", 366 => X"62", 373 => X"59", 386 => X"38", 390 => X"38", 394 => X"38", 398 => X"38", 401 => X"3A", 403 => X"27", 405 => X"3A", 418 => X"38", 422 => X"38", 426 => X"38", 429 => X"5F", 430 => X"50", 433 => X"38", 437 => X"38", 450 => X"2F", 451 => X"61", 453 => X"2E", 454 => X"38", 458 => X"2F", 459 => X"61", 462 => X"7C", 465 => X"2F", 466 => X"61", 468 => X"2E", 469 => X"38", 483 => X"50", 485 => X"60", 486 => X"50", 487 => X"2E", 491 => X"50", 498 => X"50", 500 => X"60", 501 => X"50", 502 => X"2E", 515 => X"5C", 516 => X"5F", 517 => X"64", 523 => X"5C", 524 => X"5F", 526 => X"2E", 530 => X"5C", 531 => X"5F", 532 => X"64", 546 => X"2D", 547 => X"5F", 548 => X"38", 549 => X"50", 550 => X"2E", 554 => X"2D", 555 => X"5F", 556 => X"38", 557 => X"2E", 561 => X"2D", 562 => X"5F", 563 => X"38", 564 => X"50", 565 => X"2E", 609 => X"41", 610 => X"65", 611 => X"28", 612 => X"74", 613 => X"61", 615 => X"29", 618 => X"69", 619 => X"28", 621 => X"6F", 622 => X"75", 626 => X"70", 627 => X"28", 628 => X"33", 629 => X"33", 1033 => X"2D", 1034 => X"2D", 1035 => X"2C", 1036 => X"5F", 1038 => X"75", 1039 => X"34", 1063 => X"5C", 1064 => X"27", 1067 => X"2E", 1068 => X"5F", 1093 => X"2C", 1095 => X"5F", 1097 => X"5C", 1098 => X"2D", 1102 => X"72", 1104 => X"72", 1105 => X"4C", 1106 => X"58", 1107 => X"79", 1108 => X"30", 1109 => X"32", 1126 => X"2E", 1127 => X"5F", 1128 => X"27", 1129 => X"28", 1134 => X"69", 1136 => X"65", 1137 => X"58", 1138 => X"48", 1140 => X"30", 1141 => X"30", 1158 => X"60", 1161 => X"5C", 1166 => X"70", 1168 => X"75", 1169 => X"6D", 1172 => X"30", 1173 => X"38", 1193 => X"27", 
    others => X"00"
    );

  shared variable v_ram1 : t_ram := (
    27 => X"07",  -- config "xy coords spans on three bytes" (108/4 = 27)
10 => X"53", 11 => X"45", 12 => X"53", 68 => X"38", 71 => X"31", 72 => X"35", 73 => X"39", 75 => X"61", 76 => X"38", 83 => X"38", 84 => X"2E", 99 => X"64", 100 => X"38", 101 => X"2E", 107 => X"38", 108 => X"38", 115 => X"38", 116 => X"62", 131 => X"38", 132 => X"50", 133 => X"38", 139 => X"50", 140 => X"22", 147 => X"59", 148 => X"38", 163 => X"38", 164 => X"7C", 165 => X"38", 171 => X"7C", 172 => X"6F", 179 => X"7C", 180 => X"38", 195 => X"38", 197 => X"38", 203 => X"27", 206 => X"61", 207 => X"65", 208 => X"69", 212 => X"38", 227 => X"38", 228 => X"2E", 229 => X"38", 235 => X"60", 236 => X"27", 237 => X"2E", 243 => X"5F", 244 => X"59", 259 => X"2F", 261 => X"38", 269 => X"62", 274 => X"64", 276 => X"60", 294 => X"2E", 301 => X"38", 306 => X"50", 307 => X"2E", 309 => X"62", 322 => X"64", 325 => X"3A", 326 => X"62", 330 => X"64", 333 => X"38", 338 => X"27", 339 => X"22", 340 => X"60", 341 => X"38", 354 => X"38", 358 => X"38", 362 => X"38", 365 => X"59", 369 => X"64", 373 => X"38", 386 => X"50", 390 => X"38", 394 => X"50", 397 => X"3A", 401 => X"38", 405 => X"38", 418 => X"61", 422 => X"38", 426 => X"61", 429 => X"61", 433 => X"61", 437 => X"38", 450 => X"22", 451 => X"5F", 453 => X"7C", 454 => X"50", 458 => X"22", 459 => X"5F", 461 => X"38", 465 => X"22", 466 => X"5F", 468 => X"7C", 469 => X"50", 480 => X"6A", 483 => X"22", 485 => X"7C", 488 => X"6A", 491 => X"22", 493 => X"38", 494 => X"60", 495 => X"6A", 498 => X"22", 500 => X"7C", 512 => X"61", 515 => X"2E", 516 => X"5F", 517 => X"7C", 520 => X"61", 523 => X"2E", 524 => X"2E", 526 => X"27", 527 => X"61", 530 => X"2E", 531 => X"5F", 532 => X"7C", 546 => X"2E", 547 => X"29", 548 => X"38", 549 => X"60", 550 => X"27", 554 => X"2E", 555 => X"29", 556 => X"38", 557 => X"5F", 561 => X"2E", 562 => X"29", 563 => X"38", 564 => X"60", 565 => X"27", 609 => X"6E", 610 => X"61", 611 => X"64", 612 => X"79", 613 => X"54", 614 => X"67", 617 => X"41", 618 => X"6C", 619 => X"74", 620 => X"48", 621 => X"52", 622 => X"6E", 625 => X"4B", 626 => X"65", 627 => X"47", 628 => X"73", 629 => X"29", 1032 => X"5F", 1033 => X"2E", 1034 => X"2D", 1035 => X"2D", 1037 => X"47", 1038 => X"70", 1063 => X"4C", 1067 => X"5F", 1068 => X"29", 1093 => X"2D", 1095 => X"2E", 1096 => X"5F", 1097 => X"2E", 1098 => X"28", 1101 => X"41", 1102 => X"65", 1103 => X"28", 1104 => X"74", 1105 => X"61", 1107 => X"29", 1108 => X"37", 1109 => X"33", 1126 => X"2D", 1127 => X"5F", 1133 => X"41", 1134 => X"6C", 1135 => X"28", 1137 => X"6F", 1138 => X"75", 1140 => X"37", 1141 => X"30", 1158 => X"27", 1161 => X"5F", 1165 => X"4B", 1166 => X"65", 1167 => X"28", 1168 => X"33", 1169 => X"33", 1172 => X"36", 1173 => X"37", 1193 => X"29", 
    others => X"00"
    );

  shared variable v_ram2 : t_ram := (
    27 => X"09",  -- config "xy coords spans on three bytes" (108/4 = 27)
10 => X"4B", 11 => X"54", 13 => X"31", 67 => X"61", 68 => X"38", 71 => X"32", 72 => X"36", 75 => X"38", 76 => X"62", 83 => X"38", 99 => X"38", 100 => X"38", 107 => X"38", 108 => X"38", 114 => X"64", 115 => X"38", 116 => X"2E", 131 => X"50", 132 => X"22", 139 => X"22", 140 => X"59", 146 => X"38", 147 => X"50", 148 => X"38", 163 => X"7C", 164 => X"6F", 171 => X"6F", 172 => X"7C", 178 => X"38", 179 => X"7C", 180 => X"38", 195 => X"27", 204 => X"2E", 206 => X"62", 207 => X"66", 208 => X"6A", 210 => X"38", 212 => X"38", 227 => X"60", 228 => X"27", 229 => X"2E", 235 => X"2E", 242 => X"38", 243 => X"2E", 244 => X"38", 261 => X"62", 269 => X"2E", 274 => X"2F", 276 => X"38", 290 => X"2E", 293 => X"59", 298 => X"64", 301 => X"62", 309 => X"2E", 322 => X"38", 325 => X"3A", 326 => X"2E", 330 => X"38", 332 => X"60", 333 => X"38", 337 => X"64", 340 => X"3A", 341 => X"62", 354 => X"22", 357 => X"60", 358 => X"62", 362 => X"22", 365 => X"38", 369 => X"38", 373 => X"38", 390 => X"38", 395 => X"27", 397 => X"38", 401 => X"50", 405 => X"38", 418 => X"2E", 421 => X"5F", 422 => X"50", 426 => X"2E", 427 => X"3A", 429 => X"38", 433 => X"2E", 436 => X"5F", 437 => X"50", 449 => X"2E", 450 => X"59", 454 => X"7C", 457 => X"2E", 458 => X"59", 459 => X"3A", 460 => X"2E", 461 => X"38", 464 => X"2E", 465 => X"59", 469 => X"7C", 480 => X"67", 481 => X"5C", 488 => X"67", 489 => X"5C", 492 => X"60", 493 => X"50", 494 => X"2E", 495 => X"67", 496 => X"5C", 512 => X"3A", 513 => X"2F", 515 => X"5F", 516 => X"5F", 518 => X"2E", 520 => X"3A", 521 => X"2F", 523 => X"5F", 524 => X"64", 527 => X"3A", 528 => X"2F", 530 => X"5F", 531 => X"5F", 533 => X"2E", 545 => X"60", 546 => X"2E", 547 => X"38", 548 => X"38", 549 => X"2E", 553 => X"60", 554 => X"2E", 555 => X"38", 556 => X"50", 557 => X"2E", 560 => X"60", 561 => X"2E", 562 => X"38", 563 => X"38", 564 => X"2E", 609 => X"64", 610 => X"73", 611 => X"69", 613 => X"65", 614 => X"75", 617 => X"74", 618 => X"61", 619 => X"68", 620 => X"61", 622 => X"29", 625 => X"61", 626 => X"72", 627 => X"72", 628 => X"6F", 1032 => X"2E", 1033 => X"2E", 1034 => X"22", 1035 => X"2D", 1037 => X"72", 1038 => X"3A", 1063 => X"2E", 1067 => X"4F", 1068 => X"5F", 1093 => X"2E", 1095 => X"2B", 1097 => X"2E", 1101 => X"6E", 1102 => X"61", 1103 => X"64", 1104 => X"79", 1105 => X"54", 1106 => X"67", 1108 => X"32", 1125 => X"60", 1126 => X"27", 1127 => X"2E", 1128 => X"5C", 1130 => X"5C", 1133 => X"74", 1134 => X"61", 1135 => X"54", 1136 => X"48", 1137 => X"52", 1138 => X"4E", 1140 => X"30", 1158 => X"27", 1161 => X"5F", 1162 => X"2F", 1165 => X"61", 1166 => X"72", 1167 => X"47", 1168 => X"73", 1169 => X"29", 1172 => X"31", 
    others => X"00"
    );

  shared variable v_ram3 : t_ram := (
    27 => X"5E",  -- config "xy coords spans on three bytes" (108/4 = 27)
10 => X"59", 12 => X"56", 13 => X"2E", 67 => X"38", 68 => X"62", 71 => X"33", 72 => X"37", 75 => X"38", 76 => X"2E", 82 => X"61", 83 => X"38", 99 => X"38", 100 => X"38", 107 => X"38", 108 => X"62", 114 => X"38", 115 => X"38", 131 => X"22", 132 => X"59", 139 => X"59", 140 => X"38", 146 => X"50", 147 => X"22", 163 => X"6F", 164 => X"7C", 171 => X"7C", 172 => X"38", 178 => X"7C", 179 => X"6F", 196 => X"2E", 204 => X"38", 206 => X"63", 207 => X"67", 210 => X"27", 227 => X"2E", 235 => X"5F", 236 => X"59", 242 => X"60", 243 => X"27", 244 => X"2E", 261 => X"2E", 266 => X"64", 268 => X"60", 276 => X"62", 290 => X"64", 293 => X"38", 298 => X"50", 299 => X"2E", 301 => X"2E", 305 => X"2E", 308 => X"59", 322 => X"3A", 325 => X"38", 330 => X"3A", 331 => X"22", 332 => X"3A", 333 => X"62", 337 => X"38", 340 => X"3A", 341 => X"2E", 357 => X"59", 365 => X"38", 369 => X"22", 372 => X"60", 373 => X"62", 385 => X"3A", 387 => X"27", 389 => X"3A", 393 => X"3A", 397 => X"38", 405 => X"38", 419 => X"3A", 421 => X"61", 429 => X"38", 434 => X"3A", 436 => X"61", 449 => X"5F", 450 => X"61", 451 => X"3A", 453 => X"38", 457 => X"5F", 458 => X"61", 460 => X"7C", 461 => X"50", 464 => X"5F", 465 => X"61", 466 => X"3A", 468 => X"38", 480 => X"73", 482 => X"59", 485 => X"38", 486 => X"60", 488 => X"73", 490 => X"59", 492 => X"7C", 495 => X"73", 497 => X"59", 500 => X"38", 501 => X"60", 512 => X"66", 515 => X"5F", 516 => X"2E", 518 => X"27", 520 => X"66", 523 => X"5F", 524 => X"7C", 527 => X"66", 530 => X"5F", 531 => X"2E", 533 => X"27", 545 => X"2D", 546 => X"5F", 547 => X"38", 548 => X"38", 549 => X"5F", 553 => X"2D", 554 => X"5F", 555 => X"38", 556 => X"60", 557 => X"27", 560 => X"2D", 561 => X"5F", 562 => X"38", 563 => X"38", 564 => X"5F", 609 => X"72", 611 => X"72", 612 => X"4C", 613 => X"58", 614 => X"79", 617 => X"74", 619 => X"65", 620 => X"58", 621 => X"48", 625 => X"73", 627 => X"75", 628 => X"6D", 1032 => X"2D", 1033 => X"2D", 1034 => X"2D", 1035 => X"63", 1037 => X"6F", 1063 => X"2E", 1067 => X"5F", 1097 => X"2D", 1098 => X"2F", 1101 => X"64", 1102 => X"73", 1103 => X"69", 1105 => X"65", 1106 => X"75", 1107 => X"73", 1108 => X"36", 1125 => X"5C", 1126 => X"27", 1127 => X"2D", 1130 => X"5F", 1133 => X"74", 1135 => X"68", 1136 => X"61", 1138 => X"29", 1139 => X"73", 1140 => X"36", 1158 => X"27", 1160 => X"60", 1162 => X"5C", 1165 => X"73", 1167 => X"72", 1168 => X"6F", 1171 => X"73", 1172 => X"38",
    others => X"00"
    );

begin

  p_rw0_port : process (i_clock_rw)
  begin
    if rising_edge(i_clock_rw) then
      if i_SSR = '1' then
        o_DI_rw(31 downto 24) <= (others => '0');
      elsif (i_EN_rw = '1') then
        o_DI_rw(31 downto 24) <= v_ram0(conv_integer(i_ADDR_rw));
        if (i_WE_rw(0) = '1') then
          v_ram0(conv_integer(i_ADDR_rw)) := i_DI_rw(31 downto 24);
        end if;
      end if;
    end if;
  end process;

  p_rw1_port : process (i_clock_rw)
  begin
    if rising_edge(i_clock_rw) then
      if i_SSR = '1' then
        o_DI_rw(23 downto 16) <= (others => '0');
      elsif (i_EN_rw = '1') then
        o_DI_rw(23 downto 16) <= v_ram1(conv_integer(i_ADDR_rw));
        if (i_WE_rw(1) = '1') then
          v_ram1(conv_integer(i_ADDR_rw)) := i_DI_rw(23 downto 16);
        end if;
      end if;
    end if;
  end process;

  p_rw2_port : process (i_clock_rw)
  begin
    if rising_edge(i_clock_rw) then
      if i_SSR = '1' then
        o_DI_rw(15 downto 8) <= (others => '0');
      elsif (i_EN_rw = '1') then
        o_DI_rw(15 downto 8) <= v_ram2(conv_integer(i_ADDR_rw));
        if (i_WE_rw(2) = '1') then
          v_ram2(conv_integer(i_ADDR_rw)) := i_DI_rw(15 downto 8);
        end if;
      end if;
    end if;
  end process;

  p_rw3_port : process (i_clock_rw)
  begin
    if rising_edge(i_clock_rw) then
      if i_SSR = '1' then
        o_DI_rw(7 downto 0) <= (others => '0');
      elsif (i_EN_rw = '1') then
        o_DI_rw(7 downto 0) <= v_ram3(conv_integer(i_ADDR_rw));
        if (i_WE_rw(3) = '1') then
          v_ram3(conv_integer(i_ADDR_rw)) := i_DI_rw(7 downto 0);
        end if;
      end if;
    end if;
  end process;


  p_ro0_port : process (i_clock_r)
  begin
    if rising_edge(i_clock_r) then
      if i_SSR = '1' then
        s0_DO_r <= (others => '0');
      elsif (i_EN_r = '1') then
        s0_DO_r <= v_ram0(conv_integer(i_ADDR_r(i_ADDR_r'left downto 2)));
      end if;
    end if;
  end process;

  p_ro1_port : process (i_clock_r)
  begin
    if rising_edge(i_clock_r) then
      if i_SSR = '1' then
        s1_DO_r <= (others => '0');
      elsif (i_EN_r = '1') then
        s1_DO_r <= v_ram1(conv_integer(i_ADDR_r(i_ADDR_r'left downto 2)));
      end if;
    end if;
  end process;

  p_ro2_port : process (i_clock_r)
  begin
    if rising_edge(i_clock_r) then
      if i_SSR = '1' then
        s2_DO_r <= (others => '0');
      elsif (i_EN_r = '1') then
        s2_DO_r <= v_ram2(conv_integer(i_ADDR_r(i_ADDR_r'left downto 2)));
      end if;
    end if;
  end process;

  p_ro3_port : process (i_clock_r)
  begin
    if rising_edge(i_clock_r) then
      if i_SSR = '1' then
        s3_DO_r <= (others => '0');
      elsif (i_EN_r = '1') then
        s3_DO_r <= v_ram3(conv_integer(i_ADDR_r(i_ADDR_r'left downto 2)));
      end if;
    end if;
  end process;

  o_DO_r <=
    s0_DO_r when i_ADDR_r(1 downto 0) = "00" else
    s1_DO_r when i_ADDR_r(1 downto 0) = "01" else
    s2_DO_r when i_ADDR_r(1 downto 0) = "10" else
    s3_DO_r when i_ADDR_r(1 downto 0) = "11" else
    (others => 'X');
end Behavioral;
