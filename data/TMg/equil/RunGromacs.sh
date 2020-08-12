gmx grompp -f npt.mdp -c start_0.gro -p topolTMgspce.top -o md.tpr -maxwarn 1
gmx mdrun  -deffnm md
