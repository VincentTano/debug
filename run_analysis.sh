#!/bin/bash

input_file=$1
awk '{if ($(NF-1) < 0 && $NF <= 0) print "chr1\t"sqrt(($NF)^2)"\t"sqrt(($(NF-1)^2))}' ${input_file} > ${input_file}.bed
#bedtools coverage -a reference_file_maxLength_10000.txt -b ${input_file}.bed -d > ${input_file}.output
bedtools genomecov -i <(sort -k2,2n -k3,3n ${input_file}.bed) -g reference_file_maxLength_10000.txt -d | awk '{print $1"\t-"$2"\t"$3}' | sort -k2,2n -k3,3n > ${input_file}.output  

awk '{if ($(NF-1) >= 0 && $NF > 0) print "chr1\t"$(NF-1)"\t"$NF}' ${input_file} > ${input_file}.bed
bedtools genomecov -i <(sort -k2,2n -k3,3n ${input_file}.bed) -g reference_file_maxLength_10000.txt -d | awk '{print $1"\t"$2"\t"$3}' >> ${input_file}.output

awk '{if ($(NF-1) == 0 && $NF == 0) print "0"}' ${input_file} | uniq -c | awk '{print "chr1\t"$2"\t"$1}' >> ${input_file}.output

