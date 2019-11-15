% $Id: salesdata.hrl,v 1.1 2013/04/11 02:24:12 leavens Exp $
% Record definitions for the salesdata() type.
-record(store, {address :: string(), amounts :: [integer()]}).
-record(group, {gname :: string(), members :: [salesdata:salesdata()]}).
