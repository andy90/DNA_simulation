gmx grompp -f npt.mdp -c start_0.gro -p topolNO3Mgspce.top -o md.tpr -maxwarn 2
gmx mdrun  -deffnm md -table table.xvg -tablep table.xvg
