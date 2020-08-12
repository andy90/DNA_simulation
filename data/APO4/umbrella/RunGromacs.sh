gmx grompp -f umbrella.mdp -c equil_0.gro -p topolAPO4spce.top -n index.ndx  -o md.tpr -maxwarn 1 
gmx mdrun  -deffnm md -pf pullf_0.xvg -px pullx_0.xvg
