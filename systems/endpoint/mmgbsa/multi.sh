#!/bin/bash

current=$(pwd)
source ../../prepare_functions.sh
ENV='wat'


for i_name in $(seq 0 2 );do
	name=${ALL[$i_name]}
        mkdir $name
        cd $name
	submit_job $name mmgbsa
        cd $current
done

