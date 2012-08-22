function cdaottl2fyt( n3  )
{

  # split into rows
  nrow = split(n3, row, "\n") ;
  for (r = 1 ; r < nrow ; r++)
	{
	  ncol = patsplit(row[r], c, /([^\ ]+)|("[^"]+")/ ) ;

	  # has_Parent
	  if (c[2] == "<http://purl.obolibrary.org/obo/CDAO_0000179>")
		{
		  parent[c[1]] = c[3];
		}
	  #  belongs_to_Edge_as_Child
	  else if (c[2] == "<http://purl.obolibrary.org/obo/CDAO_0000143>")
		{
		  parentEdge[c[1]] = c[3];
		}
	  # has_Annotation
	  else if (c[2] == "<http://purl.obolibrary.org/obo/CDAO_0000193>")
		{
		  annotation[c[1]] = c[3];
		}
	  # has_Float_Value
	  else if (c[2] == "<http://purl.obolibrary.org/obo/CDAO_0000218>")
		{
		  annotationEdgeLength[c[1]] = c[3];
		  gsub(/\^\^.*/,"",annotationEdgeLength[c[1]]);
		  gsub(/"/,"",annotationEdgeLength[c[1]]);
		}
	  # represents_TU
	  else if (c[2] == "<http://purl.obolibrary.org/obo/CDAO_0000187>")
		{
		  taxon[c[1]] = c[3];
		  TU[c[1]] = c[3];
		}
	  # taxon label
	  else if (c[2] = "<http://www.w3.org/2000/01/rdf-schema#label>")
		{
		  TUtaxon[c[1]] = gensub(/"/,"","G", c[3]) ;
		}
	}

  hasBL = 1;
  for (i in parent)
	{
	  if (!parent[parent[i]]) { root = parent[i]; parent[root] = "NULL" }
	  bl[i] = annotationEdgeLength[annotation[parentEdge[i]]] ;
	  if (!bl[i]) { hasBL = 0 };  # a single missing BL cancels BLs
	  nDaughter[parent[i]]++;
	  if ((taxon[i]) && (taxon[i] !~ /http/))
		{
		  taxon[i] = TUtaxon[TU[i]];
		}
	}
  
  OFS="\t";
  # for (i in parent)  print i, parent[i], bl[i], taxon[i] ;
}
   
