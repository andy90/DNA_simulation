gmx grompp -f umbrella.mdp -c equil_0.gro -p topolGCspce.top -n index.ndx  -o md.tpr -maxwarn 2 
gmx mdrun  -deffnm md -pf pullf_0.xvg -px pullx_0.xvg -table table.xvg -tablep table.xvg
