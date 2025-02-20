#!/bash/bin -l

source ../../PPIS_list.dat

for i in ${ALL[@]}; do
	echo $i
	obabel -ipdb ../$i'_L'.pdb -omol2 -O $i'_L'.mol2  -p 7.4
done
