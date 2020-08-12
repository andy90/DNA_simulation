for ((i=0; i<25; i++))
do
        echo "#!/bin/bash"  > sub$i.sh
        echo "#SBATCH -N 1" >> sub$i.sh
        echo "#SBATCH -n 2" >> sub$i.sh
        echo "#SBATCH --time=48:00:00" >> sub$i.sh
        echo "#SBATCH --constraint=centos7" >> sub$i.sh
        echo "#SBATCH -p  sched_mit_arupc_long" >> sub$i.sh
	echo "cd /nobackup1c/users/anggao/BasePair/PO4Ca_GT/umbrella/$i"  >> sub$i.sh
	echo "/home/anggao/Gromacs5/bin/gmx grompp -f umbrella.mdp -p topolPO4Caspce.top -n index.ndx -c equil_$i.gro -o md.tpr -maxwarn 2" >> sub$i.sh
	echo "/home/anggao/Gromacs5/bin/gmx mdrun -nt 2  -deffnm md -table table.xvg -pf pullf.xvg -px pullx.xvg" >> sub$i.sh
        echo "mv md.xtc umbrella_$i.xtc" >> sub$i.sh
        echo "mv md.gro final_$i.gro" >> sub$i.sh
done
