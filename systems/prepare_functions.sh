#!/bin/bash

#      0     1       2      3     4      5       6     7       8      9       10     11    12      13    14   15    16   17   18    19   20  21   22
ALL=( '5ad2' '5ad3' '5j89' '5j8o' '3bbr' '6mg5' '3m50' '6ygj' '5fqd'  '3m51' '2o98' '4mdk' '1kkq'  5t35 6bn7  6boy  6sis 6hay 6hr2 7jto 7jtp 6nv2 6nv3)
Ae=(  129    127     117    117    264    215    232    229    390     232    240    179     269   144  384   384   149  151  149  148  143  236  236)
Bs=(  130    128     118    118    265    216    233    230    392     233    241    180     270   145  385   385   150  152  150  149  144  237  237)
Be=(  258    253     234    234    528    430    263    249    685     263    292    255     288   255  511   511   260  266  269  451  446  245  245)
L=(   259    254     235    235    529    431    264    250    686     264    293    256     289   256  512   512   261  267  270  452  447  246  246)
     
# Variables 
current=$(pwd)
PDB_dir=$current/ALB_pdbs
wat_py=$current/template/write_input_holo.py
wat2_py=$current/template/write_input2_holo.py
# functions

 # Preparation
prepare () {
# prepare 1kkq_A.pdb 
local PDBID=$1
local COMPLEX=$2

# water (opc)
python3 $wat_py -id $PDBID -c $COMPLEX -sr cso sep 
tleap -f $COMPLEX'_1.in'
python3 $wat2_py -id $PDBID -c $COMPLEX -sr cso sep
tleap -f $COMPLEX'_2.in'

}


prepare_trimer (){
# prepare_dimer 1kkq
local pdbid=$1
cat $PDB_dir/$pdbid'_A.pdb' > $pdbid'_ALB.pdb'
echo 'TER' >> $pdbid'_ALB.pdb'
cat $PDB_dir/$pdbid'_B.pdb' >> $pdbid'_ALB.pdb'
echo 'TER' >> $pdbid'_ALB.pdb'
cat $PDB_dir/$pdbid'_L.pdb' >> $pdbid'_ALB.pdb'
pdb4amber -i $pdbid'_ALB.pdb' -o $pdbid'_ALB_amber.pdb'
prepare $pdbid $pdbid'_ALB'
}

# mmgbsa

split () {
	local prm=$1
	local nc=$2
	local cpptraj=$3
	local resid=$4
	local complex=$5
	local run=$6

	echo '' > $cpptraj
	echo 'strip !(:'$resid')' >> $cpptraj
	echo 'autoimage' >>$cpptraj
	echo 'trajout '$complex'_'$run'.nc'  >> $cpptraj
	echo 'run' >> $cpptraj
	echo 'clear trajin action' >> $cpptraj
	echo 'parmstrip !(:'$resid')' >> $cpptraj
	echo 'parmwrite out '$complex'.prmtop' >> $cpptraj
	cpptraj -i $cpptraj -p $prm -y $nc

}

split_AB (){

### monomer
local A_res='1-'$1
local B_res=$2'-'$3
### binary
local AB_res=$A_res','$B_res

local resids=( $AB_res  $A_res $B_res )
local complexes=(  AB         A      B  )

local path=$4
local name=$5
local prm=$path''$name.prmtop

for run in  $(seq 1 10);do
        for i in $(seq 0 6 );do
        local cpptraj=split_${complexes[$i]}.cpptraj
        if [ $i -eq 0 ]; then
		local prm=$path''$name.prmtop
        	local nc=$path''$name'_298K/'$name'_prod'$run.nc
	        split $prm $nc $cpptraj ${resids[$i]} ${complexes[$i]} $run
	        local nc='AB_'$run'.nc'
	        local prm='AB.prmtop'
        else
	        split $prm $nc $cpptraj ${resids[$i]} ${complexes[$i]} $run
	fi

        if [ $run -eq 1  ]; then
	        ante-MMPBSA.py -p $prm -s '!(:'${resids[$i]}')' -c ${complexes[$i]}'_mbondi2.prmtop' --radii mbondi2
        fi
	done
done
}

