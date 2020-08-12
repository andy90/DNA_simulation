gmx grompp -f npt.mdp -c start_0.gro -p topolPO4Caspce.top -o md.tpr -maxwarn 2
gmx mdrun  -deffnm md -table table.xvg 
