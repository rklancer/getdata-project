#!/usr/bin/env Rscript
setwd('input')
source(file.path('..', 'run_analysis.R'))
setwd('..')
if (!file.exists('output')) {
	create.dir('output')
}
file.rename(file.path('input', 'summarized_data.txt'), file.path('output', 'summarized_data.txt'))