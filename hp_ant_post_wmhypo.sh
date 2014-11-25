#!/bin/bash
#This script measures the distribution of the "white matter hypointensity" label, derived using the Freesurfer processing stream, along the anterior-posterior axis of the brain.
# It requires the FSL v5.* software package and Freesurfer to run
#If you use this script please cite this paper
#Pardoe, H.R., Mandelstam, S.A., Kucharsky Hiess, R., Kuzniecky, R.I. and Jackson, G. (2015) Quantitative assessment of corpus callosum morphology in periventricular nodular heterotopia, Epilepsy Research, 109: 40-47
#Heath Pardoe, 11/24/2014, heath.pardoe@nyumc.org


# first argument Freesurfer processing directory
FSDIR=$1
# second directory output directory name
OUTDIR=$2

if [ ! -d "$OUTDIR" ]; then
  mkdir $OUTDIR
fi

# MNI152 T1 1mm template brain location
MNI152=/usr/share/data/fsl-mni152-templates/MNI152_T1_1mm_brain

# convert structural MRI and aseg label images into nifti format
#mri_convert norm.mgz norm.nii
#mri_convert aseg.mgz aseg.nii
echo convert norm.mgz and aseg.mgz to nifti
mri_convert $FSDIR"/mri/norm.mgz" $OUTDIR"/norm.nii"
mri_convert $FSDIR"/mri/aseg.mgz" $OUTDIR"/aseg.nii"

HOME=`pwd`
cd $OUTDIR
# extract white matter hypointensity label
echo extract white matter hypointensity label
fsl5.0-fslmaths aseg.nii -thr 77 -uthr 77 wmhypo.nii

# estimate affine transform of structural MRI to MNI space
echo estimate affine transform to MNI152 template
fsl5.0-flirt -in norm.nii -ref $MNI152 -usesqform -omat norm2mni.mat -out reg_norm

# apply estimated transform to wmhypointensity image
fsl5.0-flirt -in wmhypo -ref $MNI152 -applyxfm -init norm2mni.mat -out reg_wmhypo

if [ -f wmhypo_area_slice.csv ]; then
	rm wmhypo_area_slice.csv
done

# measure area of white matter hypointensity label in each slice
echo "measure area of white matter hypointensity label in each coronal slice"
for ((f=0; f<=217; f+=1))
do
	fsl5.0-fslroi reg_wmhypo.nii.gz temp 0 256 0 256 $f 1
#	fsl5.0-fslstats temp -V | cut -f 2 -d" "
	fsl5.0-fslstats temp -V | cut -f 2 -d" " >> wmhypo_area_slice.csv
done

cd $HOME

# to check if subject brain has coregistered with MNI brain properly run this:
#fslview /usr/share/data/fsl-mni152-templates/MNI152_T1_1mm_brain reg_norm.nii.gz
