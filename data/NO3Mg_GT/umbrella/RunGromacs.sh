gmx grompp -f umbrella.mdp -c equil_0.gro -p topolNO3Mgspce.top -n index.ndx  -o md.tpr -maxwarn 1 
gmx mdrun  -deffnm md -table table.xvg -tablep table.xvg -pf pullf_0.xvg -px pullx_0.xvg
