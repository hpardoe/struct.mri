Miscellaneous scripts for analysis of structural MRI data

hp_ant_post_wmhypo.sh
A script for measuring the anterior-posterior distribution of the freesurfer white matter hypointensity label. I used to it to measure the distribution of heterotopic GM nodules in people with periventricular nodular heterotopia, providing quantitative evidence that these nodules are mainly posterior (see http://www.sciencedirect.com/science/article/pii/S0920121114002897/). This is set up to run on my computer which runs the version of FSL provided by neurodebian, so fsl commands are all prefixed with "fsl5.0-"

load.mgh.R
loads Freesurfer mgh files into R

save.mgh.R 
saves mgh files from R

read.label.R
read Freesurfer label files into R

vertex.wise.equivalence.R
carry out vertex-wise equivalence testing analyses on Freesurfer-derived morphometric estimates. See https://sites.google.com/site/hpardoe/equivalence for instructions and https://peerj.com/preprints/808v1/ for a paper about it.
