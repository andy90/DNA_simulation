gmx grompp -f pull.mdp -c start.gro -p topolCMgspce.top -o md.tpr -n index.ndx
gmx mdrun -v -deffnm md -px pullx.xvg -pf pullf.xvg 
