1 PCLEAR 1:CLEAR 1000:CLS
5 BA=&H64
7 GOSUB 200
10 DIM P$(100),B(100),C(100)
15 TSCR=&H400
20 P=1:PRINT STRING$(32,166);:PRINT @480,STRING$(31,166);:PRINT @32,"";:POKE TSCR+511,166
30 READ P$(P),B(P),C(P):IF B(P)>0 THEN P=P+1:GOTO 30 ELSE P=P-1
32 FP=1:LP=P:IF LP>12 THEN LP=12
35 A$=">>> COCOFLASH MENU <<<":PRINT TAB(INT(16-(LEN(A$)/2)));A$:FOR X=2 TO 15:PRINT @(X-1)*32,CHR$(166);:PRINT @X*32-1,CHR$(166);:NEXT X
40 FOR X=FP TO LP:PRINT @(X-FP+2)*32+1,RIGHT$("   "+STR$(X),4);")"+P$(X);:NEXT X:PRINT @(X-FP+2)*32+31,CHR$(166);:PRINT @(X-FP+2)*32+1,"";
50 INPUT "SELECTION(P=PREV,N=NEXT):";S$:S=VAL(S$):IF (S<1 OR S>P) AND S$<>"N" AND S$<>"P" THEN RUN
52 PRINT @(X-FP+2)*32+31,CHR$(166);
55 IF S=0 THEN GOTO 100
57 SLOT=PEEK(&HFF7F) AND &H33:IF (C(S) AND 32)=0 THEN SLOT=SLOT OR &H03
60 H=INT(B(S)/256):L=B(S)-H*256:POKE &HFF00+BA+2,H:POKE &HFF00+BA+1,L:POKE &HFFDE,0:POKE 113,0:POKE &HFF00+BA,C(S):POKE &HFF7F,SLOT:EXEC PEEK(&HFFFE)*256+PEEK(&HFFFF)
70 END
100 IF S$="P" THEN FP=FP-12:IF FP>=1 THEN LP=LP-12 ELSE FP=FP+12
110 IF S$="N" THEN FP=FP+12:IF FP<=P THEN LP=LP+12 ELSE FP=FP-12
120 IF LP>P THEN LP=P
130 IF LP<FP+11 AND FP<=P-11 THEN LP=FP+11
140 FOR X=2 TO 14:PRINT @(X*32)+1,STRING$(30,32);:NEXT X:PRINT @65,"";
150 GOTO 40
200 P=PEEK(&HFF80):POKE &HFF80,&H55:POKE &HFF80,&HAA:POKE &HFF80,&H21:POKE &HFF80,&H01:POKE &HFF80,BA:RETURN
10000 DATA "DRIVEWIRE HDBDOS",2,2
10002 DATA "7 Card Stud",7,2
10003 DATA "A Mazing World of Malcom",9,2
10004 DATA "Androne",13,2
10005 DATA "Appliance and Light Cont",15,2
10006 DATA "Arkanoid",15,32
10007 DATA "Art Gallery",23,2
10008 DATA "Atom",24,2
10009 DATA "Audio Spectrum Analyzer",28,2
10010 DATA "Bingo Math",29,2
10011 DATA "Bridge Tutor I",30,2
10012 DATA "Bustout",32,2
10013 DATA "Canyon Climber",33,2
10014 DATA "Castle Guard",35,2
10015 DATA "Castle of Tharoggad",36,2
10016 DATA "Checker King",40,2
10017 DATA "Clowns & Balloons",41,2
10018 DATA "Color Backgammon",43,2
10019 DATA "Color Baseball",44,2
10020 DATA "Color Cubes",46,2
10021 DATA "Color File",47,2
10022 DATA "Color File II",48,2
10023 DATA "Color Logo",52,2
10024 DATA "Color Robot Battle",54,2
10025 DATA "Color Scripsit",56,2
10026 DATA "Color Scripsit II",58,2
10027 DATA "Crosswords",62,2
10028 DATA "Cyrus World Class Chess",63,2
10029 DATA "Deluxe RS-232 Program Pa",67,2
10030 DATA "Demolition Derby",68,2
10031 DATA "Demon Attack 16K",70,2
10032 DATA "Diagnostics",70,2
10033 DATA "Diagnostics V2.0",71,2
10034 DATA "Dino Wars",72,2
10035 DATA "Direct Connect Modem Pak",74,2
10036 DATA "DON-PAN",76,2
10037 DATA "Doubleback",78,2
10038 DATA "Dragon Fire",79,2
10039 DATA "Dungeons of Daggorath",79,2
10040 DATA "EDTASM+",81,2
10041 DATA "Facemaker",85,2
10042 DATA "Fahrfall Pandemic Editio",87,2
10043 DATA "Football",91,2
10044 DATA "Fraction Fever",93,2
10045 DATA "Galactic Attack",95,2
10046 DATA "GFL Championship Footbal",96,32
10047 DATA "Gin Champion",104,2
10048 DATA "Gomoku-Renju",106,2
10049 DATA "Graphic Pak",108,2
10050 DATA "Handyman",111,2
10051 DATA "Hunt The Wumpus",112,2
10052 DATA "Kids on Keys",116,2
10053 DATA "Kindercomp",118,2
10054 DATA "Knight Lore",120,32
10055 DATA "Math Tutor",128,32
10056 DATA "Mega-Bug",128,2
10057 DATA "Microbes",130,2
10058 DATA "Micro Chess V2.0",131,2
10059 DATA "Micro Painter",133,2
10060 DATA "Mind-Roll",134,32
10061 DATA "Monster Maze",142,2
10062 DATA "Music",143,2
10063 DATA "Orchestra 90-CC",144,2
10064 DATA "Panic Button",146,2
10065 DATA "Personal Finance",148,2
10066 DATA "Personal Finance II",150,2
10067 DATA "Pinball",152,2
10068 DATA "Polaris",153,2
10069 DATA "Poltergeist",154,2
10070 DATA "Predator",156,32
10071 DATA "Project Nebula",172,2
10072 DATA "Quasar Commander",174,2
10073 DATA "RAD Warrior",175,32
10074 DATA "Rampage!",183,32
10075 DATA "Reactoid",191,2
10076 DATA "RoboCop",192,32
10077 DATA "Roman Checkers",224,2
10078 DATA "Shanghai",226,2
10079 DATA "Shooting Gallery",230,2
10080 DATA "Silpheed",232,2
10081 DATA "Skiing",236,2
10082 DATA "Slay the Nereis",238,2
10083 DATA "Soko-Ban",240,2
10084 DATA "Space Assault",244,2
10085 DATA "Spectaculator",245,2
10086 DATA "Spidercide",245,2
10087 DATA "Springster",246,2
10088 DATA "Starblaze",250,2
10089 DATA "Stellar Lifeline",252,2
10090 DATA "Super Logo",254,2
10091 DATA "Super Pitfall",258,32
10092 DATA "Temple of ROM",266,2
10093 DATA "Tennis",268,2
10094 DATA "Tetris",269,2
10095 DATA "Thexder",273,2
10096 DATA "TypeMate",277,2
10097 DATA "Typing Tutor",277,2
10098 DATA "Videotex V1.2",278,2
10099 DATA "Wildcatting",279,2
10999 DATA "",-1,-1
59999 END
60000 CLEAR 30,&H3F80
60010 LOADM"BASLOAD"
60020 A=PEEK(25):B=PEEK(26):S=A*256+B
60030 C=PEEK(27):D=PEEK(28):E=C*256+D
60040 T=&H4800:FOR X=S-1 TO E:POKE T,PEEK(X):T=T+1:NEXT X
60050 SAVEM"BASROM",&H4000,T,&H4000:PRINT "LENGTH=";T-&H4000;" ";INT((T-&H4000)/1024+1);"K" 