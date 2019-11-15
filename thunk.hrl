% $Id: thunk.hrl,v 1.1 2015/05/05 14:40:39 leavens Exp leavens $
% The FREEZE and THAW macros for delaying evaluation.
% These are using in the testing module
-define(FREEZE(Exp), {thunk, fun() -> Exp end}).
-define(THAW(Thunk), case Thunk of {thunk, TF} -> TF() end).
