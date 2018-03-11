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


    git branch -r # a list of all branches in the repository 
    | sed '1d' # changes 'origin/<branch name>' to '<branch name>' 
    | while read BRANCH # for each branch
    do	
        echo \$$BRANCH >> $OUTPUT_FILE
        git tag --merged $BRANCH --sort=creatordate # list all tags (releases) for a given branch sorted by time of creation 
        | while read TAG # for each tag
        do
		        echo $TAG\;\*\; >> $OUTPUT_FILE
        done
    done

if $REMOVE_OPENSSL
then
	rm -r openssl
fi

