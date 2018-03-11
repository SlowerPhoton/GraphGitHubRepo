# GraphGitRepo

*(This is no longer entirely true.)*

Creates a map of a git repository. To achieve this there are two scripts available:

* shell script `get_data_fom_git.sh`
* python script `draw_graph.py`

The first one prepares the necessary data with the help of `git` commands. The python script then visualizes the data previously collected with the help of `graphviz`. Requieres `graphviz` module to be installed.  

**Shell Script `get_data_fom_git.sh`**

At first I clone the OpenSSL repository if not present:
   
    git clone https://github.com/openssl/openssl.git
   
And I enter the cloned repository. This is the main piece of code which also explains the format of the output file:

	git branch -r | # a list of all branches in the repository 
	sed '1d' | # changes 'origin/<branch name>' to '<branch name>' 
	while read BRANCH # for each branch
	do	
		echo \$$BRANCH >> $OUTPUT_FILE
        	git tag --merged $BRANCH --sort=creatordate | # list all tags (releases) for a given branch sorted by time of creation 
        	while read TAG # for each tag
        	do
			echo $TAG\;\*\; >> $OUTPUT_FILE
		done
	done

Right now both the scripts are configured for OpenSSL GitHub repo, but they can be easily modified. 

(A cropped example for OpenSSL GitHub repo)
<img src="https://i.imgur.com/MzKt92z.jpg" />

You can find more examples in the `examples` directory.
