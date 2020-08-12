gmx grompp -f npt.mdp -c start_18.gro -p topolATspce.top -o md.tpr -maxwarn 2
gmx mdrun  -deffnm md -table table.xvg -tablep table.xvg
