10 CLEAR 1000,&H7FFF:CLS
20 INPUT "FILE TO SPLIT INTO 16K";R$:P=INSTR(R$,"."):IF P>0 THEN E$=MID$(R$,P+1) ELSE E$=""
30 LC$=LEFT$(E$,1):IF LC$>="0" AND LC$<="9" THEN PRINT "PLEASE RENAME THE INPUT FILE SO THE EXTENSION IS NOT NUMERIC.":STOP
40 IF P>0 THEN BN$=LEFT$(R$,P-1) ELSE BN$=""
50 IF BN$="" THEN PRINT "PLEASE RENAME THE FILE SO THAT  THE NAME DOES NOT START WITH A  '.'.":STOP
60 OPEN "D",1,R$,1:FIELD #1,1 AS F$
70 PAD=0:L=LOF(1)
80 IF INT((L+PAD)/128)<>(L+PAD)/128 THEN PAD=PAD+1:GOTO 80
90 IF PAD>0 THEN PRINT "PADDING FILE WITH";PAD;"BYTES.":L=LOF(1):LSET F$=CHR$(255):FOR X=1 TO PAD:PUT #1,L+X:NEXT X
100 NLF=LOF(1):CLOSE #1:PRINT "FILE LENGTH IS NOW";NLF;"BYTES.":PN=1000:RI=1:RO=1
105 FOR W=1 TO 5000:NEXT W
110 PN$=RIGHT$(STR$(PN),3):O$=BN$+"."+PN$:CLS:PRINT "WRITING ";O$
120 OPEN "D",1,R$,128:OPEN "D",2,O$,128:FIELD #1,128 AS FI$:FIELD #2,128 AS FO$
130 PRINT @32,RO*128:GET #1,RI:LSET FO$=FI$:PUT #2,RO:IF RI>=LOF(1) THEN 1000 ELSE RI=RI+1:RO=RO+1:IF RO>128 THEN CLOSE #1:CLOSE #2:PN=PN+1:RO=1:GOTO 110
140 GOTO 130
1000 CLOSE #1:CLOSE #2:PRINT "DONE."

