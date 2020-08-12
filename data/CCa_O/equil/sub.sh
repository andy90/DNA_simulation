#!/bin/bash  
#SBATCH -N 1  
#SBATCH -n 8
#SBATCH --time=03:00:00
#SBATCH --constraint=centos7
#SBATCH -p sched_mit_arupc_long

for ((i=0; i<20; i++))
do
   /home/anggao/Gromacs5/bin/gmx grompp -f npt.mdp -c start_$i.gro -p topolCCaspce.top -o md.tpr -maxwarn 1
   /home/anggao/Gromacs5/bin/gmx mdrun -nt 8  -deffnm md
   cp md.gro equil_$i.gro
   rm -rf md*
done
