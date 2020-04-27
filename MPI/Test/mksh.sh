for OUT in mpitest_intel_2019update1.sh mpitest_intelmpi_2019update1.sh mpitest_mvapich2_gnu.sh mpitest_openmpi_pgi1810.sh mpitest_openmpi_gnu.sh mpitest_mpich3_gnu.sh;do
echo \#!/bin/bash > $OUT
N=${OUT/mpitest_/}
N=${N/.sh/.out}
echo \#PBS -N MPITEST.$N >> $OUT
echo \#PBS -q large >> $OUT
echo \#PBS -l walltime=5:49:00 >> $OUT
echo \#PBS -j oe >> $OUT
echo \#PBS -l select=15:ncpus=4:mpiprocs=16 >> $OUT
echo " " >> $OUT
echo cd \$PBS_O_WORKDIR >> $OUT
echo _NPROCS=\`cat \$PBS_NODEFILE \| wc -l\` >> $OUT
echo module purge >> $OUT
case $OUT in
 "mpitest_intel_2019update1.sh" ) echo module load intel/2019update1 >> $OUT ;;
 "mpitest_intelmpi_2019update1.sh" ) echo module load intel/2019update1 intelmpi/2019update1 >> $OUT ;;
 "mpitest_mvapich2_gnu.sh" ) echo module load mvapich2/gnu >> $OUT ;;
 "mpitest_openmpi_pgi1810.sh" ) echo module load pgi openmpi/pgi1810 >> $OUT ;;
 "mpitest_openmpi_gnu.sh" ) echo module load openmpi/gnu >> $OUT ;;
 "mpitest_mpich3_gnu.sh" ) echo module load mpich3/gnu >> $OUT ;;
esac 
echo \#export OMP_NUM_THREADS=18 >> $OUT
echo echo \"mpirun ./${OUT/.sh/.out} \" \$\{_NPROCS\} >> $OUT 
echo mpirun -n \$_NPROCS -machinefile \$PBS_NODEFILE ./${OUT/.sh/.out}  >> $OUT 
done
