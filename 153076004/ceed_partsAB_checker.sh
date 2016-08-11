#!/bin/bash

# Name: Saurav Shandilya
# Roll No.: 153076004
# AE663 - SDES - Assingment-1 - Exercise-2
# Date: 08th August, 2016
# Course Instructor: Prof. Madhu Belur, Prof. Prabhu Ramachandran, Prof. Kumar Appaiah 
# Description: Write script for evaluation of script written in Exercise-1. This script should also be able to check 
#				Exercise-1 submitted by other students.
# To run this file ensure that there is <rollnumber>.sh files, partA.csv,partB.csv and template.csv. Files for which 
#testing has been has been done is provided inside the folder


outdir="rollnumber"				# directory location where all script file has to be saved
outfile="rollnum-marks.csv"		# result file - carry rollnumber of students and marks scored

# check if directory allready exsist - recreate the directory to ensure clean workspace
if [ -f $outdir ];
then
   rm -rf $outdir
   mkdir $outdir
else
   mkdir $outdir
fi

# check if result file allready exsist - recreate the empty result file to ensure no previous data affects present result
if [ -f $outfile ];
then
   rm $outfile
   touch $outfile
else
   touch $outfile
fi


# Add header in result file
echo "rollnum-header,mark-header" >> $outfile

# set permission for script file and move it inside the directory
for i in $(ls | grep [0-9].sh)
do
	chmod +x "$i" | mv "$i" $outdir
done

# copy dataset and template result inside directory - required for running the script
cp partA.csv partB.csv template.csv $outdir

# cd to directory to run the script
cd $outdir

# run each script submitted by students and compare it with template. If result matches the template score of 10 is awarded else score is 0
for j in $(ls | grep [0-9])
do
	#echo "$j"
	bash "$j"	# run script file submitted by student				
	check=$(diff -q "final-output.csv" "template.csv")			# compare final output with template answer
	#echo "$check"
	if [ "$check" == "" ]							
	then
		#echo "Pass"
		echo "$j,10" | tr -d '.sh' >> ../rollnum-marks.csv		# If output matches with template - award 10 marks
	else
		#echo "fail"
		echo "$j,0" | tr -d '.sh' >> ../rollnum-marks.csv		# If output does not matches with template - award 0 marks
	fi
done