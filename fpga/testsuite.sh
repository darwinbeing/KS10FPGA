#!/bin/sh

#
# Script to execute the regressions tests
#

FILES="\
    DSKAA
    DSKAB
    DSKAC
    DSKAD
    DSKAE
    DSKAF
    DSKAG
    DSKAH
    DSKAI
    DSKAJ
    DSKAK
    DSKAL
    DSKAM
    DSKCA
    DSKCB
    DSKCC
    DSKCD
    DSKCE-RD00
    DSKCF-RD00
    DSKDA-RD00
    DSKEA-RD00
    DSKEB-RD00
    DSKEC-RD00
    DSKFA
    DSUBA-RD00
    DSDZA-RD00
    DSRPA-RD00
    DSMMA
    DSMMB
    DSMMC
    DSMMD
    DSKCG
"

DIR=testsuite
RESFILE=results_`date '+%y%m%d_%H%M'`.txt
PREFIX=MAINDEC-10-

RED='\e[0;31m'
GRN='\e[0;32m'
END='\e[0m'

date "+Testing performed on %a, %b %d %Y." | tee ${RESFILE}
if [ ! -f esm_top/testbench/ssram.awk ]; then
    co -q "esm_top/testbench/ssram.awk"
fi

date "+[%r] Testing started." | tee -a ${RESFILE}
for FILE in ${FILES}
do
    if [ ! -f ../maindec/${PREFIX}${FILE}.SEQ ]; then
        co -q "../maindec/${PREFIX}${FILE}.SEQ"
    fi
    date "+[%r] Testing ${FILE}$" | tr $ \\t | tr -d \\n | expand -t 20 | tee -a ${RESFILE}
    make -B -s DIAG=${FILE} ${DIR}/${FILE}.vvp 2> /dev/null > /dev/null
    RETVAL=$?
    if [ ${RETVAL} -eq 0 ]; then
        vvp -n ${DIR}/${FILE}.vvp > ${DIR}/${FILE}.txt
        if grep -q "Test Completed" ${DIR}/${FILE}.txt; then
            echo -e "${GRN}Test Pass${END}" | tee -a ${RESFILE}
        else
            echo -e "${RED}Test Fail${END}" | tee -a ${RESFILE}
        fi
        tail -n 6 ${DIR}/${FILE}.txt >> ${RESFILE}
    else
        echo -e "${RED}Build Fail${END}" | tee -a ${RESFILE}
    fi
done
date "+[%r] Testing completed." | tee -a ${RESFILE}
