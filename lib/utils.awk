function error( msg ) {
  print "Content-type: text/plain\n\n";
  print msg "\n";
  exit ;
}

function findexecs(          which) {

  # test for phylomatic in path
  RS = "\n";
  "which phylomatic" | getline which;
  if ( which ~ /phylomatic/) PM = "phylomatic" ;
  else PM = "bin/phylomatic" ; # need symlink in same dir

  # rapper
  RS = "\n";
  "which rapper" | getline which;
  if ( which ~ /rapper/) RAPPER = "rapper" ;
  else RAPPER = "bin/rapper" ; # need symlink in same dir

  # xgawk
  RS = "\n";
  "which xgawk" | getline which;
  if ( which ~ /xgawk/) XGAWK = "xgawk" ;
  else XGAWK = "bin/xgawk" ; # need symlink in same dir
}

# decode urlencoded string
function decode(text,   hex, i, hextab, decoded, len, c, c1, c2, code) {
	
  split("0 1 2 3 4 5 6 7 8 9 a b c d e f", hex, " ")
  for (i=0; i<16; i++) hextab[hex[i+1]] = i
  
  # urldecode function from Heiner Steven
  # http://www.shelldorado.com/scripts/cmds/urldecode

  # decode %xx to ASCII char 
  decoded = ""
  i = 1
  len = length(text)
  
  while ( i <= len ) {
    c = substr (text, i, 1)
    if ( c == "%" ) {
      if ( i+2 <= len ) {
	c1 = tolower(substr(text, i+1, 1))
	c2 = tolower(substr(text, i+2, 1))
	if ( hextab [c1] != "" || hextab [c2] != "" ) {
	  # print "Read: %" c1 c2;
	  # Allow: 
	  # 20 begins main chars, but dissallow 7F (wrong in orig code!)
	       # tab, newline, formfeed, carriage return
	  if ( ( (c1 >= 2) && ((c1 c2) != "7f") )  \
	       || (c1 == 0 && c2 ~ "[9acd]") )
	  {
	    code = 0 + hextab [c1] * 16 + hextab [c2] + 0
	    # print "Code: " code
	    c = sprintf ("%c", code)
	  } else {
	    # for dissallowed chars
	    c = " "
	  }
	  i = i + 2
	}
      }
    } else if ( c == "+" ) {	# special handling: "+" means " "
      c = " "
    }
    decoded = decoded c
    ++i
  }
  
  # # change linebreaks to \n
  gsub(/\r\n/, "\n", decoded);
  # # remove last linebreak
  sub(/[\n\r]*$/,"",decoded);

  # change linebreaks to space
  # gsub(/\r?\n/, " ", decoded);
  
  return decoded
}


function encode(text            , hextab, i, ord, hi, lo, encoded )
{

  # derived from urlencode function from Heiner Steven
  # http://www.shelldorado.com/scripts/cmds/urlencode
  
  split ("1 2 3 4 5 6 7 8 9 A B C D E F", hextab, " ")
  hextab[0] = 0
  for ( i=1; i<=255; ++i ) ord[ sprintf ("%c", i) "" ] = i + 0

  encoded = ""
  encing = 0;
  for ( i=1; i <= length(text); ++i ) 
	{
	  c = substr (text, i, 1)
	  if ((c == "'") && (!encing)) { encing = 1 ; encoded = encoded "'" }
	  else if ((c == "'") && (encing)) { encing = 0 ;encoded = encoded "'" }
	  else if(!encing) { encoded = encoded c } 
	  else if ( c ~ /[a-zA-Z0-9]/ ) encoded = encoded c # safe character
      else 
		{
		  # unsafe character, encode it as a two-digit hex-number
		  lo = ord [c] % 16
		  hi = int (ord [c] / 16);
		  encoded = encoded "%" hextab [hi] hextab [lo]
		}
	}

  return encoded;
}


