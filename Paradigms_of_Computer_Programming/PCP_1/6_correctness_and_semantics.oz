% Program correctness



%- correctness of factorial

%-- The specification of {Fact N}   (mathematics)
%--  0! = 1
%--  n! = n*((n-1)!) when n>0

%-- The program                     (programming language)
fun {Fact N}
   if N==0 then 1 else N*{Fact N-1} end
end

%-- The semantics connects the two

%-- To execute a program using the semantics:
%--- Translate the program into kernel language
%--- Execute the translated program on the abstract machine


proc {Fact N R}
   local B in
	  B=(N==0)
	  if B then R=1
	  else local N1 R1 in
			  N1=N-1
			  {Fact N1 R1}
			  R=N*R1
		   end
	  end
   end
end


%-- Mathematical induction is used to prove for a recursive function which has
%-- a base and a general case. For ints, the base case is usually 0 or 1, and
%-- the general case n leads to the next case n+1. For lists, the base case is
%-- usually nil or a small list, and the general case T leads to the next case
%-- H|T


%-- Base case n=0
%--- The specification says: 0!=1
%--- The execution of {Fact 0}, using the semantics, gives {Fact 0}=1

%-- General case (n-1) -> n
%--- The specification says: n!=n*(n-1)!
%--- The execution of {Fact N}, using the semantics, gives {Fact N}=N*{Fact N-1}
%---- We assume that {Fact N-1}=(n-1)!
%---- We assume that the language correctly implements multiplication
%---- Therefore: {Fact N}=N*{Fact N-1} = n*(n-1)!=n!


%-- Execution of {Fact 0} (1)
%--- execute the procedure call {Fact N R} where N=0
%--- with a memory σ and an environment E

%---       contextual environment -> |          |
%-- σ = {fact=(proc {$ N R} ... end, {Fact->fact}), n=0, r}
%-- E = {Fact->fact, N->n, R->r}


%-- Execution of {Fact 0} (2)
%--- The instruction {Fact N R}, E, σ is replaced by:

%---- local B in
%----    B=(N==0)
%----    if B then R=1 else ... end
%---- end, E, σ


%-- Execution of {Fact 0} (3)
%--- The instruction body is replaced by:

%---- B=(N==0)
%---- if B then R=1 else ... end,
%---- {Fact->fact, N->n, R->r, B->b}, σ ∪ {b}


%-- Execution of {Fact 0} (4)
%--- The instruction body is replaced by:

%---- of B then R=1 else ... end, E, σ ∪ {b=true}


%-- Execution of {Fact 0} (5)
%--- The instruction body is replaced by:

%---- {Fact->fact, N->n, R->r, B->b},
%---- {fact=(proc {$ N R} ... end, {Fact->fact}), n=0, b=true, r=1}

%--- ...which shows that the result is 1



%- The Abstract machine

%-- Single-assignment memory: variables and the values they are bound to
%--- -> σ = {x1=10, x2, x3=20}
%-- Environment: Link between identifiers and variables in memory
%--- -> E = {X->x, Y->y}
%-- Semantic instruction: An instruction with its environment
%--- -> (<s>,E)
%-- Semantic stack: A stack of semantic instructions
%--- -> ST = [(<s>1,E1),...,(<s>N,EN)]
%-- Execution state: A pair of a semantic stack and the memory
%--- -> (ST,σ)
%-- Execution: A sequence of execution states
%--- -> (ST1,σ1)->(ST2,σ2)->(ST3,σ3)->...

%-- execution algorithm
%--- procedure execute(<s>)
%--- begin
%---     ST:=[(<s>,{})];              Initial semantic stack: empty environment
%---     σ:={};                       Initial memory: empty (no variables)
%---     while (ST=/={}) do
%---         pop(ST, SI);             Pop semantic instruction into SI
%---         (ST,σ):=rule(SI,(ST,σ)); Execute SI
%---     end
%--- end


%- Procedure semantics

%-- Procedure definition
%--- Create the contextual environment
%--- Store the pair of procedure and contextual environment

%-- Procedure call
%--- Create a new environment by combining two parts:
%---- The procedure's contextual environment
%---- The formal arguments (identifiers in the procedure definition), which are
%----   made to reference the actual argument values
%--- Execute the procedure body with this new environment
