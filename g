#! /c/Source/iverilog-install/bin/vvp
:ivl_version "12.0 (devel)" "(s20150603-1110-g18392a46)";
:ivl_delay_selection "TYPICAL";
:vpi_time_precision - 12;
:vpi_module "C:\Users\sarve\iverilog\lib\ivl\system.vpi";
:vpi_module "C:\Users\sarve\iverilog\lib\ivl\vhdl_sys.vpi";
:vpi_module "C:\Users\sarve\iverilog\lib\ivl\vhdl_textio.vpi";
:vpi_module "C:\Users\sarve\iverilog\lib\ivl\v2005_math.vpi";
:vpi_module "C:\Users\sarve\iverilog\lib\ivl\va_math.vpi";
S_000001e652f6a650 .scope module, "imm_gen_tb" "imm_gen_tb" 2 4;
 .timescale -9 -12;
v000001e652fb40d0_0 .net "imm", 63 0, L_000001e652ffc930;  1 drivers
v000001e652fb4170_0 .var "instruction", 31 0;
S_000001e652f6a7e0 .scope module, "uut" "imm_gen" 2 9, 3 1 0, S_000001e652f6a650;
 .timescale -9 -12;
    .port_info 0 /INPUT 32 "instruction";
    .port_info 1 /OUTPUT 64 "imm";
v000001e652f67680_0 .net *"_ivl_1", 0 0, L_000001e652ffd5b0;  1 drivers
v000001e652fb5ae0_0 .net *"_ivl_11", 3 0, L_000001e652ffd0b0;  1 drivers
v000001e652f66fd0_0 .net *"_ivl_2", 51 0, L_000001e652ffd650;  1 drivers
v000001e652f6a970_0 .net *"_ivl_5", 0 0, L_000001e652ffd6f0;  1 drivers
v000001e652f6aa10_0 .net *"_ivl_7", 0 0, L_000001e652ffd790;  1 drivers
v000001e652fb3ef0_0 .net *"_ivl_9", 5 0, L_000001e652ffc890;  1 drivers
v000001e652fb3f90_0 .net "imm", 63 0, L_000001e652ffc930;  alias, 1 drivers
v000001e652fb4030_0 .net "instruction", 31 0, v000001e652fb4170_0;  1 drivers
L_000001e652ffd5b0 .part v000001e652fb4170_0, 31, 1;
LS_000001e652ffd650_0_0 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_4 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_8 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_12 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_16 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_20 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_24 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_28 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_32 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_36 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_40 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_44 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_0_48 .concat [ 1 1 1 1], L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0, L_000001e652ffd5b0;
LS_000001e652ffd650_1_0 .concat [ 4 4 4 4], LS_000001e652ffd650_0_0, LS_000001e652ffd650_0_4, LS_000001e652ffd650_0_8, LS_000001e652ffd650_0_12;
LS_000001e652ffd650_1_4 .concat [ 4 4 4 4], LS_000001e652ffd650_0_16, LS_000001e652ffd650_0_20, LS_000001e652ffd650_0_24, LS_000001e652ffd650_0_28;
LS_000001e652ffd650_1_8 .concat [ 4 4 4 4], LS_000001e652ffd650_0_32, LS_000001e652ffd650_0_36, LS_000001e652ffd650_0_40, LS_000001e652ffd650_0_44;
LS_000001e652ffd650_1_12 .concat [ 4 0 0 0], LS_000001e652ffd650_0_48;
L_000001e652ffd650 .concat [ 16 16 16 4], LS_000001e652ffd650_1_0, LS_000001e652ffd650_1_4, LS_000001e652ffd650_1_8, LS_000001e652ffd650_1_12;
L_000001e652ffd6f0 .part v000001e652fb4170_0, 31, 1;
L_000001e652ffd790 .part v000001e652fb4170_0, 7, 1;
L_000001e652ffc890 .part v000001e652fb4170_0, 25, 6;
L_000001e652ffd0b0 .part v000001e652fb4170_0, 8, 4;
LS_000001e652ffc930_0_0 .concat [ 4 6 1 1], L_000001e652ffd0b0, L_000001e652ffc890, L_000001e652ffd790, L_000001e652ffd6f0;
LS_000001e652ffc930_0_4 .concat [ 52 0 0 0], L_000001e652ffd650;
L_000001e652ffc930 .concat [ 12 52 0 0], LS_000001e652ffc930_0_0, LS_000001e652ffc930_0_4;
    .scope S_000001e652f6a650;
T_0 ;
    %vpi_call 2 16 "$monitor", "Time = %0t | instruction = %b | imm = %b", $time, v000001e652fb4170_0, v000001e652fb40d0_0 {0 0 0};
    %pushi/vec4 0, 0, 32;
    %store/vec4 v000001e652fb4170_0, 0, 32;
    %delay 10000, 0;
    %pushi/vec4 4294967295, 0, 32;
    %store/vec4 v000001e652fb4170_0, 0, 32;
    %delay 10000, 0;
    %pushi/vec4 4095, 0, 32;
    %store/vec4 v000001e652fb4170_0, 0, 32;
    %delay 10000, 0;
    %pushi/vec4 2147483648, 0, 32;
    %store/vec4 v000001e652fb4170_0, 0, 32;
    %delay 10000, 0;
    %pushi/vec4 2147418112, 0, 32;
    %store/vec4 v000001e652fb4170_0, 0, 32;
    %delay 10000, 0;
    %pushi/vec4 2863311530, 0, 32;
    %store/vec4 v000001e652fb4170_0, 0, 32;
    %delay 10000, 0;
    %pushi/vec4 3435973836, 0, 32;
    %store/vec4 v000001e652fb4170_0, 0, 32;
    %delay 10000, 0;
    %vpi_call 2 28 "$finish" {0 0 0};
    %end;
    .thread T_0;
# The file index is used to find the file name in the following table.
:file_names 4;
    "N/A";
    "<interactive>";
    "imm_gen_tb.v";
    "./immgen.v";
