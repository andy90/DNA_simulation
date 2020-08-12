gmx grompp -f npt.mdp -c start_18.gro -p topolATspce.top -o md.tpr -maxwarn 1
gmx mdrun  -deffnm md
