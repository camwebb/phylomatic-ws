
@load xml

# As function:
# XMLMODE = 0
# function nexml2fyt(INFILE,        otulabel, ntrees, otuid, ) {
# XMLMODE = 1;
# while ((getline < INFILE) > 0 )

BEGIN { XMLCHARSET="utf-8" } # <-- vital 

{
  if (XMLSTARTELEM == "otu")
	{
	  otulabel[XMLATTR["id"]] = XMLATTR["label"] 
	}
  else if (XMLSTARTELEM == "tree")
	{
	  ntrees++;
	}
  else if (XMLSTARTELEM == "node")
	{
	  # just for the first tree
	  if (ntrees == 1)
		{
		  # if there is an otu link
		  if (XMLATTR["otu"])
			{
			  otuid[XMLATTR["id"]] =  XMLATTR["otu"];
			}
		  # temporarily label taxa with node labels
		  if (XMLATTR["label"])
			{
			  taxon[XMLATTR["id"]] = XMLATTR["label"];
			}
		  
		  # create parent for root (root not always specified explicitly)
		  # if (XMLATTR["root"] == "true")
		  # 	{
		  #	  parent[XMLATTR["id"]] = "NULL";
		  #	}
		}
	}
  else if (XMLSTARTELEM == "edge")
	{
	  # for just the first tree
	  if (ntrees == 1)
		{
		  parent[XMLATTR["target"]] = XMLATTR["source"];
		  bl[XMLATTR["target"]] = XMLATTR["length"];
		}
	}
}

END {

  # attach labels (can't be done on read, in case otu block is after trees) 

  # find the root
  for (i in parent) if (!parent[parent[i]]) { root = parent[i]; parent[root] = "NULL" }

  OFS = "\t";
  for (i in parent)
	{
	  if (otulabel[otuid[i]])
		{
		  taxon[i] = otulabel[otuid[i]]
		}
	  print i, parent[i], bl[i], taxon[i] ;
	}
}
