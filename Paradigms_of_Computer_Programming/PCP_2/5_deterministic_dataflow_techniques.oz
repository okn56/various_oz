% Concurrency transparency -> adding threads at will to a program without changing the result.

%- It is only true for declarative paradigms.

declare
fun {Map Xs F}
   case Xs
   of nil then nil
   [] X|Xr then
	  {F X}|{Map Xr F}
   end
end

fun {CMap Xs F}
   case Xs
   of nil then nil
   [] X|Xr then
	  thread {F X} end |{CMap Xr F}
   end
end

declare F
{Browse {CMap [1 2 3 4] F}} % the new threads wait until F is bound
F = fun {$ X} X+1 end

% Threads can be added at will to a functional program without changing the result. Therefore it is very easy to take a functional program and make it concurrent. It suffices to insert thread ... end in those places that need concurrency.

fun {Fib X}
   if X==0 then 0
   elseif X==1 then 1
   else
	  thread {Fib X-1} end + {Fib X-2}
   end
end


% A for loop abstraction that collects results - a powerful form of list comprehension.

%- Declarative for loop - each iteration is independent
for I in [1 2 3] do {Browse I*I} end
%-- It is limited though, for example getting R=[1 4 9] as a result is impossible here:
%--- R = for I in [1 2 3] do (accumulate I*I) end

%- The ForCollect abstraction extends the for loop with accumulation:
%-- R = {ForCollect [1 2 3] proc {$C I} <stmt> end}
%--- The loop body is <stmt> -> I is the loop index, C is the <<collect procedure>>: calling {C X} in the loop will accumulate X in R
%-- R = {ForCollect [1 2 3] proc {$ C I} {C I*I} end}  % R=[1 4 9]

Acc={NewCell R} % Cell Acc contains end of the list

proc {C X}
   R2           % New end of list
in
   @Acc=X|R2    % Bind old end of list to X|R2
   Acc:=R2      % Set C to new end of list R2
end

proc {ForCollect L P R}
   Acc={NewCell R}
   proc {C X} R2 in @Acc=X|R2 Acc:=R2 end
in
   for X in L do {P C X} end
   @Acc=nil
end

%- Running ForCollect in a thread makes a concurrent agent:
R=thread {ForCollect L proc {$ C X} if X mod 2==0 then {C X*X} end end} end

%- If the collect procedure C might be used in more than one thread, a change is required.

proc {ForCollect L P R}
   Acc={NewCell R}
   proc {C X} R2 in {Exchange Acc X|R2 R2} end
in
   for X in L do {P C X} end
   {Exchange Acc nil _}
end


% Sieve of Eratosthenes -> an algorithm for calculating a sequence of primes

%- A list function that removes multiples of P:
fun {Filter L P}
   case L of H|T then
	  if H mod P \= 0 then H|{Filter T P}
	  else {Filter T P} end
   else nil
   end
end

%-- it can be turned into an agent by putting it in a thread:
thread F={Filter L P} end

%- Sieve builds the pipeline during execution:
fun {Sieve L}
   case L
   of nil then nil
   [] H|T then H|{Sieve thread {Filter T H} end}
   end
end

declare Xs Ys in
thread Xs={Prod 2} end
thread Ys={Sieve Xs} end
{Browse Ys}

%-- Concurrent deployment -> building the infrastructure  during execution

%- A required optimization:
fun {Sieve L Pn}
   case L
   of nil then nil
   [] H|T then
	  if H=<Pn then
		 H|{Sieve thread {Filter T H} end Pn}
	  else L end
   end
end


% Thread semantics:

%- Each thread has one semantic stack,
%- All stacks share the same memory.
%- There is one sequence of execution states, and threads take turns executing instructions:
%-- (MST1,σ1) → (MST2,σ2) → (MST3,σ3) → ...
%-- MST is a multiset of semantic stacks,
%-- This is called interleaving semantics,
%--- All the threads share the same processor in that case.
%- In a sequential program, execution states are in a total order,
%- In a concurrent program, execution states of the same thread are in a total order (one must happen before the other).
%-- The execution states of the complete program (with multiple threads) are in a parial order (either may happen first).
%- In a concurrent program, many executions are compatible with the partial order as in the actual execution, the scheduler chooses one.


% Digital logic simulation:

%- The deterministic dataflow paradigm makes it easy to model digital logic circuits.
%- There are two logic circuits models: combinational (no memory), and sequential (with memory).
%- Signals in time are represented as streams; logic gates are represented as agents.

%- Real digital circuits consist of gates which are interconnected using wires that carry digital signals.
%-- A digital signal is a voltage in function of time,
%--- They are meant to carry 0 or 1, but they may have noise, glitches, ringing, and other undesirable effects.
%-- A digital gate has I/O signals.
%--- The output signal is slightly delayed with respect to the input.
%--- A gate is much more than a boolean function; it is an active entity that takes input streams and calculates an output stream

fun {And A B} if A==1 andthen B==1 then 1 else 0 end end
fun {Loop S1 S2}
   case S1#S2 of (A|T1)#(B|T2) then {And A B}|{Loop T1 T2} end
end
thread Sc={Loop Sa Sb} end

%- The function GateMaker takes a two-argument boolean function Fun, where {GateMaker Fun} returns a function FunG that creates gates.
%-- Each call to FunG creates a running gate based on Fun,
%-- This gives three levels of abstraction:
%--- GateMaker is analogous to a generic class,
%--- FunG is analogous to a class,
%--- A running gate is analogous to an object.

fun {GateMaker F}
   fun {$ Xs Ys}
	  fun {GateLoop Xs Ys}
		 case Xs#Ys of (X|Xr)#(Y|Yr) then
			{F X Y}|{GateLoop Xr Yr}
		 end
	  end
   in
	  thread {GateLoop Xs Ys} end
   end
end

AndG={GateMaker fun {$ X Y} X*Y end}
OrG={GateMaker fun {$ X Y} X+Y-X*Y end}
NandG={GateMaker fun {$ X Y} 1-X*Y end}
NorG={GateMaker fun {$ X Y} 1-X-Y+X*Y end}
XorG={GateMaker fun {$ X Y} X+Y-2*X*Y end}

%- Combinational logic -> all calculation is done at the same time instant.
%-- A gate is a simple combinational function, therefore, any number of interconnected gates also defines a combinational function.

proc {FullAdder X Y Z C S}
   A B D E F
in
   A={AndG X Y}
   B={AndG Y Z}
   D={AndG X Z}
   F={OrG B D}
   C={OrG A F}
   E={XorG X Y}
   S={XorG Z E}
end

%- Sequential logic -> past values of a signal influence the present values.

fun {DelayG S} 0|S end % this gate adds a way to do just that.

%-- A latch is a simple circuit with memory -> it has two stable states and can memorize its inputs

proc {Latch C Di Do}
   A B E F
in
   F={DelayG Do}
   A={AndG C F}
   E={NotG C}
   B={AndG E Di}
   Do={OrG A B}
end
