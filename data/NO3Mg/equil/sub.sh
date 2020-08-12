#!/bin/bash  
#SBATCH -N 1  
#SBATCH -n 16
#SBATCH --time=03:00:00
#SBATCH --constraint=centos7
#SBATCH -p sched_mit_arupc_long

for ((i=0; i<20; i++))
do
   /home/anggao/Gromacs5/bin/gmx grompp -f npt.mdp -c start_$i.gro -p topolNO3Mgspce.top -o md.tpr -maxwarn 1
   /home/anggao/Gromacs5/bin/gmx mdrun  -deffnm md
   cp md.gro equil_$i.gro
   rm -rf md*
done
