#!/bin/bash

current=$(pwd)
source ../prepare_functions.sh
ENV='wat'


for i_name in $(seq 0 22);do
	name=${ALL[$i_name]}
        echo $name
        mkdir $name
        cd $name
	path=../../simulations/$name/
	split_complex ${Ae[$i_name]} ${Bs[$i_name]} ${Be[$i_name]} ${L[$i_name]} $path $name
        cd ..
done

