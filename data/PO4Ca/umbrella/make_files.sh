rm tpr-files.dat pullx-files.dat pullf-files.dat
for ((i=0; i<25; i++))
do
    echo umbrella_$i.tpr >> tpr-files.dat
    echo pullx_$i.xvg >> pullx-files.dat
    echo pullf_$i.xvg >> pullf-files.dat
done
