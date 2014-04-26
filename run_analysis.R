library(data.table)

# Uses the consistent naming pattern found in the dataset to find features of a particular type,
# such as "mean" or "std". The trick is that features representing a mean are named like "*-mean()*"
# so we grep for features having that pattern:
findIndicesOfFeatureType <- function(type, featureVec) {
    grep(paste('-', type, '\\(\\)', sep=''), featureVec)
}

readRawData <- function(prefix, class) {
    scan(file.path(class, paste(prefix, '_', class, '.txt', sep='')))
}

# Given the matrix in "data" and a data.frame "features" describing the columns we want and their
# names, return a data.frame having only the desired columns from "data", named appropriately.
readFeatures <- function(class, desiredFeatures) {
    rawData <- matrix(readRawData('X', class), ncol=max(features$index), byrow=TRUE)
    ret <- data.table(rawData[,desiredFeatures$index])
    setnames(ret, desiredFeatures$name)
    ret
}

read <- function(class) {
    ret = readFeatures(class, desiredFeatures)
    ret[,subject      := readRawData('subject', class)]
    ret[,activityCode := readRawData('y', class)]
}

# Read in feature names. The data in features.txt amount to the nonexistent column headers for the
# files test/X_test.txt and train/X_train.txt
features <- read.delim('features.txt', sep=' ', header=FALSE,
                col.names=c('index', 'name'),
                colClasses=c('integer', 'character'))

meanFeatures <- features[ findIndicesOfFeatureType('mean', features$name), ]
stdFeatures  <- features[ findIndicesOfFeatureType('std', features$name), ]

# interleave the rows of meanFeatures, stdFeatures
# so that a feature derived from the mean of a signal is (hopefully) immediately followed
# by a feature derived from the standard deviation of the same signal
desiredFeatures <- features[0,]
desiredFeatures[seq(1, by=2, length=dim(meanFeatures)[1]),] <- meanFeatures
desiredFeatures[seq(2, by=2, length=dim(stdFeatures)[1]),]  <- stdFeatures

dat <- rbindlist(list(read('test'), read('train')))

activityLabels <- data.table(read.delim('activity_labels.txt', sep=' ', header=FALSE, 
                    col.names=c('activityCode', 'activityLabel'), 
                    colClasses=c('numeric', 'factor')))

dat <- merge(dat, activityLabels, by="activityCode")
dat[,activityCode:=NULL]
setkey(dat, subject, activityLabel)
means <- dat[,lapply(.SD, mean), by=list(subject, activityLabel)]
