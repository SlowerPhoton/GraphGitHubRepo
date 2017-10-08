OUTPUT_FILE=git_data.txt
REMOVE_OPENSSL=false

# download OpenSSL if needed
if [ ! -d openssl ]
then
	git clone https://github.com/openssl/openssl.git
fi
cd openssl
OUTPUT_FILE=../$OUTPUT_FILE

if [ -f $OUTPUT_FILE ]
then
	rm $OUTPUT_FILE
fi


git branch -r | sed '1d' | while read branch # for each branch
do	
	echo -n $branch\; >> $OUTPUT_FILE
	git tag --merged $branch --sort=taggerdate | while read tag # for each tag
	do
		#echo -n -e "$tag" '\t' >> $OUTPUT_FILE
		printf "%s\t" "$tag" >> $OUTPUT_FILE
	done
	echo >> $OUTPUT_FILE # empty row
done

if $REMOVE_OPENSSL
then
	rm -r openssl
fi

