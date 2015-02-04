library("equivalence")

# modify these to point to wherever you've downloaded the functions
source("./load.mgh.R")
source("./read.label.R")
source("./save.mgh.R")

vertex.wise.equivalence <- function(subject.df,equivalence.margin.percent = 5, surface.file = "lh.thickness.fwhm10.fsaverage.mgh", subjects.dir="./equivalence.coil.thickness.surfaces") {

	num.subjects <- dim(subject.df)[1]
	vertex.array <- array(dim = c(num.subjects,163842,2))
	freesurfer.home <- Sys.getenv("FREESURFER_HOME")
	hemisphere <- strsplit(surface.file, split = "\\.")[[1]][1]
	label.name <- paste(paste(freesurfer.home,"/subjects/fsaverage/label",hemisphere,sep="/"),"cortex.label",sep=".")

	for (i in 1:num.subjects) {
	# read in 20ch data
	surface.file.20ch <- paste(subjects.dir,head.coil.subject.df$V1[i],"surf",surface.file,sep="/")
	temp.20ch <- load.mgh(surface.file.20ch)	
	vertex.array[i,,1] <- temp.20ch$x
	# read in 32ch data
	surface.file.32ch <- paste(subjects.dir,head.coil.subject.df$V2[i],"surf",surface.file,sep="/")
	temp.32ch <- load.mgh(surface.file.32ch)	
	vertex.array[i,,2] <- temp.32ch$x
	}

	tost.p.val.vector <- vector(length = 163842, mode = "numeric")
	ttest.p.val.vector <- vector(length = 163842, mode = "numeric")

	pb <- txtProgressBar(min = 0, max = 163842, style = 3)
	for (i in 1:163842) {
	# set equivalence margin to 5% of mean value in that vertex
	equivalence.margin <- (equivalence.margin.percent/100)*(mean(c(vertex.array[,i,1],vertex.array[,i,2])))
	tost.results <- tryCatch(tost(vertex.array[,i,1],vertex.array[,i,2],alpha = 0.05, epsilon = equivalence.margin, paired = T), error=function(e) NA)
	ttest.results <- t.test(vertex.array[,i,1],vertex.array[,i,2],alpha = 0.05, paired = T)
	if (length(tost.results) > 1) tost.p.val.vector[i] <- tost.results$p.value else tost.p.val.vector[i] <- NA
	ttest.p.val.vector[i] <- ttest.results$p.value
	setTxtProgressBar(pb,i)
#	if (is.na(tost.results)) p.val.vector[i] <- NA else p.val.vector[i] <- tost.results$p.value
	}
	close(pb)

	cortex.label <- read.label(label.name)
	not.cortex <- setdiff(1:163842, cortex.label$vertex)

	tost.p <- tost.p.val.vector[ cortex.label$vertex ]
	tost.p[ not.cortex ] <- NA
	ttest.p <- ttest.p.val.vector[ cortex.label$vertex ]
	ttest.p[ not.cortex] <- NA

	list(tost.p = tost.p,ttest.p = ttest.p, template.surface = temp.20ch)

}
