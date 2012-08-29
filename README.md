phylomatic-ws
=============

Links
-----

 * TNRS [API](http://api.phylotastic.org/tnrs)
 * Tree base [API](http://sourceforge.net/apps/mediawiki/treebase/index.php?title=API)

Improved web service for phylomatic

Internal phylogeny representation
------------------------

Each node is represented by the following array values:

 * `nodename` : the node identifier (string)
 * `parent[nodename]` : the parent node identifier
 * `bl[nodename]` : branch length to the parent node (float or string)
 * `taxon[nodename]` : the taxon assoc with that node identifier (string)
 * `nDaughter[nodename]` : the number of distal edges (integer)
 * `note` : any notes associated with the node (string)
 * `lDaughter[nodename]` : the left daughter of a node, created only
   during writing of newick (string)
 * `rSister[nodename]` : the right sister of a node, created only
   during writing of newick (string)
 * `age[nodename]` : the age of the node, measured from (ultramentric)
   tips (integer or float)

Other globals valiables:

 * `hasBL` : does the tree contain BLs? (0|1)
 * `totalBL` : the total tip to root BL sum (assumes an ultrametric
   tree) (float or string)
 * `root` : the root node

Performance
-----------

Matching 10 taxa in the Smith 2011 megatree:

      $ cat eg/input1 | /usr/bin/time pmws
	  
See it [live](http://phylodiversity.net/phylomatic/pmws?storedtree=smith2011&informat=newick&method=phylomatic&taxa=Bicuiba_oleifera%0AGuatteria_dolichopoda%0AIteadaphne_caudata%0AGonocarpus_leptothecus%0AAmylotheca_subumbellata%0AImpatiens_davidi%0ACalochortus_argillosus%0ALilium_lankongense%0AGagea_sarmentosa%0ACephalanthera_rubra&outformat=newick&clean=true):

      http://phylodiversity.net/phylomatic/pmws?storedtree=smith2011
	    &informat=newick&method=phylomatic&taxa=Bicuiba_oleifera%0AGu
		atteria_dolichopoda%0AIteadaphne_caudata%0AGonocarpus_leptoth
		ecus%0AAmylotheca_subumbellata%0AImpatiens_davidi%0ACalochort
		us_argillosus%0ALilium_lankongense%0AGagea_sarmentosa%0ACepha
		lanthera_rubra&outformat=newick&clean=true

Does the match in 1.8 seconds on my quad-core Intel i5 laptop.

Data input examples
----------------

Here are some possible input URIs:

“Select seal,sea_lion,monkey from a NeXML tree at the
[PhylotasticTreeStore](http://phylotastic.nescent.org/PhylotasticTreeStore/phylows/)” ([RUN](http://phylodiversity.net/phylomatic/pmws?treeuri=http%3A%2F%2Fphylotastic.nescent.org%2FPhylotasticTreeStore%2Fphylows%2Ftree%3Ftree%5Furi%3Dhttp%253A%252F%252Fphylotastic.nescent.org%252Ftrees%252FTreemytree5&informat=nexml&method=phylomatic&taxa=seal%0Asea_lion%0Amonkey&outformat=newick&clean=true)):

      http://phylodiversity.net/phylomatic/pmws?treeuri=http%3A%2F%2F
	    phylotastic.nescent.org%2FPhylotasticTreeStore%2Fphylows%2Ftre
		e%3Ftree%5Furi%3Dhttp%253A%252F%252Fphylotastic.nescent.org%25
		2Ftrees%252FTreemytree5&informat=nexml&method=phylomatic&taxa=
		seal%0Asea_lion%0Amonkey&outformat=newick&clean=true

“Convert a CDAO phylogeny to Newick” ([RUN](http://phylodiversity.net/phylomatic/pmws?treeuri=http://phylodiversity.net/phylomatic/eg/tree1.cdao.rdf&informat=cdaordf&method=convert&outformat=newick)):

      http://phylodiversity.net/phylomatic/pmws?treeuri=http://phylo
	    diversity.net/phylomatic/eg/tree1.cdao.rdf&informat=cdaordf&
		method=convert&outformat=newick

To Do
-----

 * Send/receive compression with gzip
 * Graft in whole trees
 * More ouput formats
 * Add jsPhyloSVG viewer 
