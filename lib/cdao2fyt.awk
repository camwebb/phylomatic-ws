function cdao2fyt( INFILE )
{

  # Read CDAO triples
  while ((getline < INFILE) > 0)
	{
	  if ($2 == "<http://www.evolutionaryontology.org/cdao.owl#has_Ancestor>")
		{
		  parent[$1] = $3;
		}
	  else if ($2 == "<http://www.evolutionaryontology.org/cdao.owl#has_Child_Node>")
		{
		  parentEdge[$3] = $1;
		}
	  else if ($2 == "<http://www.evolutionaryontology.org/cdao.owl#has_Annotation>")
		{
		  annotation[$1] = $3;
		}  
	  else if ($2 == "<http://www.evolutionaryontology.org/cdao.owl#has_Float_Value>")
		{
		  annotationEdgeLength[$1] = $3;
		  gsub(/\^\^.*/,"",annotationEdgeLength[$1]);
		  gsub(/"/,"",annotationEdgeLength[$1]);
		}
	  else if ($2 == "<http://www.evolutionaryontology.org/cdao.owl#represented_by_Node>")
		{
		  taxon[$3] = gensub(/[<>]/,"'","G", $1) ;
		}
	}

  hasBL = 1;
  for (i in parent)
	{
	  if (!parent[parent[i]]) { root = parent[i]; parent[root] = "NULL" }
	  bl[i] = annotationEdgeLength[annotation[parentEdge[i]]] ;
	  if (!bl[i]) { hasBL = 0 };  # a single missing BL cancels BLs
	  nDaughter[parent[i]]++;
	}
}

