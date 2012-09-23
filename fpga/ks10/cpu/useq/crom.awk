BEGIN {
    A["0"]="000";
    A[1]="001";
    A[2]="010";
    A[3]="011";
    A[4]="100";
    A[5]="101";
    A[6]="110";
    A[7]="111";
    FS="[, ;]";
}

/U [0-7][0-7][0-7][0-7], / {
    #print $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12 "// " $2
    i = strtonum("0" $2)
    MAP2[i]  = $2;
    MAP[4,i]  = $4;
    MAP[5,i]  = $5;
    MAP[6,i]  = $6;
    MAP[7,i]  = $7;
    MAP[8,i]  = $8;
    MAP[9,i]  = $9;
    MAP[10,i] = $10;
    MAP[11,i] = $11;
    MAP[12,i] = $12;
}

END {
    for (i = 0; i < 04000; i++) {
	if (strtonum("0" MAP2[i]) == i) {
	    #print "#" i "#"  " " MAP[4,i] " " MAP[5,i] " " MAP[6,i] " " MAP[7,i] " " MAP[8,i] " " MAP[9,i] " " MAP[10,i] " " MAP[11,i] " " MAP[12,i]
	    for (j = 4; j <= 12; j++) {
		for (k = 1; k <= 4; k++) {
		    printf A[substr(MAP[j, i], k, 1)]
		}
	    }
	    printf "\n"
	} else {
	    printf "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000\n"
	}
    }
}
