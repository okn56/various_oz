% Threads

%- Each thread is sequential
%- Each thread is independent of the others
%-- There is no order defined between different threads
%-- The system executes all threads using interleaving semantics: it is as if only one thread executes at a time, with execution stepping from one thread to another
%-- The system guarantees that each thread receives a fair share of the computational capacity of the processor
%- Two threads can communicate if they share a variable

%- Thread creation:
%-- Any instruction can be executed in a new thread: thread <s> end
declare X
thread {Browse X+1} end
thread X=1 end

declare X0 X1 X2 X3 in
thread X1=1+X0 end
thread X3=X1+X2 end
{Browse [X0 X1 X2 X3]} % [_ _ _ _] =>
X0=1                   % [1 2 _ _] =>
X2=3                   % [1 2 3 5] .

%- The Browser is a dataflow program -> it executes with its own threads.
%-- For each unbound variable that is displayed, there is a thread in the Browser that waits until the variable is bound. When it is bound, the display is updated.
%-- This does not work with cells.
%--- The Browser targets the dataflow paradigm. It does not look at the content of cells, since they do not execute with dataflow.


% Streams and agents

%- A stream is a list that ends in an unbound variable -> S=a|b|c|d|S2.
%-- A stream can be extended with new elements as long as necessary.
%-- The stream can be closed by binding the end to nil.
%- A stream can be used as a communication channel between two threads.
%-- The first thread adds elements to the stream, the second reads it.

%- An agent is a concurrent activity that reads and writes streams.
%-- The simplest agent is a list function executing in one thread.
%-- Since list functions are tail-recursive, the agent can execute with a fixed memory size.
%-- This is the deep reason why single assignment is important: it makes tail-recursive list functions, which makes deterministic dataflow into a practical paradigm.
%- All list functions can be used as agents.
%-- All functional programming techniques can be used in deterministic dataflow.

%- A consumer reads the stream and performs some action:
declare
proc {Disp S}
   case S of X|S2 then {Browse X}{Disp S2} end
end

declare S
thread {Disp S} end
declare S2 in S=a|b|c|S2
declare S3 in S2=d|e|f|S3

%- A producer generates a stream of data:
fun {Prod N} {Delay 1000} N|{Prod N+1} end

declare S
thread S={Prod 1} end % Agent P
thread {Disp S} end   % Agent C

%- A transformer that modifies the stream:
fun {Trans S}
   case S of X|S2 then X*X|{Trans S2} end
end

declare S1 S2
thread S1={Prod 1} end   % Agent P
thread S2={Trans S1} end % Agent T
thread {Disp S2} end     % Agent C


% Nondeterminism

%- Each thread in a deterministic dataflow program always executes the same instructions in the same order.
%-- This is true even though the threads can vary their relative speeds from one execution to the next.
%-- Speeds can vary because of I/O, hardware interrupts, cache misses, etc.

%- A deterministic dataflow program always gives the same outputs for the same inputs, despite variations in thread speeds.
%-- We say the program has no observable nondeterminism (no race conditions).
%-- This is a major advantage of the deterministic dataflow paradigm that is not shared by the two other concurrent paradigms (message passing and shared state).

%- Nondeterminism is the ability of the system to make decisions that are visible by a running program.
%-- The application programmer does not make the decisions, and they can vary from one execution to the next.

%- The scheduler is the part of the system that decides at each moment which thread to execute <- this decision is called nondeterminism.

%- Nondeterminism is a property of any concurrent system.
%-- It must be, since the concurrent activities are independent.
%-- A crucial par of any concurrent program is how to manage its nondeterminism.
