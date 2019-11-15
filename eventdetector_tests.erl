% $Id: eventdetector_tests.erl,v 1.10 2019/10/31 04:37:03 leavens Exp leavens $
-module(eventdetector_tests).
-import(testing, [eqTest/3, dotests/2]).
-export([main/0, setup/0, tests/6, addObserver/2, getValue/1, feed/2]).

main() ->
    compile:file(eventdetector),
    {CountGoGos, CountGadgets, CountGGGs, 
     AccumGoGos, AccGGGs, AccumMatches} = setup(),
    dotests("eventdetector_tests $Revision: 1.10 $",
	    tests(CountGoGos, CountGadgets, CountGGGs, 
		  AccumGoGos, AccGGGs, AccumMatches)).
setup() ->
    GoGo = eventdetector:start(zero, fun gogodetect/2),
    Gadget = eventdetector:start(init, fun gadgetdetect/2),
    GoGoGadget = eventdetector:start(start, fun gogogadget/2),
    Matcher = eventdetector:start(0, fun matchingdetect/2),
    CountGoGos = eventdetector:start(0, fun count/2),
    addObserver(GoGo, CountGoGos),
    addObserver(GoGo, GoGoGadget),
    addObserver(Gadget, GoGoGadget),
    AccumGoGos = eventdetector:start([], fun accumulate/2),
    addObserver(GoGo, AccumGoGos),
    CountGadgets = eventdetector:start(0, fun count/2),
    addObserver(Gadget, CountGadgets),
    CountGGGs = eventdetector:start(0, fun count/2),
    AccGGGs = eventdetector:start([], fun accumulate/2),
    addObserver(GoGoGadget, CountGGGs),
    AccumMatches = eventdetector:start([], fun accumulate/2),
    addObserver(Matcher, AccumMatches),
    feed(GoGo, [go,stop,go,stop,stop,go,go,go,go,stop,go,stop,go,go]),
    feed(Gadget, [gadget,trinket,blanket,gadget,gadget,widget,omlet,capulet,
		  gadget,gadget,gadget,gadget,trinket]),
    feed(Matcher, [left,right,left,left,right,right,right,left,left,right]),
    timer:sleep(200), % time for messages to be delivered... (hack)
    {CountGoGos, CountGadgets, CountGGGs, 
     AccumGoGos, AccGGGs, AccumMatches}.

tests(CountGoGos, CountGadgets, CountGGGs, 
     AccumGoGos, AccGGGs, AccumMatches) ->
    [eqTest(getValue(CountGoGos),"==",4),
     eqTest(getValue(CountGadgets),"==",7),
     eqTest(getValue(CountGGGs),"==",0),
     eqTest(getValue(AccumGoGos),"==",[gogo,gogo,gogo,gogo]),
     eqTest(getValue(AccGGGs),"==",[]),
     eqTest(getValue(AccumMatches),"==",[matched,matched,matched])
     ].

% Helpers for testing, not for you to implement.
% Some transition functions, for testing purposes only.
gogodetect(zero, go) -> {go, none};
gogodetect(go, go) -> {go, gogo};
gogodetect(_, _) -> {zero, none}.
    
gadgetdetect(init, gadget) -> {init, gadget};
gadgetdetect(init,_) -> {init,none}.

gogogadget(start, gogo) -> {gogo, none};
gogogadget(start, _) -> {start, none};
gogogadget(gogo, gadget) -> {start, gogogadget};
gogogadget(gogo, _) -> {start, none}.

matchingdetect(N, left) -> {N + 1, none};
matchingdetect(1, right) -> {0, matched};
matchingdetect(N, right) -> {N-1, none}.

accumulate(Lst, Event) -> {[Event|Lst], none}.

count(N, _Event) -> {N+1, none}.

% Hook up an observer to an event detector
-spec addObserver(pid(), pid()) -> ok.
addObserver(EDPid, ObsPid) ->
    ObsPid ! {self(), add_yourself_to, EDPid},
    receive
	{added} -> ok
    after 3000 ->
	    io:format("timeout waiting for {added} message~n"),
	    exit(wrong_message)
    end.

% Get the state value of an event detector.
-spec getValue(pid()) -> any().
getValue(Pid) ->
    Pid ! {self(), state_value},
    receive
	{value_is, State} -> State
    after 3000 ->
	    io:format("timeout waiting for {value_is, State} message~n"),
	    exit(wrong_message)
    end.

% A testing helper.  Feeds a list of atoms to the Pid argument.
-spec feed(pid(),[atom()]) -> done.
feed(_Pid, []) -> done;
feed(Pid, [A|As]) ->
    Pid ! A,
    feed(Pid, As).