split_complex (){
#               1  2  3  4  5     6
# split_complex AE BG BE LI path  name
### monomer
local A_res='1-'$1
local B_res=$2'-'$3
local L_res=$4
### binary
local AB_res=$A_res','$B_res
local AL_res=$A_res','$L_res
local LB_res=$B_res','$L_res
### ternary
local ALB_res=$A_res','$B_res','$L_res

#                  0        1      2       3       4       5       6
local resids=(    $ALB_res  $A_res $B_res $L_res $AB_res $AL_res $LB_res  )
local complexes=(  ALB         A      B      L      AB      AL       BL   )
# variables 
local path=$5
local name=$6
for run in $(seq 1 10);do
	for i in $(seq 0 6);do
  		local cpptraj=split_${complexes[$i]}.cpptraj
		if [ $i -eq 0 ]; then
			local prm=$path''$name.prmtop
			local nc=$path''$name'/'$name'_prod'$run.nc 
		        split $prm $nc $cpptraj ${resids[$i]} ${complexes[$i]} $run
			# local nc='ALB_'$run'.nc'
			# local prm='ALB.prmtop'
		else
			split $prm $nc $cpptraj ${resids[$i]} ${complexes[$i]} $run
		fi

		if [ $run -eq 1  ]; then
     			# split $prm $nc $cpptraj ${resids[$i]} ${complexes[$i]} $run
			# local prm=$path''$name.prmtop
			ante-MMPBSA.py -p $prm -s '!(:'${resids[$i]}')' -c ${complexes[$i]}'_mbondi2.prmtop' --radii mbondi2
		fi
	done

done

}

run_gbnsr6 () {
### monomer
local A_res='1-'$1
local B_res=$2'-'$3
local L_res=$4
### binary
local AB_res=$A_res','$B_res
local AL_res=$A_res','$L_res
local LB_res=$B_res','$L_res
### ternary
local ALB_res=$A_res','$B_res','$L_res
local path=$5
local name=$6
# script 
local py='./endpoint/template/read_gbnsr6.py'
local in='./endpoint/template/gbnsr6.in'
#                  0       1     2      3        4     5       6
local resids=( $ALB_res  $A_res $B_res $L_res $AB_res $AL_res $LB_res )
local complexes=(  ALB    A      B      L      AB      AL       BL     )
for i_complex in $(seq 0 6 ); do
	# Strip molecule 
	local nc=$path''
	local complex=${complexes[$i_complex]}
	local cpptraj=$complex.cpptraj
	echo 'strip !(:'${resids[$i_complex]}')' > $cpptraj 
	echo 'trajout '${complexes[$i_complex]}'_min2.rst'  >> $cpptraj
	cpptraj -i $cpptraj -p $path''$name.prmtop -y $path/$name'_min2.rst'
	
	# Do gbnsr6 calculation
        gbnsr6  -O -p $complex'.prmtop' -c $complex'_min2.rst' -i $in -o $complex'_gbnsr6.out'
	python3 $py $complex'_gbnsr6.out' $complex'_gbnsr6.npy'
	rm $complex'_gbnsr6.out'
	ambpdb -p $complex'.prmtop' -c $complex'_min2.rst'  > $complex'.pdb'
done
}
		
submit_job (){
	  #            1   
          # submit_job name

####               0      1      2      3       4        5      6
local complexes=(  ALB    A      B      L      AB      AL       BL    )
local name=$1
local sh_in=$2
local current=$(pwd)
for run in $(seq 1 10  ); do
	mkdir run$run
	cd run$run
	for i_complex in $(seq 0 6 ); do
		complex=${complexes[$i_complex]}
		pwd
		sh=$sh_in'_'$complex'.sh'
        	cp ../../../template/$sh_in'.sh' ./$sh
       		sed -i 's/XXX/'$name'/g' $sh
        	sed -i 's/RUN/'$run'/g' $sh 
		sed -i 's/COMPLEX/'$complex'/g' $sh	
		if [ "$i_complex" -eq  "0" ]; then
		ID=$(sbatch --parsable $sh)
		else
		ID=$(sbatch --parsable --dependency=afterany:$ID $sh)
		fi
	done
	cd $current
done
}

calc_rmsd () {

local A_res='1-'$1
local B_res=$2'-'$3
local L_res=$4
### binary
local AB_res=$A_res','$B_res
local AL_res=$A_res','$L_res
local LB_res=$B_res','$L_res
### ternary
local ALB_res=$A_res','$B_res','$L_res

#           0    1      2       3       4       5       6
local resids=( $A_res $B_res $L_res $AB_res $AL_res $LB_res $ALB_res )
local complexes=(  A      B      L      AB      AL       BL     ALB      )
# variables 
local path=$5
local name=$6
local prm=$path''$name.prmtop

cpptraj=rmsd.cpptraj
echo '' > $cpptraj
for run in $(seq 1 10); do
	local nc=$path''$name'/'$name'_prod'$run.nc
	echo 'trajin '$nc >> $cpptraj
	echo 'align :'$AB_res >> $cpptraj
	echo 'rmsd :'$A_res ' nofit out rmsd_A_'$run'.dat' >> $cpptraj
        echo 'rmsd :'$B_res ' nofit out rmsd_B_'$run'.dat' >> $cpptraj
        echo 'rmsd :'$L_res ' nofit out rmsd_L_'$run'.dat' >> $cpptraj
	echo 'run' >> $cpptraj
	echo 'clear trajin action' >> $cpptraj
done
cpptraj -i $cpptraj -p $path''$name.prmtop

}

