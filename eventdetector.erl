-module(eventdetector).
-export([start/2, server/3]).

% Worked on with Daniel Lam and referenced Dr. Leavens code examples

start(InitialState, TransitionFun) ->
    spawn(?MODULE, server, [InitialState, TransitionFun, []]).

server(State, Func, Observe) ->
    receive
        {Pid, add_me} ->
            Pid ! {added},
            server(State, Func, ([Pid] ++ Observe));
        {Pid, add_yourself_to, EDPid} ->
            EDPid ! {self(), add_me},
            receive 
                {added} -> Pid!{added} 
            end,
            server(State, Func, Observe);
        {Pid, state_value} ->
            Pid ! {value_is, State},
            server(State, Func, Observe);
        Atom ->
            case Func(State, Atom) of
                {NewState, none} -> 
                    server(NewState, Func, Observe);
                {NewState, Event} ->
                    [Observers ! Event || Observers <- Observe],
                    server(NewState, Func, Observe)
            end

    end.
