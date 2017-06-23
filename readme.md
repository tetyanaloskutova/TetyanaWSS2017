# WikiMap 

Project by Tetyana Loskutova

WikiMap project is a Wolfram Language implementation of  a semantic topic map for Wikipedia. 


## Statement of the problem
Wikipedia contains a large amount of knowledge, which can be associated with different domains. Given the amount of data, it is impossible to grasp the scope of the knowledge coverage without some kind of automation. The goal of this project is to group the articles by subject domains and display them on a topic map, which will allow to estimate meaning-based connections between domains.

## Solution outline
The core of the solution is a zoomable graph with the main nodes corresponding to the knowledge domains (TODO: what are knowledge domains? Can they be approximated by wikipedia portals or categories? Perhaps, classification by article title and category).
The main nodes are interlinked and the strength of the link is proportional to the number of cross-references between domains.
Within main nodes, further zoom is permitted to open topic maps of the node (same structure as the top level).
     

## TODO: (* how to run your code *)
## TODO: (* examples, code documentation, etc *)

