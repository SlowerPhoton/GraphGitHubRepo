#!/usr/bin/python3.5

# the variables you might want to alter
input_file = "result_openssl.txt"
output_file = "openssl_rsa.gv"

# read data file and prepare data
# each line in data file is either a branch declaration or release changes list
# branch declaration line starts with '$' immediately followed by the branch name
# release changes line is composed of cells delimited by ';' and ends with ';'
# first cell is the release name other cells are either '*' or empty
# depending on whether the release should be drawn ('*') or not
data = {}
with open(input_file, "r") as ifile:
    files = ifile.readline().split(';')[:-1]
    for line in ifile:
        if line.startswith('$'): # new branch declaration
            branchName = line[1:]
            branchName = branchName.rstrip() # deletes '\n'
            if branchName.startswith('origin/'):
                branchName = branchName[len('origin/'):]
            data[branchName] = []
        else:
            cells = line.split(';')[:-1]
            release = cells[0]
            if '*' in cells:
                data[branchName].append(release)

import graphviz as gv
graph = gv.Digraph()

class Color:
    index = 0
    colors = ['red', 'blue', 'black', 'brown', 'aquamarine', 'gold', 
              'forestgreen', 'magenta', 'yellow', 'aqua', 'indigo', 
              'darkorange', 'grey', 'orangered4', 'bisque', 'crimson', 
              'chocolate', 'darkolivegreen1', 'darkslategray']
    @staticmethod
    def getNext():
        Color.index = Color.index + 1
        return Color.colors[(Color.index-1) % len(Color.colors)]

color = {}
for branch in data:
    color[branch] = Color.getNext()


for branch in data:
    last = None
    for release in data[branch]:
        graph.node(release)
        if last != None:
            graph.edge(last, release, color=color[branch])
        last = release

# create the legend
# the combination of invisble edges and nodes
# ensures a more pleasant look
with graph.subgraph(name='cluster') as legend:
    last = None
    last_in = None
    i = 0
    for branch in data:
        branch_in = str(i).zfill(3)
        i = i + 1
        legend.node(branch, fontcolor = color[branch], shape='none')
        legend.node(branch_in, style='invis', shape='point')
        legend.edge(branch, branch_in, color = color[branch])
        if last:
            legend.edge(last, branch, style='invis')
        last = branch
        if last_in:
            legend.edge(last_in, branch_in, style='invis')
        last_in = branch_in


graph.view(filename=output_file)
