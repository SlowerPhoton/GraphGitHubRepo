#!/usr/bin/python3.5

# read data file and prepare data
data = {}
with open("git_data.txt", "r") as ifile:
    # one line in the file is in format branch;release1 release2 ... \n
    for line in ifile:
        branchName, releasesLine = line.split(';')
        if branchName.startswith('origin/'):
            branchName = branchName[len('origin/'):]
        releases = releasesLine.split()
        data[branchName] = releases

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


