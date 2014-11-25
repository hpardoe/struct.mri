 save.mgh <-function(vol,fname) {

# R translation of save_mgh.m
# written by Heath Pardoe, heath.pardoe@nyumc.org, 09/12/2013

MRI.UCHAR <-  0 
MRI.INT <-    1 
MRI.LONG <-   2 
MRI.FLOAT <-  3 
MRI.SHORT <-  4 
MRI.BITMAP <- 5 
MRI.TENSOR <- 6 
slices <- c(1:256)

fid <- file(fname,open = "wb", blocking = TRUE)

width <- vol$ndim1
height <- vol$ndim2
depth <- vol$ndim3

writeBin(as.integer(1),fid,size = 4, endian = "big")
writeBin(as.integer(width),fid,size = 4, endian = "big")
writeBin(as.integer(height),fid,size = 4, endian = "big")
writeBin(as.integer(depth),fid,size = 4, endian = "big")
writeBin(as.integer(1),fid,size = 4, endian = "big")

# HP note: I've ignored all the diffusion tensor stuff
writeBin(as.integer(MRI.FLOAT),fid,size = 4, endian = "big")

writeBin(as.integer(1),fid,size = 4, endian = "big")
# dof = fread(fid, 1, 'int');
## HP note: ignored ^this line^ from save_mgh.m

UNUSED.SPACE.SIZE <- 256
USED.SPACE.SIZE <- (3*4+4*3*4)  # space for ras transform

unused.space.size <- UNUSED.SPACE.SIZE - 2 

# ignored all the stuff about "M" - could probably do it if necessary so let me know
#if (nargin > 2)
##	 fwrite(fid, 1, 'short')        # ras.good.flag <- 0
#	 writeBin(1,fid,size = 2, endian = "big")
#	 unused.space.size <- unused.space.size - USED.SPACE.SIZE 
##	 fwrite(fid, sizes(1), 'float32')  # xsize
##	 fwrite(fid, sizes(2), 'float32')  # ysize
##	 fwrite(fid, sizes(3), 'float32')  # zsize
#	 
#	 fwrite(fid, M(1,1), 'float32')   # x.r
#	 fwrite(fid, M(2,1), 'float32')   # x.a
#	 fwrite(fid, M(3,1), 'float32')   # x.s

#	 fwrite(fid, M(1,2), 'float32')   # y.r
#	 fwrite(fid, M(2,2), 'float32')   # y.a
#	 fwrite(fid, M(3,2), 'float32')   # y.s

#	 fwrite(fid, M(1,3), 'float32')   # z.r
#	 fwrite(fid, M(2,3), 'float32')   # z.a
#	 fwrite(fid, M(3,3), 'float32')   # z.s

#	 fwrite(fid, M(1,4), 'float32')   # c.r
#	 fwrite(fid, M(2,4), 'float32')   # c.a
#	 fwrite(fid, M(3,4), 'float32')   # c.s
#else
#	 fwrite(fid, 0, 'short')        # ras.good.flag <- 0
	 writeBin(as.integer(0),fid,size = 2, endian = "big")

#   } #

writeBin(as.integer(rep.int(0,unused.space.size)),fid,size = 1)
bpv <- 4    # bytes/voxel						
nelts <- width * height   # bytes per slice 
writeBin(vol$x,fid, size = 4, endian = "big")
close(fid)
}
