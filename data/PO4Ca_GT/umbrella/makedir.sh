for ((i=0; i<25; i++))
do
        rm -rf $i
 	mkdir $i
	cp -r table.xvg equil_$i.gro umbrella.mdp *.top *.itp amber*  index.ndx $i
        mv sub$i.sh $i
#        cp -r equil_$i.gro $i
done
