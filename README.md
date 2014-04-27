## Summarization of the UCI _Human Activity Recognition Using Smartphones_ Data Set

Submitted as part of the [Coursera](http://coursera.org) [Getting and Cleaning Data](https://www.coursera.org/course/getdata) class.

This repository contains a copy of version 1.0 of the [Human Activity Recognition Using
Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
dataset (henceforth, the "HAR dataset") provided by the following authors:

> Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
> Smartlab - Non Linear Complex Systems Laboratory
> DITEN - Università degli Studi di Genova. ia Opera Pia 11A, I-16145, Genoa, Italy.
> activityrecognition@smartlab.ws
> www.smartlab.ws

It also contains a script for generating a summary of the associated dataset. The core of the script is in the file `run_analysis.R`; when sourced in an R interpreteter whose working directory
contains the HAR dataset (specifically, when the working directory is the directory `input/` in
this repo) it will generate summary data for some of the features in the dataset, grouped by subject and activity. See `CodeBook.md` in this repository for more details.

Note that the packages `gdata` and `data.table` must be installed prior to running the analysis.

Additionally, for convenience, there is a command-line script, `do_whole_analysis.R`, which when run at the (Unix) command line in the base directory of this directory, will summarize the data and put the results in `output/summarized_data.txt`

    $ ./do_whole_analysis.R

The resulting file is a pretty-printed CSV file. To read it back into R as a `data.frame`, use `read.csv` with the `check.names` parameter set to false:

    > summarized_data <- read.csv('output/summarized_data.txt', check.names=FALSE)
  
