#!/bin/bash  
#SBATCH -N 1  
#SBATCH -n 4
#SBATCH --time=03:00:00
#SBATCH --constraint=centos7
#SBATCH -p sched_mit_arupc_long

for ((i=0; i<18; i++))
do
   /home/anggao/Gromacs5/bin/gmx grompp -f npt.mdp -c start_$i.gro -p topolATspce.top -o md.tpr -maxwarn 1
   /home/anggao/Gromacs5/bin/gmx mdrun -nt 4  -deffnm md
   cp md.gro equil_$i.gro
   rm -rf md*
done
