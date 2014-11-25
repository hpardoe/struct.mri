# R function to load freesurfer mgh files
# version of load.mgh.R that can read mgh files with a 4th dimension (or frames)
# Heath Pardoe, heath.pardoe@nyumc.org, 11/13/2014

load.mgh <- function(input.file) {
	
	to.read <- file(input.file,"rb")

	v <- readBin(to.read,integer(), endian = "big")
	ndim1 <- readBin(to.read,integer(), endian = "big")
	ndim2 <- readBin(to.read,integer(), endian = "big") 
	ndim3 <- readBin(to.read,integer(), endian = "big") 
	nframes <- readBin(to.read,integer(), endian = "big")
	type <- readBin(to.read,integer(), endian = "big") 
	dof <- readBin(to.read,integer(), endian = "big")
	
	close(to.read)

	to.read <- file(input.file,"rb")
	dump <- readBin(to.read,double(),size = 4,n = 71, endian = "big")
	x <- readBin(to.read,double(),size = 4, n = (ndim1*ndim2*ndim3*nframes), endian = "big")
	close(to.read)
	x.mat <- matrix(data = x, nrow = ndim1, ncol = nframes)
	
	list(x = x.mat,v = v,ndim1 = ndim1,ndim2 = ndim2,ndim3 = ndim3,nframes = nframes,type = type,dof = dof)

}
