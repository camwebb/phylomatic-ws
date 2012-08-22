phylomatic-ws
=============

Improved web service for phylomatic


Phylogeny representation
------------------------

Each node is represented by the following array values:

 * `nodename` : the node identifier (string)
 * `parent[nodename]` : the parent node identifier
 * `bl[nodename]` : branch length to the parent node (float or string)
 * `taxon[nodename]` : the taxon assoc with that node identifier (string)
 * `nDaughter[nodename]` : the number of distal edges (integer)

with some flags: 

 * `keep[nodename]` : keep this node and all proximal ones in the
   pruning process

Other globals valiables

 * `hasBL` : does the tree contain BLs?
 * `totalBL` : the total tip to root BL sum (assumes an ultrametric tree)
