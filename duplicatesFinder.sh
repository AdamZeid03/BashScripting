#!/bin/bash
files=$(find $1 -type f)

# create arrays of names, hashes and sizes of files in given or current direcory
fileNames=()
fileHash=()
fileSize=()

# insert values to each array
for file in $files
do
    fileNames+=("$file")
    fileHash+=("$(sha256sum $file | cut -d ' ' -f 1)")
    fileSize+=("$(stat --printf="%s" $file)")
done

# create array of idencital files
identicalFiles=()

# find idencital files and insert them into an array
identicalFiles+=($(
for index1 in "${!fileHash[@]}";
do
    for index2 in "${!fileHash[@]}";
    do
        # if two diffrent indexes
        if [[ $index1 < $index2 ]]; then
            # have the same hash it means that files are indentical
            if [[ "${fileHash[$index1]}" == "${fileHash[$index2]}" ]]; then
                # insert into array sizeKB;nameOfFile1;nameOfFile2
                echo ${fileSize[index1]}KB";"${fileNames[index1]}";"${fileNames[index2]}
            fi
        fi
    done
    # sort descending -k1 numeric value of size -n numericly -r reverse
done | sort -t ';' -k1 -n -r
))

# print found duplicates
(echo "Size;File1;File2"
for x in "${!identicalFiles[@]}"
do
    echo ${identicalFiles[x]} 
done) | column -t -s ";"
