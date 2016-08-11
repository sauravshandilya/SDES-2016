#!/bin/bash

# Name: Saurav Shandilya
# Roll No.: 153076004
# AE663 - SDES - Assingment-1 - Exercise-1
# Date: 08th August, 2016
# Course Instructor: Prof. Madhu Belur, Prof. Prabhu Ramachandran, Prof. Kumar Appaiah 
# Description: Consolidate marks obtained by students in partA and partB of a exam. Generate the result with total marks in each
#				part and status of qualification.



# files names stored as variable for easy access and generality
partA="partA.csv"
partB="partB.csv"
outfile="final-output.csv"


# check if output file allready exsist - recreate the empty output file to ensure no previous data affects present result
if [ -f $outfile ];
then
   rm $outfile
   touch $outfile
else
   touch $outfile
fi

# copy roll and marks from partA and populate it with required information
# If student has given part B : enter marks of A, marks of B, total marks  
# If student has not given part B: enter marks of A, put marks as "NC" for section B and Total marks = marks of part A
# Finally Sort the list
awk -F, '
NR==FNR{ 
	roll[$1]=$1; 			#Roll number of B
	marks[$1]=$2-i; 		#Marks of B
	#print a[$1] "," b[$1];
	next
}
NR!=FNR{
	if(roll[$1]-i==$1-i){
		print $0 "," marks[$1] "," $2+marks[$1];
	}
	else 
		print $0 "," "NC" "," $2;
}' $partB $partA | sort -t "," -k 4 -nr > $outfile


# Computation of IsTied : Find enteries in total marks which are repeated
# create a dummy list of total marks for comparision
istied=($(cut -d ',' -f 4 $outfile | uniq -d))
dummy=($(cut -d ',' -f 4 $outfile))
#cat $outfile
#echo ${istied[@]}
#echo ${dummy[@]}

lenght_istied=${#istied[@]}			# length of array
lenght_dummy=${#dummy[@]}			#length of array
#echo "$lenght_istied"
array_istied=()

# find count and rollnumber of students scoring same marks
for (( i=0; i<$lenght_dummy; i++))
do
	isset=0
		for (( j=0; j<$lenght_istied; j++))	
		do   
			
			if [ "${istied[j]}" == "${dummy[i]}" ]
			then
				#echo "${istied[j]} Repeat at $i" 
				array_istied[i]="Yes"
				#echo "$i is ${array_istied[i]}"
				isset=$((isset+1))
				#echo "i is $i and j is $j ${array_istied[i]}"
			fi
			
		done
		if [ "$isset" != "1" ]
		then
			array_istied[i]="No"
		fi
done
#echo "array is ${array_istied[@]}" 

# add serial number and append isTied flag
echo ${array_istied[@]} | tr -s " " "\n" | paste -d "," $outfile - | awk -F, '{$1=++i FS $1; a[$1]=$1}1' OFS=, - > temp.csv
#cat storefile.csv 

# add header
cat temp.csv | sed '1i\\Sr.Num., RollNum, partA, partB, Total, IsTied:Yes-No' - | tr -d '\r' > $outfile
#
rm temp.csv
#cat $outfile

echo "candidates appeared for part A = $(cat partA.csv | wc -l)" >statistics.txt
echo "candidates appeared for part B = $(cat partB.csv | wc -l)" >>statistics.txt
echo "candidates qualified = $(cut -d ',' -f 4 final-output.csv | grep -c [0-9])" >>statistics.txt
echo "Highest marks = ${dummy[0]}" >>statistics.txt
echo "Number of students with Scores Tied = $(cut -d ',' -f 6 final-output.csv | sed "1d" | grep -c "Yes")" >>statistics.txt
	