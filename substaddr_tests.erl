% $Id: substaddr_tests.erl,v 1.5 2019/10/31 04:37:03 leavens Exp leavens $
-module(substaddr_tests).
-include("salesdata.hrl").
-import(salesdata,[salesdata/0]).
-import(substaddr,[substaddr/3]).
-import(testing,[eqTest/3,dotests/2]).
-export([main/0]).

main() ->
    compile:file(substaddr),
    dotests("substaddr_tests $Revision: 1.5 $", tests()).
tests() ->
    [eqTest(substaddr(#group{gname = "StartUP!", members = []},
		       "Downtown", "50 Washington Ave."),
	    "==", #group{gname = "StartUP!", members = []}),
     eqTest(substaddr(#store{address = "The Mall", amounts = [10,32,55]},
		       "110 Main St.", "The Mall"),
	    "==", #store{address = "110 Main St.", amounts = [10,32,55]}),
     eqTest(substaddr(
	      #group{gname = "Target",
		     members = [#store{address = "The Mall", amounts = [10,32,55]}]},
		     "Substaddr", "OldAddress"),
	    "==", 
	    #group{gname = "Target",
		   members = [#store{address = "The Mall", amounts = [10,32,55]}]}),
     eqTest(substaddr(
	      #group{gname = "Target",
		     members = [#store{address = "The Mall", amounts = [10,32,55]},
				#store{address = "Downtown", amounts = [4,0,2,0]}]},
	      "253 Sears Tower", "The Mall"),
	    "==", 
	    #group{gname = "Target",
		   members = [#store{address = "253 Sears Tower", amounts = [10,32,55]},
			      #store{address = "Downtown", amounts = [4,0,2,0]}]}),
     eqTest(substaddr(
	      #group{gname = "ACME",
		     members =
			 [#group{gname = "Robucks",
				 members = [#store{address = "The Mall", amounts = [99]},
					    #store{address = "Maple St.", amounts = [32]}]},
			  #group{gname = "Target",
				 members = [#store{address = "The Mall", amounts = [10,55]},
					    #store{address = "Downtown", amounts = [4]}]}]},
       "High St.", "The Mall"),
	    "==", #group{gname = "ACME",
			 members =
			     [#group{gname = "Robucks",
				     members = [#store{address = "High St.", amounts = [99]},
						#store{address = "Maple St.", amounts = [32]}]},
			      #group{gname = "Target",
				     members = [#store{address = "High St.", amounts = [10,55]},
						#store{address = "Downtown", amounts = [4]}]}]})
    ].