get_interface_water (){

local name=$1
local prm=$2
local nc=$3
local prm_out=$4
local nc_out=$5
local n=$6
cut=0.5
# modify chain to A and B
intmask=$(cat ../intmask/$name"_intmask.txt")

# get closest
echo "autoimage" > cloest.cpptraj
echo "center @CA,C,N mass origin" >> cloest.cpptraj
echo "image origin center" >> cloest.cpptraj
echo "strip :Cl-,:Na+" >> cloest.cpptraj
echo "strip @EPW" >> cloest.cpptraj # Get 3 point water becasue mmpbsa/mmgbsa don't do off-site charges
echo "closest $n $intmask noimage parmout "$prm_out >> cloest.cpptraj
echo "trajout "$nc_out >> cloest.cpptraj
cpptraj -i cloest.cpptraj -p $prm -y $nc

rm chainAB.pdb *.py cloest.cpptraj
}

PDB_mbondi_gen () {
# Gen pdb 
local pdbid=$1
local name=$2
local water=$3
echo "trajin "$name"_1.nc 1 1" > pdbgen.cpptraj
echo "trajout "$name".pdb" >> pdbgen.cpptraj
cpptraj -i pdbgen.cpptraj -p $name.prmtop

# Gen mbondi prmtop
echo "source leaprc.protein.ff19SB" > leap.in
echo "source leaprc.water."$water >> leap.in
echo "source leaprc.gaff2" >> leap.in
echo "loadAmberPrep ../../special_residue/cso.prepin" >> leap.in
echo "loadAmberParams ../../special_residue/frcmod2.cso" >> leap.in
echo "loadAmberParams ../../special_residue/frcmod1.cso" >> leap.in
echo "loadAmberPrep ../../special_residue/sep.prepin" >> leap.in
echo "loadAmberParams ../../special_residue/frcmod2.sep" >> leap.in
echo "loadAmberParams ../../special_residue/frcmod1.sep" >> leap.in
echo "loadamberparams ../../Ligands/"$pdbid"_gaff2.frcmod" >> leap.in
echo "loadoff ../../Ligands/"$pdbid"_gaff2.lib"  >> leap.in
echo "set default PBRadii mbondi2" >> leap.in
echo "m = loadpdb $name.pdb" >> leap.in 
echo "saveamberparm m "$name"_"$water"_mbondi2.prmtop "$name"_"$water"_mbondi2.rst" >> leap.in
echo "quit" >> leap.in
tleap -f leap.in


}

change_charge (){
local complex=$1

cp ../../template/change_water_charge.parmed .
sed -i 's/XXX/'$complex'/g' change_water_charge.parmed
parmed -i change_water_charge.parmed
}

split_with_n_water (){

local n=$1
### monomer
local w_res=$(($4+1))'-'$(($4+$n))
local A_res='1-'$2','$w_res
local B_res=$3'-'$4
local L_res=$5
### binary
local AB_res=$A_res','$B_res
local AL_res=$A_res','$L_res
local LB_res=$B_res','$L_res
### ternary
local ALB_res=$A_res','$B_res','$L_res

#                  0        1      2       3       4       5       6
local resids=(    $ALB_res  $A_res $B_res $L_res $AB_res $AL_res $LB_res  )
local complexes=(  ALB         A      B      L      AB      AL       BL   )
# variables 
local path=$6
local name=$7
local pdbid=$8 

for run in $(seq 1 10);do
	for i in $(seq 0 6);do
	local cpptraj=split_${complexes[$i]}.cpptraj
	if [ $i -eq 0 ]; then
		local nc=$path''$name'_298K/'$name'_prod'$run.nc 
		local prm=$path''$name.prmtop
		get_interface_water $name $prm $nc 'ALB.prmtop' 'ALB_'$run'.nc' $n
		local nc='ALB_'$run'.nc'
		local prm='ALB.prmtop'
		else
		split $prm $nc $cpptraj ${resids[$i]} ${complexes[$i]} $run
	fi
	if [ $run -eq 1  ]; then
		#ante-MMPBSA.py -p $prm -s '!(:'${resids[$i]}')' -c ${complexes[$i]}'_mbondi2.prmtop' --radii mbondi2
		PDB_mbondi_gen $pdbid ${complexes[$i]} opc3 
		change_charge ${complexes[$i]}
	fi
	done
done
}
