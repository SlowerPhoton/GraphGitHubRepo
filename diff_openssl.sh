#!/bin/bash

### these should be the only lines you need to alter ###
# to specify the files you want to compare across different releases
FILES=(crypto/bn/bn_X931P.c crypto/bn/bn_prime.c crypto/rsa/rsa_gen.c crypto/rsa/rsa_X931G.c)
# to specify the name of the output file
OUTPUT_FILE=result_diff_openssl.txt

# directory named DIR will store all the versions of FILE !!! not true anymore
# their names follow the "<realease_name>.txt" format
DIRS=()
for FILE in ${FILES[@]}
do
	DIR=`echo $FILE | sed 's/\//_/g' | sed 's/\..*//g'` 
	if [ ! -d $DIR ]
	then
		mkdir $DIR
	fi
	DIRS+=($DIR)
done

# download OpenSSL if needed
if [ ! -d openssl ]
then
	git clone https://github.com/openssl/openssl.git
fi
cd openssl

# download all versions of FILE file for all tags/releases (no matter the branch)
git tag --sort=taggerdate | while read tag
do
	HASH=`git rev-list -1 $tag`
	i=0
	for FILE in ${FILES[@]}
	do
		
		FILENAME=../${DIRS[$i]}/${tag}
		if [ ! -f $FILENAME ]
		then
			WEB_PAGE=https://raw.githubusercontent.com/openssl/openssl/$HASH/$FILE
			GET $WEB_PAGE > $FILENAME
		fi
		i=$((i+1))
	done	
done

# store the results into RESULT file
# it is viewable by Excel-like apps, ';' is the delimeter
# if there is '*' in the second column, then the version differs from the previous one
# branches delimited by an empty row and a header specifying the name of the branch
RESULT=../$OUTPUT_FILE
if [ -f $RESULT ]
then
	rm $RESULT
fi

# header
echo -n "release;"
for FILE in ${FILES[@]}
do
	echo -n $FILE\; >> $RESULT
done
echo "" >> $RESULT

git branch -r | sed '1d' | while read branch # for each branch
do	
	echo \$$branch >> $RESULT # '$' denotes a new branch inst of tag
	git tag --merged $branch --sort=taggerdate | while read tag
	do
		echo -n ${tag}\; >> $RESULT
		i=0
		for FILE in ${FILES[@]}
		do
			FILENAME=../${DIRS[$i]}/$tag
			if [ ! -z ${PREV_FILENAME[$i]+x} ] # if variable PREV_FILENAME is set
			then
				if ! diff ${PREV_FILENAME[$i]} $FILENAME > /dev/null
				then
					echo -n \* >> $RESULT
				fi
			else
				echo -n \* >> $RESULT
			fi
			echo -n \; >> $RESULT
			PREV_FILENAME[$i]=$FILENAME
			i=$((i+1))
		done
		echo "" >> $RESULT
	done
done


