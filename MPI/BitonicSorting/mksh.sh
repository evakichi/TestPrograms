#!/bin/bash
if [ -z "${1}" ];then
echo Please set select number!!
exit;
fi

if [ -z "${2}" ];then
echo Please set ncpus number!!
exit;
fi

if [ -z "${3}" ];then
echo Please set mpiprocs number!!
exit;
fi

for OUT in bitonic_intel_2019update1.sh bitonic_intelmpi_2019update1.sh bitonic_mvapich2_gnu.sh bitonic_openmpi_pgi1810.sh bitonic_openmpi_gnu.sh bitonic_mpich3_gnu.sh sort_seq.sh ;do
echo \#!/bin/bash > $OUT
N=${OUT/bitonic_/}
N=${N/.sh/.out}
echo \#PBS -N BITONIC.$N >> $OUT
echo \#PBS -q large >> $OUT
echo \#PBS -l walltime=5:49:00 >> $OUT
echo \#PBS -j oe >> $OUT
echo \#PBS -l select=${1}:ncpus=${2}:mpiprocs=${3} >> $OUT
echo " " >> $OUT
echo cd \$PBS_O_WORKDIR >> $OUT
echo _NPROCS=\`cat \$PBS_NODEFILE \| wc -l\` >> $OUT
echo module purge >> $OUT
case $OUT in
 "bitonic_intel_2019update1.sh" ) echo module load intel/2019update1 >> $OUT ;;
 "bitonic_intelmpi_2019update1.sh" ) echo module load intel/2019update1 intelmpi/2019update1 >> $OUT ;;
 "bitonic_mvapich2_gnu.sh" ) echo module load mvapich2/gnu >> $OUT ;;
 "bitonic_openmpi_pgi1810.sh" ) echo module load pgi openmpi/pgi1810 >> $OUT ;;
 "bitonic_openmpi_gnu.sh" ) echo module load openmpi/gnu >> $OUT ;;
 "bitonic_mpich3_gnu.sh" ) echo module load mpich3/gnu >> $OUT ;;
 "sort_seq.sh" ) echo " " >> $OUT ;;
esac 
echo \#export OMP_NUM_THREADS=18 >> $OUT
echo echo \"mpirun ./${OUT/.sh/.out} \" \$\{SIZE\} \$\{_NPROCS\} >> $OUT 
case  $OUT in
 "sort_seq.sh" ) echo ./${OUT/.sh/.out}  \$\{SIZE\}>> $OUT ;;
 *) echo mpirun -n \$_NPROCS -machinefile \$PBS_NODEFILE ./${OUT/.sh/.out}  \$\{SIZE\}  >> $OUT ;; 
esac
done
