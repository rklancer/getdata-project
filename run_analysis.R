library(dplyr)

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

# Given the matrix in "data" and a data.frame "features" describing the columns we want and their
# names, return a data.frame having only the desired columns from "data", named appropriately.
extractAndNameFeatures <- function(data, desiredFeatures) {
    ret <- data.frame(data[,c(desiredFeatures$index)])
    names(ret) <- c(desiredFeatures$name)
    ret
}

pathFor <- function(prefix, class) {
    file.path(class, paste(prefix, '_', class, '_head', '.txt', sep=''))
}

read <- function(class) {
    cbind(
        subject      = scan(pathFor('subject', class)),
        activityCode = scan(pathFor('y', class)),
        class        = as.factor(class),
        extractAndNameFeatures(readFeatureMatrix(pathFor('X', class)), desiredFeatures)
    )
}

# Read in feature names. The data in features.txt amount to the nonexistent column headers for the
# files test/X_test.txt and train/X_train.txt
features <- read.delim('features.txt', sep=' ', header=FALSE,
                col.names=c('index', 'name'),
                colClasses=c('integer', 'character'))

meanFeatures <- features[ findIndicesOfFeatureType('mean', features$name), ]
stdFeatures  <- features[ findIndicesOfFeatureType('std', features$name), ]
desiredFeatures <- rbind(meanFeatures, stdFeatures)

X_head <- rbind(read('test'), read('train'))

