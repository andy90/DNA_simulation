gmx grompp -f npt.mdp -c start_0.gro -p topolTCaspce.top -o md.tpr -maxwarn 2
gmx mdrun  -deffnm md -table table.xvg -tablep table.xvg
