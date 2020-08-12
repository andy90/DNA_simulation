gmx grompp -f npt.mdp -c start_0.gro -p topolAPO4spce.top -o md.tpr -maxwarn 1
gmx mdrun  -deffnm md
