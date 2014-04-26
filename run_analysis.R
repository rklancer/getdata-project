# Uses the consistent naming pattern found in the dataset to find features of a particular type,
# such as "mean" or "std". The trick is that features representing a mean are named like "*-mean()*"
# so we grep for features having that pattern:
findIndicesOfFeatureType <- function(type, featureVec) {
    grep(paste('-', type, '\\(\\)', sep=''), featureVec)
}

# for speed, read X_test and X_train into vectors using scan(), and turn it into a matrix
readFeatureMatrix <- function(fname) {
    matrix(scan(fname), ncol=max(features$index), byrow=TRUE)
}

# given the matrix in "data" and a data.frame "features" describing the columns we want and their
# names, return a subset of "data" having only the desired columns and
extractAndNameFeatures <- function(data, desiredFeatures) {
    ret <- data.frame(data[,c(desiredFeatures$index)])
    names(ret) <- c(desiredFeatures$name)
    ret
}

# Read in feature names. The data in features.txt amount to the nonexistent column headers for the
# files test/X_test.txt and train/X_train.txt
features <- read.delim('features.txt', sep=' ', header=FALSE,
                col.names=c('index', 'name'),
                colClasses=c("integer", "character"))

meanFeatures <- features[ findIndicesOfFeatureType('mean', features$name), ]
stdFeatures  <- features[ findIndicesOfFeatureType('std', features$name), ]
desiredFeatures <- rbind(meanFeatures, stdFeatures)

# TODO. rbind these directly or rm() them after rbinding, for memory
X_test_head  <- extractAndNameFeatures(readFeatureMatrix('test/X_test_head.txt'),   desiredFeatures)
X_train_head <- extractAndNameFeatures(readFeatureMatrix('train/X_train_head.txt'), desiredFeatures)
