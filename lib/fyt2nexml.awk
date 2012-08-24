function fyt2nexml(     i, n, nd, e, ed, t, tx, root, ndtx, leng)
{
  ORS="\n";
  print "Content-type: text/xml\n";
  print "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
  if (warning) print "<!-- " warning " -->";
  print "<nexml version=\"0.9\"";
  print "  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"";
  print "  xmlns:nex=\"http://www.nexml.org/2009\"";
  print "  xmlns=\"http://www.nexml.org/2009\">";

  # taxa
  print "  <otus id=\"tax1\" label=\"RootTaxaBlock\">";
  for (i in parent)
	{
	  if (taxon[i])
		{
		  t++;
		  tx[i] = "t" t;
		  print "    <otu id=\"" tx[i] "\" label=\"" taxon[i] "\"/>";
		}
	}
  print "  </otus>";

  print "  <trees otus=\"tax1\" id=\"Trees\">";
  print "     <tree id=\"tree1\" xsi:type=\"nex:FloatTree\" label=\"tree1\">";
  # nodes
  for (i in parent)
	{
	  n++;
	  nd[i] = "n" n;
	  if (parent[i] == "NULL") root = " root=\"true\"" ;
	  else root = "";
	  if (tx[i]) ndtx = " otu=\"" tx[i] "\"" ;
	  else ndtx = "";
	  print "      <node id=\"" nd[i] "\" label=\"" nd[i] "\"" ndtx root " />";
	}

  # edges
  for (i in parent)
	{
	  e++;
	  ed[i] = "e" n;
	  if (hasBL) 
		{
		  # float or int
		  if (bl[i] = int(bl[i])) leng = " length=\"" bl[i] ".0\"" ;
		  else leng = " length=\"" bl[i] "\"" ;
		}
	  else leng = "";
	  if (parent[i] == "NULL") 
		{
		  print "      <rootedge id=\"" ed[i] "\" target=\"" nd[i] "\"" \
			leng "/>"
		}
	  else
		{
		  print "      <edge id=\"" ed[i] "\" target=\"" nd[i] "\" source=\"" \
			nd[parent[i]] "\"" leng "/>";
		}
	}

  print "    </tree>\n  </trees>\n</nexml>";
}


