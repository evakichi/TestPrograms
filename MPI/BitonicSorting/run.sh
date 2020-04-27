#!/bin/bash 
if [ -z "$1" ];then
 echo Please set tne array size!!
 exit
fi
for EXEC in psrs_intel_2019update1.sh  psrs_intelmpi_2019update1.sh  psrs_mpich3_gnu.sh  psrs_mvapich2_gnu.sh  psrs_openmpi_gnu.sh  psrs_openmpi_pgi1810.sh sort_seq.sh;do
SIZE=${1}
echo ${EXEC} ${SIZE}
qsub -v SIZE=${SIZE} ${EXEC}
done
