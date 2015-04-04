# This is just a basic version that pulls out limited information in a kind of crude way
# Could be done better but hey whatever works

library("XML")

xml.file.list <- list.files("./xml/", pattern="xml$", full.names=T)

xml.list.to.df <- function(input.list) {
	output.df <- data.frame()
	for (i in 1:length(input.list)) {
		print(i)
		output.df <- rbind(output.df, parse.adni.xml(xml.file.list[i]))
	}
	output.df
}

parse.adni.xml <- function(xml.file) {

	doc <- xmlParse(xml.file)
	xmltop <- xmlRoot(doc)
	# study
	study.id <- xmlValue(getNodeSet(doc, "//*/projectIdentifier")[[1]])
	# id
	participant.id <- xmlValue(getNodeSet(doc, "//*/subjectIdentifier")[[1]])
	# age
	age <- as.numeric(xmlValue(getNodeSet(doc, "//*/subjectAge")[[1]]))
	# gender
	gender <- xmlValue(getNodeSet(doc, "//*/subjectSex")[[1]])
	# disease status
	disease.index <- which(xpathApply(doc, "//*/subjectInfo", xmlAttrs, "item") == "DX Group")
	if (length(disease.index)) diagnosis <- xmlValue(getNodeSet(doc, "//*/subjectInfo")[[disease.index]]) else diagnosis <- NA
	
	out.df <- data.frame(study = study.id, id = participant.id, age = age, gender = gender, diagnosis = diagnosis)
	out.df
	
}
