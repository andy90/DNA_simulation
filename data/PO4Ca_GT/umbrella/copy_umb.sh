for ((i=0; i<25; i++))
do
  cp $i/pullx.xvg ./pullx_$i.xvg
  cp $i/pullf.xvg ./pullf_$i.xvg
  cp $i/md.tpr ./umbrella_$i.tpr
done
