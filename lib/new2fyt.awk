function new2fyt( newick      , j , k, taxa, i, done, b)
{

  # gsub(/[\']/, "", nexus);
  gsub(/\ \n\r/, "", newick);

  # check for general well-formedness
  if (gsub(/\(/,"(",newick) != gsub(/\)/,")",newick))
	{ error("Newick parse error: mismatched parentheses") }
  if (!index(newick, ";") || !index(newick, "(") || !index(newick, ")") || \
	  !index(newick, ",")) 
	  { error("Newick parse error: missing `(` `,` `)` `;` characters") }
	  
  # STARTING VALUE FOR CONSTANTS
  j     = -1;
  k     = -1;
  root = 0;

  # MOVE THROUGHT THE NEWICK FORMAT TREE CHARACTER BY CHARACTER
  i = 1;
  while (i < length(newick))
	{
	  # the end?
	  if (substr(newick,i,1) == ";") break;

	  # descend a branch, create parent
	  else if (substr(newick,i,1) == "(") 
		{
		  j++;
		  parent[j] = k;
		  taxon[j] = "";
		  nDaughter[k]++;
		  k           = j;
		  i++;
		}
	  
	  # sibling taxa
	  else if (substr(newick, i, 1) == ",")
		{
		  i++;
		}

	  # back up a node to len, keep track of locn with atn
	  else if (substr(newick, i, 1 ) == ")")
		{
		  k = parent[k];
		  atn = parent[atn];
		  i++;
		}

	  # Interior name
	  else if ((substr(newick, i, 1 ) ~ /[A-Za-z\-\_\']/) && \
		  (substr(newick, i-1, 1 ) == ")"))
		{
		  iname = "";
		  
		  while(substr(newick, i, 1) !~ /[\:\,\)\[\;]/)
			{
			  iname = iname substr(newick, i, 1);
			  i++;
			}
		  taxon[atn] = iname;
		}

	  # NOTE - IGNORE IT
	  else if (substr(newick, i, 1 ) == "[")
		{
		  while(substr(newick, i-1, 1) !~ /\]/)
			{
			  i++;
			}
		}

	  # branch length coming up
	  else if (substr(newick, i, 1 ) == ":")
		{
		  b = "";
		  i++;
		  while(substr(newick, i, 1) ~ /[0-9\.]/)
			{
			  b = b substr(newick, i, 1);
			  i++;
			}
		  if (b != "") {hasBL = 1};
		  bl[atn] = b;
		}

	  # default - it's a new taxon name
      # TODO - fix this. anytime you find a non ,:;()[] character, check to 
      # see if previous VALID character is , or ). If it is, or if character
      # is ', begin a new taxon name. If it's not, ignore. This should handle
      # whitespace, newlines and other garbage (but non-fatal) characters 
      # that currently crash the input.
	  else if ((substr(newick, i, 1 ) ~ /[A-Za-z\-\_]\'/) &&	\
		  (substr(newick, i-1, 1 ) ~ /[(,]/))
		{
		  taxa = "";
		  taxa = taxa substr(newick, i, 1);
		  i++;
	
		  # KEEP ADDING MORE
		  while ((substr(newick, i, 1) !~ /[\,\)\:\[]/) && \
				 (i < length(newick)))
			{
			  taxa = taxa substr(newick, i, 1);
			  i++;
			}
		  
		  # A NEW NAME MEANS A NEW NODE
		  j++;
		  atn = j;	    
		  parent[j]     = k;
		  taxon[j] = taxa;
		  nDaughter[k]++;
		}
	  else i++
	}

}



