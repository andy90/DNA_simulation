for ((i=0; i<20; i++))
do

  sbatch  $i/sub$i.sh
  for ((j=0; j<100000; j++))
  do
    k=1
  done
done
