function readfyt( results ,        nrow, r, row, c )
{
  hasBL = 1;

  # split into rows
  nrow = split(results, row, "\n") ;
  for (r = 1 ; r < nrow ; r++)
	{
	  ncol = split(row[r], c, "\t") ;
	  
	  parent[c[1]] = c[2];
	  # find root, allow diff coding schemes:
	  if ((c[2] == "NULL") || (c[2] == "") || (c[2] == "-1")) root = c[1];
	  nDaughter[c[2]]++;
	  
	  bl[c[1]] = c[3];
	  if ((c[3] == "") && (c[1] != root))
		{ hasBL = 0 };  # a single missing BL (other than root) cancels BLs
	  
	  # this should be only at the Newick writer:
	  # change spaces to underscores
	  taxon[c[1]] = gensub(/\ /,"_","G",c[4]);
	  # quote taxon names
	  if (index(taxon[c[1]], ":")) taxon[c[1]] = "'" taxon[c[1]] "'" ;
	  
	  # check note for illegal characters in Newick
	  if (ncol==5) note[c[1]] = gensub(/[\[\]]/,"~","G",c[5]);
	}
  
  # returned by reference

}
