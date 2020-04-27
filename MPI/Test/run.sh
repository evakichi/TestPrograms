#!/bin/bash 
for EXEC in mpitest_intel_2019update1.sh  mpitest_intelmpi_2019update1.sh  mpitest_mpich3_gnu.sh  mpitest_mvapich2_gnu.sh  mpitest_openmpi_gnu.sh  mpitest_openmpi_pgi1810.sh;do
echo ${EXEC} 
qsub ${EXEC}
done
