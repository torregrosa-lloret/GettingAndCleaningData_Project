# Getting And Cleaning Data Course Project

This repository contains the scripts, raw data, tidy data and the code book for the *Getting And Cleaning Data Course Project*.

## Repository structure

This repository contains a folder named "data" which contains the data downloaded from this [site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The rest of files, including the R script, are located in the parent folder to ease the correction of this assignment. Therefore, this files and folders of this repo are the following:

* **data**: (*folder*) Folder with the raw data.
* **CodeBook.md**: (*markdown file*) Code book that describes the variables, the data, and any transformations or work that you performed to clean up the data.
* **run_analysis.R**: (*R script*) Script for the cleaning of the data.
* **TidyData.txt**: (*txt file*) Tidy dataset obtained after runnning the "run_analysis.R" script.
* **GettingAndCleaningData_Project.Rproj**: (*R Project file*) R project file of the assginment.

## Usage

To clean the data in the "data" folder just run the script "run_analysis.R" in an R environment. It will automatically load and tidy the data, according to the instructions of the *Getting And Cleaning Data Course Project*.