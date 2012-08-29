function fyt2new(                 x , y, n, first , mark, tmp) 
{
  # (c) 2011 Cam Webb
  # Distributed under (open source) BSD 2-clause licence

  # fyt2new
  # converts a tabular `fyt format phylogeny to Newick, parenthetical format

  # fyt-format = 4 tab-delimited string fields:
  #   1. nodeID
  #   2. parent node nodeID (must be either "-1", "", or "NULL" for root node)
  #   3. branch length to parent node (an integer or float; missing for no BLs)
  #   4. node name (terminal or interior node)
  #   5. (optional) notes attached node

  # check for root:
  if (root == "") { print "No root found" ; exit }

  # SetNodePointers, lDaughter, rSister needed for down-pass recursivity

  # initialize
  for (x in parent)
    {
      lDaughter[x] = "NULL";
      rSister[x] = "NULL";
      first[x] = 1;
	  n++; 
    }

  # special case of a single node:
  if (n == 1) { print "Content-type: text/plain\n\n" taxon[x] ";\n" ; return }

  for (x in parent)
    {
      # starting at terms
      if (!nDaughter[x])
        {
          y = x;
          # while not yet at the root (allow diff coding schemes)
          while (y != root)
            {
              # is this the first daughter?
              if (lDaughter[parent[y]] == "NULL") 
                {
                  lDaughter[parent[y]] = y;
                }
              # if not, find the dangling sister
              else
                {
                  # start at lDaughter
                  mark = lDaughter[parent[y]];
                  # move to node with an empty rSister
                  while (rSister[mark] != "NULL")
                    {
                      mark = rSister[mark];
                    }
                  rSister[mark] = y;
                }
                
              # test for refollowing old routes
              if (first[parent[y]] == 1) {y = parent[y]; first[y] = 0}
              else break;
            }
        }
    }

  # Recurse through levels

  tmp = "";
  if (warning) 
	{
	  warning = "[" warning "]";
	}

  print "Content-type: text/plain\n\n";
  printf("%s%s;\n", downPar(root, tmp), warning);

  # exit;
  return;
}

function downPar(atn, tmp,           x, which, tmpnext )
{
  which = 0;

  # if terminal, go no further
  if (!nDaughter[atn])
    {
      tmp = gensub(/\ /,"_","G",taxon[atn]);
      if ((hasBL) && ( bl[atn]))
		{
          tmp = tmp ":" bl[atn];
        }
	  if (note[atn]) tmp = tmp "[" note[atn] "]" ;
    }
  else
    {
	  
      x = lDaughter[atn];
      tmp =  "(";
      tmp = tmp downPar(x, tmpnext[which]);
    
      x = rSister[x]; which++;

      while (x != "NULL")
        {
          tmp = tmp  ",";
          tmp = tmp downPar(x, tmpnext[which]);
          x = rSister[x]; which++;
        }
      tmp = tmp  ")";
      tmp = tmp  gensub(/\ /,"_","G",taxon[atn]);
      if ((hasBL) && ( bl[atn])) 
		{
		  tmp = tmp  ":" bl[atn];
        }
	  if (note[atn]) tmp = tmp "[" note[atn] "]" ;
    }
  
  return tmp;
}
