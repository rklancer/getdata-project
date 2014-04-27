# Codebook

This codebook describes the data that will be found in the CSV-formatted file
`output/summarized_data.txt` after executing `run_analysis.R` (see the README for instructions.)

## Source Dataset

These data are summaries derived from the data in the directory `input`, which are version 1.0 of
full [Human Activity Recognition Using
Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
dataset (henceforth, the "HAR dataset") provided by the following authors:

> Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
> Smartlab - Non Linear Complex Systems Laboratory
> DITEN - Università degli Studi di Genova. ia Opera Pia 11A, I-16145, Genoa, Italy.
> activityrecognition@smartlab.ws
> www.smartlab.ws


## Original Description

From the README of the HAR dataset:

> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48
> years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS,
> SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its
> embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular
> velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data
> manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the
> volunteers was selected for generating the training data and 30% the test data.

> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and
> then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The
> sensor acceleration signal, which has gravitational and body motion components, was separated
> using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is
> assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was
> used. From each window, a vector of features was obtained by calculating variables from the time
> and frequency domain. See 'features_info.txt' for more details.


## Summarization Process and Rationale

The source data contains many vectors of 561 features, each normalized to the range \[-1,1\] (see
the HAR dataset's README), which were derived from smartphone measurements taken while the human
subject performed one of six types of activity. The data also contain, in separate files, the
activity label and human subject identifier that pertain to each feature vector. Additionally, the
data are provided partitioned into non-overlapping training and testing sets.

The source data ultimately derive from 6 windowed, time-domain signals (3-axis linear acceleration
plus 3-axis angular velocity) measured by the actual sensors; these were expanded to 561 features in
two steps: first, by using signal processing methods to derive a number of related time and
frequency domain signals (_e.g._, by using a lowpass filter to separate gravitational acceleration
from body acceleration); second, by applying statistical summarizations (_e.g._, computation of the
mean or interquartile range) to the expanded set of signals. See the file `features_info.txt` in the
HAR dataset for more details, as I did not perform that analysis.

Conceptually, the summarization task done here is:

1. Combine the testing and training data.
2. Eliminate all features except the 66 features that use the _mean_ or _standard deviation_ statistical summarization operator.
3. Combine the activity and subject identifiers with the feature data, converting activity identifiers to human-readable activity labels.
4. Group together all rows having the same (activity, subject) pair, and for each (group, feature) pair, calculate the mean value of the feature.

Note that one of the summarization types that can be found in the dataset is a weighted mean
frequency. I did not include these data in the final summary, although they would be trivial to add.
The prompt seemed specifically to refer to the ordinary "mean" and "standard deviation"
summarizations; a weighted mean frequency is a slightly different concept.


## Description of Data Fields

* `-mean()` indicates the feature was computed by taking the mean of the underlying signal.
* `-std()` indicates the feature was computed by computing the standard deviation of the underlying
signal.
* Magnitudes are the Euclidean norm of the associated X, Y, and Z signals.

### Identifying columns

```
subject
```
The human subject whose activities were being labeled. Coded as an integer in the range 1-30.

```
activityLabel
```
Label describing the activity undertaken by the subject. One of "LAYING", "SITTING", "STANDING",
"WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS".


### Features derived from time-domain signals

```
tBodyAcc-mean()-X
tBodyAcc-std()-X
tBodyAcc-mean()-Y
tBodyAcc-std()-Y
tBodyAcc-mean()-Z
tBodyAcc-std()-Z
```
Body acceleration (extracted using low-pass filter), in X, Y, and Z dimensions.

```
tGravityAcc-mean()-X
tGravityAcc-std()-X
tGravityAcc-mean()-Y
tGravityAcc-std()-Y
tGravityAcc-mean()-Z
tGravityAcc-std()-Z
```
Gravitational acceleration (extracted using low-pass filter), in X, Y, and Z dimensions.


```
tBodyAccJerk-mean()-X
tBodyAccJerk-std()-X
tBodyAccJerk-mean()-Y
tBodyAccJerk-std()-Y
tBodyAccJerk-mean()-Z
tBodyAccJerk-std()-Z
```
Body "jerk" (first derivative of body acceleration), in X, Y, and Z dimensions.


```
tBodyGyro-mean()-X
tBodyGyro-std()-X
tBodyGyro-mean()-Y
tBodyGyro-std()-Y
tBodyGyro-mean()-Z
tBodyGyro-std()-Z
```
Angular velocity around X, Y, and Z axes.

```
tBodyGyroJerk-mean()-X
tBodyGyroJerk-std()-X
tBodyGyroJerk-mean()-Y
tBodyGyroJerk-std()-Y
tBodyGyroJerk-mean()-Z
tBodyGyroJerk-std()-Z
```
Time derivative of angular velocity around X, Y, and Z axes.

```
tBodyAccMag-mean()
tBodyAccMag-std()
```
Magnitude of body acceleration.

```
tGravityAccMag-mean()
tGravityAccMag-std()
```
Magnitude of gravitational acceleration.

```
tBodyAccJerkMag-mean()
tBodyAccJerkMag-std()
```
Magnitude of body jerk.

```
tBodyGyroMag-mean()
tBodyGyroMag-std()
```
Magnitude of angular velocity.

```
tBodyGyroJerkMag-mean()
tBodyGyroJerkMag-std()
```
Magnitude of angular velocity,


### Features derived from frequency-domain signals

```
fBodyAcc-mean()-X
fBodyAcc-std()-X
fBodyAcc-mean()-Y
fBodyAcc-std()-Y
fBodyAcc-mean()-Z
fBodyAcc-std()-Z
```
FFT of body acceleration, in X, Y, and Z directions.

```
fBodyAccJerk-mean()-X
fBodyAccJerk-std()-X
fBodyAccJerk-mean()-Y
fBodyAccJerk-std()-Y
fBodyAccJerk-mean()-Z
fBodyAccJerk-std()-Z
```
FFT of body jerk, in X, Y, and Z directions.

```
fBodyGyro-mean()-X
fBodyGyro-std()-X
fBodyGyro-mean()-Y
fBodyGyro-std()-Y
fBodyGyro-mean()-Z
fBodyGyro-std()-Z
```
FFT of angular velocity around X, Y, and Z axes.

```
fBodyAccMag-mean()
fBodyAccMag-std()
```
FFTs of magnitude of body acceleration.

```
fBodyBodyAccJerkMag-mean()
fBodyBodyAccJerkMag-std()
```
FFT of magnitude of body jerk.

```
fBodyBodyGyroMag-mean()
fBodyBodyGyroMag-std()
```
FFT of magnitude of angular velocity


```
fBodyBodyGyroJerkMag-mean()
fBodyBodyGyroJerkMag-std()
```
FFT of magnitude of time derivative of angular velocity.

