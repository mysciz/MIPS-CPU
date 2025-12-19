%!PS-Adobe-3.0
%%Creator: Model Technology ModelSim DE-64 vsim 10.6c Simulator 2017.07 Jul 26 2017
%%Title: ./out/mips_wave.do
%%CreationDate: 2025-12-17 11:21:16 pm
%%DocumentData: Clean8Bit
%%DocumentNeededResources: font Helvetica
%%Orientation: Landscape
%%PageOrder: ascend
%%Pages: 3
%%EndComments
%%BeginSetup
%%BeginFeature: *PageSize 3.3464566929133857x4.3307086614173231
<< /PageSize [240.94488188976376 311.81102362204729]
/ImagingBBox null
>> setpagedevice
%%EndFeature
%%EndSetup
%%Page: 1 1
gsave
90 rotate 0.12 dup neg scale
% dump string table
/NP {newpath} def/SD {setdash} def/CL {setrgbcolor} def/GR {setgray} def
/SX {exch LEdge sub XScale mul MaxLabelWidth add LMargin add LEdge LabelWidth sub add exch} def/CSX {exch dup LabelWidth gt {exch SX} {exch} ifelse} def
/MT {SX moveto} def/LS {SX lineto stroke} def/LT {SX lineto} def/LFS {SX lineto fill stroke} def/RSS {rmoveto show stroke} def/ST {stroke} def/WT {CSX moveto dup stringwidth pop} def/TSW {pop 0 originOffset} def
/TSE {MaxLabelWidth LabelWidth sub LMargin add 0 rmoveto neg originOffset} def/TS {-2 div originOffset CSX} def
/MLW {stringwidth pop dup MaxLabelWidth gt {/MaxLabelWidth exch def}{pop} ifelse XS} def
/XS {/XScale LabelWidth LMargin sub MaxLabelWidth LEdge LabelWidth sub add sub REdge LEdge sub div 1 add def} def
/ARC {5 -2 roll SX 5 2 roll arc} def/LC {1 index stringwidth pop lt {pop ()} if} def
/SW {stringwidth pop} def
/ESTR {   dup 3 add string   /CurrentStr exch def   exch 0 2 index getinterval   0 1 3 index 1 sub {     dup     2 index exch get exch     CurrentStr exch 3 -1 roll put   } for   pop   dup 1 2 2 index add {     CurrentStr exch 46 put   } for   pop} def
/LC {   exch  dup dup /CurrentStr exch def   SW 2 index gt {     CurrentStr length     dup     {       2 div cvi       3 index       CurrentStr SW       sub       dup 0 lt {         1 index         4 -1 roll         exch sub         3 1 roll       }       {         dup 5 index gt {           1 index 4 -1 roll add 3 1 roll         }         {           exit         } ifelse       } ifelse       3 index 2 index ESTR       1 index 0 eq {         exit       } if       pop     } loop     pop pop pop pop pop     CurrentStr   }   {     CurrentStr   } ifelse} def
/XScale 1 def/MaxLabelWidth 0 def/LMargin 118 def/LEdge 1005 def/REdge 2243 def/LabelWidth 968 def
/Helvetica findfont [66 0 0 -66 0 0] makefont setfont
/originOffset   currentfont   /FontBBox get 1 get   currentfont  /FontMatrix get 3 get   mul   currentfont   /FontType get   42 eq {     1000000 div   } {     neg   } ifelse def
(Clock & Reset) MLW
(/mips_tb/clk) MLW
(/mips_tb/rst) MLW
(/mips_tb/cycle_count) MLW
(Program Counter) MLW
(PC) MLW
(Instruction) MLW
(Control Unit Signals) MLW
(RegDst) MLW
(Jump) MLW
(Branch) MLW
(MemRead) MLW
(MemtoReg) MLW
(ALUOp) MLW
(MemWrite) MLW
(ALUSrc) MLW
(RegWrite) MLW
(ALU) MLW
(ALU_Out) MLW
(Zero_Flag) MLW
(Register File) MLW
(Write_Data) MLW
(Data Memory) MLW
(Read_Data) MLW
(Test Results) MLW
(Pass_Count) MLW
(Fail_Count) MLW
% draw waveform shading
0 0 0 CL
({Clock & Reset}) 9999 LC 968 210 WT TSE RSS
[] 0 SD
3 setlinewidth
0 setlinejoin
2 setlinecap
1005 174 MT 2478 174 LS
1045 118 MT 1059 118 LS
1720 118 MT 1734 118 LS
2396 118 MT 2410 118 LS
1006 258 MT 2403 258 LS
2403 258 MT 2403 258 LS
1006 449 MT 2403 449 LS
2403 449 MT 2403 449 LS
(00000069) 1328 LC 1040 532 WT pop 0 originOffset 33 add RSS
1005 496 MT 1005 496 LT 2403 496 LT ST
1005 568 MT 1005 568 LT 2403 568 LT ST
({Program Counter}) 9999 LC 968 686 WT TSE RSS
1005 650 MT 2478 650 LS
1045 594 MT 1059 594 LS
1720 594 MT 1734 594 LS
2396 594 MT 2410 594 LS
(32'h00400080) 1328 LC 1040 770 WT pop 0 originOffset 33 add RSS
1005 734 MT 1005 734 LT 2403 734 LT ST
1005 806 MT 1005 806 LT 2403 806 LT ST
(32'h08100020) 1328 LC 1040 889 WT pop 0 originOffset 33 add RSS
1005 853 MT 1005 853 LT 2403 853 LT ST
1005 925 MT 1005 925 LT 2403 925 LT ST
({Control Unit Signals}) 9999 LC 968 1043 WT TSE RSS
1005 1007 MT 2478 1007 LS
1045 951 MT 1059 951 LS
1720 951 MT 1734 951 LS
2396 951 MT 2410 951 LS
1006 1127 MT 2403 1127 LS
2403 1127 MT 2403 1127 LS
1006 1210 MT 2403 1210 LS
2403 1210 MT 2403 1210 LS
1006 1401 MT 2403 1401 LS
2403 1401 MT 2403 1401 LS
1006 1520 MT 2403 1520 LS
2403 1520 MT 2403 1520 LS
% draw timeline
1014 1646 MT 1014 1683 LS
1013 1665 MT 1015 1665 LS
1052 1619 MT 1052 1683 LS
(2119 ns) 9999 LC 1052 1754 WT TS RSS
1120 1646 MT 1120 1683 LS
1187 1646 MT 1187 1683 LS
1255 1646 MT 1255 1683 LS
1322 1646 MT 1322 1683 LS
1390 1646 MT 1390 1683 LS
1457 1646 MT 1457 1683 LS
1525 1646 MT 1525 1683 LS
1593 1646 MT 1593 1683 LS
1660 1646 MT 1660 1683 LS
1727 1619 MT 1727 1683 LS
1795 1646 MT 1795 1683 LS
1862 1646 MT 1862 1683 LS
1930 1646 MT 1930 1683 LS
1997 1646 MT 1997 1683 LS
2065 1646 MT 2065 1683 LS
2132 1646 MT 2132 1683 LS
2200 1646 MT 2200 1683 LS
2268 1646 MT 2268 1683 LS
2335 1646 MT 2335 1683 LS
2403 1619 MT 2403 1683 LS
(2120 ns) 9999 LC 2403 1754 WT TS RSS
2471 1646 MT 2471 1683 LS
2538 1646 MT 2538 1683 LS
2606 1646 MT 2606 1683 LS
2673 1646 MT 2673 1683 LS
2741 1646 MT 2741 1683 LS
2808 1646 MT 2808 1683 LS
2876 1646 MT 2876 1683 LS
2944 1646 MT 2944 1683 LS
3011 1646 MT 3011 1683 LS
% draw grid
1052 118 MT 1052 1619 LS
1727 118 MT 1727 1619 LS
2403 118 MT 2403 1619 LS
% draw waveforms
({Clock & Reset}) 9999 LC 968 210 WT TSE RSS
1005 174 MT 2478 174 LS
1045 118 MT 1059 118 LS
1720 118 MT 1734 118 LS
2396 118 MT 2410 118 LS
(/mips_tb/clk) 9999 LC 968 329 WT TSE RSS
1045 237 MT 1059 237 LS
1720 237 MT 1734 237 LS
2396 237 MT 2410 237 LS
1006 258 MT 2403 258 LS
2403 258 MT 2403 258 LS
(/mips_tb/rst) 9999 LC 968 448 WT TSE RSS
1045 356 MT 1059 356 LS
1720 356 MT 1734 356 LS
2396 356 MT 2410 356 LS
1006 449 MT 2403 449 LS
2403 449 MT 2403 449 LS
(/mips_tb/cycle_count) 9999 LC 968 567 WT TSE RSS
1045 475 MT 1059 475 LS
1720 475 MT 1734 475 LS
2396 475 MT 2410 475 LS
(00000069) 1328 LC 1040 532 WT pop 0 originOffset 33 add RSS
1005 496 MT 1005 496 LT 2403 496 LT ST
1005 568 MT 1005 568 LT 2403 568 LT ST
({Program Counter}) 9999 LC 968 686 WT TSE RSS
1005 650 MT 2478 650 LS
1045 594 MT 1059 594 LS
1720 594 MT 1734 594 LS
2396 594 MT 2410 594 LS
(PC) 9999 LC 968 805 WT TSE RSS
1045 713 MT 1059 713 LS
1720 713 MT 1734 713 LS
2396 713 MT 2410 713 LS
(32'h00400080) 1328 LC 1040 770 WT pop 0 originOffset 33 add RSS
1005 734 MT 1005 734 LT 2403 734 LT ST
1005 806 MT 1005 806 LT 2403 806 LT ST
(Instruction) 9999 LC 968 924 WT TSE RSS
1045 832 MT 1059 832 LS
1720 832 MT 1734 832 LS
2396 832 MT 2410 832 LS
(32'h08100020) 1328 LC 1040 889 WT pop 0 originOffset 33 add RSS
1005 853 MT 1005 853 LT 2403 853 LT ST
1005 925 MT 1005 925 LT 2403 925 LT ST
({Control Unit Signals}) 9999 LC 968 1043 WT TSE RSS
1005 1007 MT 2478 1007 LS
1045 951 MT 1059 951 LS
1720 951 MT 1734 951 LS
2396 951 MT 2410 951 LS
(RegDst) 9999 LC 968 1162 WT TSE RSS
1045 1070 MT 1059 1070 LS
1720 1070 MT 1734 1070 LS
2396 1070 MT 2410 1070 LS
1006 1127 MT 2403 1127 LS
2403 1127 MT 2403 1127 LS
(Jump) 9999 LC 968 1281 WT TSE RSS
1045 1189 MT 1059 1189 LS
1720 1189 MT 1734 1189 LS
2396 1189 MT 2410 1189 LS
1006 1210 MT 2403 1210 LS
2403 1210 MT 2403 1210 LS
(Branch) 9999 LC 968 1400 WT TSE RSS
1045 1308 MT 1059 1308 LS
1720 1308 MT 1734 1308 LS
2396 1308 MT 2410 1308 LS
1006 1401 MT 2403 1401 LS
2403 1401 MT 2403 1401 LS
(MemRead) 9999 LC 968 1519 WT TSE RSS
1045 1427 MT 1059 1427 LS
1720 1427 MT 1734 1427 LS
2396 1427 MT 2410 1427 LS
1006 1520 MT 2403 1520 LS
2403 1520 MT 2403 1520 LS
% draw footer
(Entity:mips_tb  Architecture:  Date: Wed Dec 17 23:21:16 CST 2025   Row: 1 Page: 1) 9999 LC 118 1888 WT TSW RSS
grestore
showpage
%%Page: 2 2
gsave
90 rotate 0.12 dup neg scale
% dump string table
/NP {newpath} def/SD {setdash} def/CL {setrgbcolor} def/GR {setgray} def
/SX {exch LEdge sub XScale mul MaxLabelWidth add LMargin add LEdge LabelWidth sub add exch} def/CSX {exch dup LabelWidth gt {exch SX} {exch} ifelse} def
/MT {SX moveto} def/LS {SX lineto stroke} def/LT {SX lineto} def/LFS {SX lineto fill stroke} def/RSS {rmoveto show stroke} def/ST {stroke} def/WT {CSX moveto dup stringwidth pop} def/TSW {pop 0 originOffset} def
/TSE {MaxLabelWidth LabelWidth sub LMargin add 0 rmoveto neg originOffset} def/TS {-2 div originOffset CSX} def
/MLW {stringwidth pop dup MaxLabelWidth gt {/MaxLabelWidth exch def}{pop} ifelse XS} def
/XS {/XScale LabelWidth LMargin sub MaxLabelWidth LEdge LabelWidth sub add sub REdge LEdge sub div 1 add def} def
/ARC {5 -2 roll SX 5 2 roll arc} def/LC {1 index stringwidth pop lt {pop ()} if} def
/SW {stringwidth pop} def
/ESTR {   dup 3 add string   /CurrentStr exch def   exch 0 2 index getinterval   0 1 3 index 1 sub {     dup     2 index exch get exch     CurrentStr exch 3 -1 roll put   } for   pop   dup 1 2 2 index add {     CurrentStr exch 46 put   } for   pop} def
/LC {   exch  dup dup /CurrentStr exch def   SW 2 index gt {     CurrentStr length     dup     {       2 div cvi       3 index       CurrentStr SW       sub       dup 0 lt {         1 index         4 -1 roll         exch sub         3 1 roll       }       {         dup 5 index gt {           1 index 4 -1 roll add 3 1 roll         }         {           exit         } ifelse       } ifelse       3 index 2 index ESTR       1 index 0 eq {         exit       } if       pop     } loop     pop pop pop pop pop     CurrentStr   }   {     CurrentStr   } ifelse} def
/XScale 1 def/MaxLabelWidth 0 def/LMargin 118 def/LEdge 1005 def/REdge 2243 def/LabelWidth 968 def
/Helvetica findfont [66 0 0 -66 0 0] makefont setfont
/originOffset   currentfont   /FontBBox get 1 get   currentfont  /FontMatrix get 3 get   mul   currentfont   /FontType get   42 eq {     1000000 div   } {     neg   } ifelse def
(Clock & Reset) MLW
(/mips_tb/clk) MLW
(/mips_tb/rst) MLW
(/mips_tb/cycle_count) MLW
(Program Counter) MLW
(PC) MLW
(Instruction) MLW
(Control Unit Signals) MLW
(RegDst) MLW
(Jump) MLW
(Branch) MLW
(MemRead) MLW
(MemtoReg) MLW
(ALUOp) MLW
(MemWrite) MLW
(ALUSrc) MLW
(RegWrite) MLW
(ALU) MLW
(ALU_Out) MLW
(Zero_Flag) MLW
(Register File) MLW
(Write_Data) MLW
(Data Memory) MLW
(Read_Data) MLW
(Test Results) MLW
(Pass_Count) MLW
(Fail_Count) MLW
% draw waveform shading
[] 0 SD
3 setlinewidth
0 setlinejoin
2 setlinecap
0 0 0 CL
1006 175 MT 2403 175 LS
2403 175 MT 2403 175 LS
1005 294 MT 2403 294 LS
1006 449 MT 2403 449 LS
2403 449 MT 2403 449 LS
1006 532 MT 2403 532 LS
2403 532 MT 2403 532 LS
1006 687 MT 2403 687 LS
2403 687 MT 2403 687 LS
(ALU) 9999 LC 968 805 WT TSE RSS
1005 769 MT 2478 769 LS
1045 713 MT 1059 713 LS
1720 713 MT 1734 713 LS
2396 713 MT 2410 713 LS
(32'h00000020) 1328 LC 1040 889 WT pop 0 originOffset 33 add RSS
1005 853 MT 1005 853 LT 2403 853 LT ST
1005 925 MT 1005 925 LT 2403 925 LT ST
1006 1008 MT 2403 1008 LS
2403 1008 MT 2403 1008 LS
({Register File}) 9999 LC 968 1162 WT TSE RSS
1005 1126 MT 2478 1126 LS
1045 1070 MT 1059 1070 LS
1720 1070 MT 1734 1070 LS
2396 1070 MT 2410 1070 LS
(32'h00000000) 1328 LC 1040 1246 WT pop 0 originOffset 33 add RSS
1005 1210 MT 1005 1210 LT 2403 1210 LT ST
1005 1282 MT 1005 1282 LT 2403 1282 LT ST
({Data Memory}) 9999 LC 968 1400 WT TSE RSS
1005 1364 MT 2478 1364 LS
1045 1308 MT 1059 1308 LS
1720 1308 MT 1734 1308 LS
2396 1308 MT 2410 1308 LS
1006 1484 MT 2403 1484 LS
% draw timeline
1014 1646 MT 1014 1683 LS
1013 1665 MT 1015 1665 LS
1052 1619 MT 1052 1683 LS
(2119 ns) 9999 LC 1052 1754 WT TS RSS
1120 1646 MT 1120 1683 LS
1187 1646 MT 1187 1683 LS
1255 1646 MT 1255 1683 LS
1322 1646 MT 1322 1683 LS
1390 1646 MT 1390 1683 LS
1457 1646 MT 1457 1683 LS
1525 1646 MT 1525 1683 LS
1593 1646 MT 1593 1683 LS
1660 1646 MT 1660 1683 LS
1727 1619 MT 1727 1683 LS
1795 1646 MT 1795 1683 LS
1862 1646 MT 1862 1683 LS
1930 1646 MT 1930 1683 LS
1997 1646 MT 1997 1683 LS
2065 1646 MT 2065 1683 LS
2132 1646 MT 2132 1683 LS
2200 1646 MT 2200 1683 LS
2268 1646 MT 2268 1683 LS
2335 1646 MT 2335 1683 LS
2403 1619 MT 2403 1683 LS
(2120 ns) 9999 LC 2403 1754 WT TS RSS
2471 1646 MT 2471 1683 LS
2538 1646 MT 2538 1683 LS
2606 1646 MT 2606 1683 LS
2673 1646 MT 2673 1683 LS
2741 1646 MT 2741 1683 LS
2808 1646 MT 2808 1683 LS
2876 1646 MT 2876 1683 LS
2944 1646 MT 2944 1683 LS
3011 1646 MT 3011 1683 LS
% draw grid
1052 118 MT 1052 1619 LS
1727 118 MT 1727 1619 LS
2403 118 MT 2403 1619 LS
% draw waveforms
(MemtoReg) 9999 LC 968 210 WT TSE RSS
1045 118 MT 1059 118 LS
1720 118 MT 1734 118 LS
2396 118 MT 2410 118 LS
1006 175 MT 2403 175 LS
2403 175 MT 2403 175 LS
(ALUOp) 9999 LC 968 329 WT TSE RSS
1045 237 MT 1059 237 LS
1720 237 MT 1734 237 LS
2396 237 MT 2410 237 LS
1005 294 MT 2403 294 LS
(MemWrite) 9999 LC 968 448 WT TSE RSS
1045 356 MT 1059 356 LS
1720 356 MT 1734 356 LS
2396 356 MT 2410 356 LS
1006 449 MT 2403 449 LS
2403 449 MT 2403 449 LS
(ALUSrc) 9999 LC 968 567 WT TSE RSS
1045 475 MT 1059 475 LS
1720 475 MT 1734 475 LS
2396 475 MT 2410 475 LS
1006 532 MT 2403 532 LS
2403 532 MT 2403 532 LS
(RegWrite) 9999 LC 968 686 WT TSE RSS
1045 594 MT 1059 594 LS
1720 594 MT 1734 594 LS
2396 594 MT 2410 594 LS
1006 687 MT 2403 687 LS
2403 687 MT 2403 687 LS
(ALU) 9999 LC 968 805 WT TSE RSS
1005 769 MT 2478 769 LS
1045 713 MT 1059 713 LS
1720 713 MT 1734 713 LS
2396 713 MT 2410 713 LS
(ALU_Out) 9999 LC 968 924 WT TSE RSS
1045 832 MT 1059 832 LS
1720 832 MT 1734 832 LS
2396 832 MT 2410 832 LS
(32'h00000020) 1328 LC 1040 889 WT pop 0 originOffset 33 add RSS
1005 853 MT 1005 853 LT 2403 853 LT ST
1005 925 MT 1005 925 LT 2403 925 LT ST
(Zero_Flag) 9999 LC 968 1043 WT TSE RSS
1045 951 MT 1059 951 LS
1720 951 MT 1734 951 LS
2396 951 MT 2410 951 LS
1006 1008 MT 2403 1008 LS
2403 1008 MT 2403 1008 LS
({Register File}) 9999 LC 968 1162 WT TSE RSS
1005 1126 MT 2478 1126 LS
1045 1070 MT 1059 1070 LS
1720 1070 MT 1734 1070 LS
2396 1070 MT 2410 1070 LS
(Write_Data) 9999 LC 968 1281 WT TSE RSS
1045 1189 MT 1059 1189 LS
1720 1189 MT 1734 1189 LS
2396 1189 MT 2410 1189 LS
(32'h00000000) 1328 LC 1040 1246 WT pop 0 originOffset 33 add RSS
1005 1210 MT 1005 1210 LT 2403 1210 LT ST
1005 1282 MT 1005 1282 LT 2403 1282 LT ST
({Data Memory}) 9999 LC 968 1400 WT TSE RSS
1005 1364 MT 2478 1364 LS
1045 1308 MT 1059 1308 LS
1720 1308 MT 1734 1308 LS
2396 1308 MT 2410 1308 LS
(Read_Data) 9999 LC 968 1519 WT TSE RSS
1045 1427 MT 1059 1427 LS
1720 1427 MT 1734 1427 LS
2396 1427 MT 2410 1427 LS
1005 1484 MT 2403 1484 LS
% draw footer
(Entity:mips_tb  Architecture:  Date: Wed Dec 17 23:21:16 CST 2025   Row: 1 Page: 2) 9999 LC 118 1888 WT TSW RSS
grestore
showpage
%%Page: 3 3
gsave
90 rotate 0.12 dup neg scale
% dump string table
/NP {newpath} def/SD {setdash} def/CL {setrgbcolor} def/GR {setgray} def
/SX {exch LEdge sub XScale mul MaxLabelWidth add LMargin add LEdge LabelWidth sub add exch} def/CSX {exch dup LabelWidth gt {exch SX} {exch} ifelse} def
/MT {SX moveto} def/LS {SX lineto stroke} def/LT {SX lineto} def/LFS {SX lineto fill stroke} def/RSS {rmoveto show stroke} def/ST {stroke} def/WT {CSX moveto dup stringwidth pop} def/TSW {pop 0 originOffset} def
/TSE {MaxLabelWidth LabelWidth sub LMargin add 0 rmoveto neg originOffset} def/TS {-2 div originOffset CSX} def
/MLW {stringwidth pop dup MaxLabelWidth gt {/MaxLabelWidth exch def}{pop} ifelse XS} def
/XS {/XScale LabelWidth LMargin sub MaxLabelWidth LEdge LabelWidth sub add sub REdge LEdge sub div 1 add def} def
/ARC {5 -2 roll SX 5 2 roll arc} def/LC {1 index stringwidth pop lt {pop ()} if} def
/SW {stringwidth pop} def
/ESTR {   dup 3 add string   /CurrentStr exch def   exch 0 2 index getinterval   0 1 3 index 1 sub {     dup     2 index exch get exch     CurrentStr exch 3 -1 roll put   } for   pop   dup 1 2 2 index add {     CurrentStr exch 46 put   } for   pop} def
/LC {   exch  dup dup /CurrentStr exch def   SW 2 index gt {     CurrentStr length     dup     {       2 div cvi       3 index       CurrentStr SW       sub       dup 0 lt {         1 index         4 -1 roll         exch sub         3 1 roll       }       {         dup 5 index gt {           1 index 4 -1 roll add 3 1 roll         }         {           exit         } ifelse       } ifelse       3 index 2 index ESTR       1 index 0 eq {         exit       } if       pop     } loop     pop pop pop pop pop     CurrentStr   }   {     CurrentStr   } ifelse} def
/XScale 1 def/MaxLabelWidth 0 def/LMargin 118 def/LEdge 1005 def/REdge 2243 def/LabelWidth 968 def
/Helvetica findfont [66 0 0 -66 0 0] makefont setfont
/originOffset   currentfont   /FontBBox get 1 get   currentfont  /FontMatrix get 3 get   mul   currentfont   /FontType get   42 eq {     1000000 div   } {     neg   } ifelse def
(Clock & Reset) MLW
(/mips_tb/clk) MLW
(/mips_tb/rst) MLW
(/mips_tb/cycle_count) MLW
(Program Counter) MLW
(PC) MLW
(Instruction) MLW
(Control Unit Signals) MLW
(RegDst) MLW
(Jump) MLW
(Branch) MLW
(MemRead) MLW
(MemtoReg) MLW
(ALUOp) MLW
(MemWrite) MLW
(ALUSrc) MLW
(RegWrite) MLW
(ALU) MLW
(ALU_Out) MLW
(Zero_Flag) MLW
(Register File) MLW
(Write_Data) MLW
(Data Memory) MLW
(Read_Data) MLW
(Test Results) MLW
(Pass_Count) MLW
(Fail_Count) MLW
% draw waveform shading
0 0 0 CL
({Test Results}) 9999 LC 968 210 WT TSE RSS
[] 0 SD
3 setlinewidth
0 setlinejoin
2 setlinecap
1005 174 MT 2478 174 LS
1045 118 MT 1059 118 LS
1720 118 MT 1734 118 LS
2396 118 MT 2410 118 LS
(32'h00000001) 1328 LC 1040 294 WT pop 0 originOffset 33 add RSS
1005 258 MT 1005 258 LT 2403 258 LT ST
1005 330 MT 1005 330 LT 2403 330 LT ST
(32'h00000000) 1328 LC 1040 413 WT pop 0 originOffset 33 add RSS
1005 377 MT 1005 377 LT 2403 377 LT ST
1005 449 MT 1005 449 LT 2403 449 LT ST
% draw timeline
1014 1646 MT 1014 1683 LS
1013 1665 MT 1015 1665 LS
1052 1619 MT 1052 1683 LS
(2119 ns) 9999 LC 1052 1754 WT TS RSS
1120 1646 MT 1120 1683 LS
1187 1646 MT 1187 1683 LS
1255 1646 MT 1255 1683 LS
1322 1646 MT 1322 1683 LS
1390 1646 MT 1390 1683 LS
1457 1646 MT 1457 1683 LS
1525 1646 MT 1525 1683 LS
1593 1646 MT 1593 1683 LS
1660 1646 MT 1660 1683 LS
1727 1619 MT 1727 1683 LS
1795 1646 MT 1795 1683 LS
1862 1646 MT 1862 1683 LS
1930 1646 MT 1930 1683 LS
1997 1646 MT 1997 1683 LS
2065 1646 MT 2065 1683 LS
2132 1646 MT 2132 1683 LS
2200 1646 MT 2200 1683 LS
2268 1646 MT 2268 1683 LS
2335 1646 MT 2335 1683 LS
2403 1619 MT 2403 1683 LS
(2120 ns) 9999 LC 2403 1754 WT TS RSS
2471 1646 MT 2471 1683 LS
2538 1646 MT 2538 1683 LS
2606 1646 MT 2606 1683 LS
2673 1646 MT 2673 1683 LS
2741 1646 MT 2741 1683 LS
2808 1646 MT 2808 1683 LS
2876 1646 MT 2876 1683 LS
2944 1646 MT 2944 1683 LS
3011 1646 MT 3011 1683 LS
% draw grid
1052 118 MT 1052 1619 LS
1727 118 MT 1727 1619 LS
2403 118 MT 2403 1619 LS
% draw waveforms
({Test Results}) 9999 LC 968 210 WT TSE RSS
1005 174 MT 2478 174 LS
1045 118 MT 1059 118 LS
1720 118 MT 1734 118 LS
2396 118 MT 2410 118 LS
(Pass_Count) 9999 LC 968 329 WT TSE RSS
1045 237 MT 1059 237 LS
1720 237 MT 1734 237 LS
2396 237 MT 2410 237 LS
(32'h00000001) 1328 LC 1040 294 WT pop 0 originOffset 33 add RSS
1005 258 MT 1005 258 LT 2403 258 LT ST
1005 330 MT 1005 330 LT 2403 330 LT ST
(Fail_Count) 9999 LC 968 448 WT TSE RSS
1045 356 MT 1059 356 LS
1720 356 MT 1734 356 LS
2396 356 MT 2410 356 LS
(32'h00000000) 1328 LC 1040 413 WT pop 0 originOffset 33 add RSS
1005 377 MT 1005 377 LT 2403 377 LT ST
1005 449 MT 1005 449 LT 2403 449 LT ST
% draw footer
(Entity:mips_tb  Architecture:  Date: Wed Dec 17 23:21:16 CST 2025   Row: 1 Page: 3) 9999 LC 118 1888 WT TSW RSS
grestore
showpage
%%EOF
