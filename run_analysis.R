# Use data.table for speed!
library(data.table)

#
# Given a vector of feature names from the Human Activity Recognition dataset,
# `featureNames`, and a feature type, `type` (e.g., "mean" or "std") returns
# the indices of the features of that type. (This relies on the consistent
# naming pattern found in the dataset, in which features derived from signal
# summarizedData are named like "tBodyAcc-mean()-X")
#
findIndicesOfFeatureType <- function(type, featureNames) {
    grep(paste('-', type, '\\(\\)', sep=''), featureNames)
}

#
# Given `prefix` and `class` (see below), reads raw data from one of the files
# in the dataset, and returns it as a vector.
#
# `prefix` is "X" for the feature data, "y" for the activity labels, or
# "subject" to indicate the subject the data was sampled from.
#
# (This uses scan(), which returns a vector, rather than one of the
# table-reading functions because scan() happens to work well for this
# dataset. There is no missing data in the dataset, allowing easy reshaping to
# a matrix, and table-reading functions are slow and require finicky setup to
# deal with the variable number of spaces between columns.)
#
readRawData <- function(prefix, class) {
    scan(file.path(class, paste(prefix, '_', class, '.txt', sep='')))
}

#
# For the given `class` ("test" or "train"), and list of desired features,
# (provided as a data.frame with columns "index" and "name") return a
# data.table with columns for only those features, and with the columns
# labeled appropriately.
#
readFeatures <- function(class, desiredFeatures) {

    # readRawData returns a *vector*, so reshape to a matrix...
    rawData <- matrix(readRawData('X', class),
        ncol=max(features$index),
        byrow=TRUE)

    # ...but immediately subset only the columns we need, allowing the vector
    # and matrix to be garbage collected.
    ret <- data.table(rawData[,desiredFeatures$index])

    # And use the no-copy way to set column names.
    setnames(ret, desiredFeatures$name)
    ret
}

# Step 1: First, get the names and indices of the features we want to keep.

# Read in feature names. The data in features.txt amount to the nonexistent
# column headers for the files test/X_test.txt and train/X_train.txt
features <- read.delim('features.txt',
                sep=' ',
                header=FALSE,
                col.names =c('index',   'name'),
                colClasses=c('integer', 'character')
            )

meanFeatures <- features[ findIndicesOfFeatureType('mean', features$name), ]
stdFeatures  <- features[ findIndicesOfFeatureType('std',  features$name), ]

# Interleaves the rows of meanFeatures, stdFeatures so that a feature derived
# from the mean of a signal is (hopefully) immediately followed by a feature
# derived from the standard deviation of the same signal.
desiredFeatures <- features[0,]
desiredFeatures[seq(1, by=2, length=dim(meanFeatures)[1]),] <- meanFeatures
desiredFeatures[seq(2, by=2, length=dim( stdFeatures)[1]),] <- stdFeatures


# Step 2: get the features, labels, and subjects into one data table.

# First, combine the 'test' and 'train' feature data. For memory purposes we
# want to throw away the unused features *before* we combine the datasets, and
# we want to avoid assigning the test and train data to long-lived variables
# that force them to be kept around.

# Just constructs a data.table with all data for the given `class`:
read <- function(class) {
    ret = readFeatures(class, desiredFeatures)
    ret[,subject      := readRawData('subject', class)]
    ret[,activityCode := readRawData('y',       class)]
}
combinedData <- rbindlist(list(read('test'), read('train')))


# Step 3: replace the activityCode with human-readable activity labels.

activityLabels <- data.table(
                    read.delim('activity_labels.txt',
                        sep=' ',
                        header=FALSE,
                        col.names =c('activityCode', 'activityLabel'),
                        colClasses=c('numeric',      'factor')
                    )
                )

combinedData <- merge(combinedData, activityLabels, by='activityCode')
# delete activityCode since it's now redundant to activityLabel
combinedData[,activityCode:=NULL]


# Step 4: Group and summarize the data by mean. This is where data.table
# shines. Equivalent to:
#     summarizedData <- ddply(combinedData, .(subject, activityLabel),
#         numcolwise(mean))

setkey(combinedData, subject, activityLabel)
summarizedData <- combinedData[,lapply(.SD, mean),
                    by=list(subject, activityLabel)]
