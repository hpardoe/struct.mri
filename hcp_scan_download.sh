#!/bin/bash
# first argument text file containing subjects
# second argument acquisition ID eg. T1w_MPR1, 

SUBJECTS=$1
SCAN=$2

for f in `cat $SUBJECTS`
do
	DNAME=$f/unprocessed/3T/$SCAN/
	mkdir -p $DNAME
	s3cmd --config=/home/hpardoe/Dropbox/human.connectome/s3cfg --skip-existing get s3://hcp-openaccess/HCP_900/$f/unprocessed/3T/$SCAN/$f"_3T_"$SCAN".nii.gz" $DNAME
done
