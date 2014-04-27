# Summarization of the UCI _Human Activity Recognition Using Smartphones_ Data Set

Submitted as part of the [Coursera](http://coursera.org)[Getting and Cleaning Data](https://www.coursera.org/course/getdata) class.

This repository contains a copy of version 1.0 of the [Human Activity Recognition Using
Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
dataset (henceforth, the "HAR dataset") provided by the following authors:

> Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
> Smartlab - Non Linear Complex Systems Laboratory
> DITEN - Università degli Studi di Genova. ia Opera Pia 11A, I-16145, Genoa, Italy.
> activityrecognition@smartlab.ws
> www.smartlab.ws

It also contains a script for generating a summary of the associated dataset. The core of the script is in the file `run_analysis.R`; when sourced in an R interpreteter

It requires the packages `gdata` and `data.table` to be installed first.

In order to automate the generation of