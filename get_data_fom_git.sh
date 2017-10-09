OUTPUT_FILE=result_openssl.txt
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

echo fictional_file >> $OUTPUT_FILE


git branch -r | sed '1d' | while read branch # for each branch
do	
	echo \$$branch >> $OUTPUT_FILE
	git tag --merged $branch --sort=taggerdate | while read tag # for each tag
	do
		echo $tag\;\*\; >> $OUTPUT_FILE
	
	done
done

if $REMOVE_OPENSSL
then
	rm -r openssl
fi

