# translation of read_label.m
# input.file <- "/usr/local/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0/freesurfer/subjects/fsaverage/label/lh.cortex.label"

read.label <- function(input.file) {
	read.table(file = input.file, header = F, skip = 2, col.names = c("vertex","x","y","z","stat"))
}
