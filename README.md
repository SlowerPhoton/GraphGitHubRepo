# GraphGitRepo

*(This is no longer entirely true.)*

Creates a map of a git repository. To achieve this there are two scripts available:

* shell script `get_data_fom_git.sh`
* python script `draw_graph.py`

The first one prepares the necessary data with the help of `git` commands. The python script then visualizes the data previously collected with the help of `graphviz`. Requieres `graphviz` module to be installed.  

Right now both the scripts are configured for OpenSSL GitHub repo, but they can be easily modified. 

(A cropped example for OpenSSL GitHub repo)
<img src="https://i.imgur.com/MzKt92z.jpg" />

You can find more examples in the `examples` directory.
