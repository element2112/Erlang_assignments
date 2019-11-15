% $Id: salesdata.erl,v 1.4 2015/03/12 12:15:20 leavens Exp $
-module(salesdata).
-include("salesdata.hrl").
-export_type([salesdata/0]).

-type salesdata() :: #store{} | #group{}.
