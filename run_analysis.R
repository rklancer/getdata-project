# Uses the consistent naming pattern found in the dataset to find features of a particular type,
# such as "mean" or "std". The trick is that features representing a mean are named like "*-mean()*"
# so we grep for features having that pattern:
findIndicesOfFeatureType <- function(type, featureVec) {
    grep(paste('-', type, '\\(\\)', sep=''), featureVec)
}

# Read in feature names. The data in features.txt amount to the nonexistent column headers for the
# files test/X_test.txt and train/X_train.txt
features <- read.delim('features.txt', sep=' ', header=FALSE, col.names=c('index', 'feature'))

# First we get row indices into the data.frame called "features", then we extract the *column*
# indices associated with those features by reading the index column. As it happens, the value of
# the index column in row i is always just i, so this can seem like an unnecessary level of
# indirection, but this is more robust to changes in hypothetical future releases of this dataset.
meanIndices <- features[ findIndicesOfFeatureType('mean', features$feature), ]$index
stdIndices  <- features[ findIndicesOfFeatureType('std',  features$feature), ]$index
