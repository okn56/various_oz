% Explicit state

%- A cell is a pair of two variables
%-- First is bound to the name of the cell (a constant)
%-- Second is the cell's content

declare
A=5
B=6
C={NewCell A} % Create a cell
{Browse @C}   % Display content  / 5
C:=B          % Change content
{Browse @C}   % Display content  / 6


X={NewCell 0}
X:=5
Y=X
Y:=10
@X==10  % true
X==Y    % true

X={NewCell 0}
Y={NewCell 0}
X==Y          % false
@X==@Y        % true

%- Structure and token equality

A=[1 2]
B=[1 2]
{Browse A==B} % true

C={NewCell [1 2]}
D={NewCell [1 2]}
{Browse C==D}     % false
{Browse @C==@D}   % true

%- Semantics of cells

%-- There are now two stores in the abstract machine:
%--- Single-assignment store (contains variables: immutable store)
%--- Multiple-assignment store (contains cells: mutable store)

%-- The full store σ = σ1 ∪ σ2 has two parts:
%--- Single-assignment store (contains variables)
%---- σ1 = {t, u, v, x=ξ, y=ζ, z=10, w=5}
%--- Multiple-assignment store (contains pairs)
%---- σ2 = {x:t, y:w}

%-- In σ2 there are two cells, x and y
%--- The name of x is the constant ξ, the name of y is ζ
%--- The operation X:=Z changes x:t into x:z
%--- The operation @Y returns the variable w (assuming the env {X→x, Y→y, Z→z, W→w})

%-- Assigning a cell to a new content
%--- The pair is changed: the second variable is replaced by another variable
%--- The variables themself do not change, the single-assignment store is unchanged

%- Kernel language of the imperative paradigm

<s> ::= skip
        ...
        | {NewCell <y> <x>}
        | <x>:=<y>
        | <y>=@<x>

%-- There is also a second version which is equally expressive, but the second one is
%-- more convenient for concurrent programming

<s> ::= skip
        ...
        | {NewCell <y> <x>}
        | {Exchange <x> <y> <z>} % <y>=@<x> and <x>:=<z> (atomically: as one operation


%- Data abstraction

%-- two main kinds of data abstraction:
%--- object -> groups together value and operations in a single entity
%--- abstract data type -> keeps values and operations separate

%-- Abstract Data Type consists a set of values and a set of operations.
%--- A common exaple: integers
%---- Values: 1, 2, 3, ...
%---- Operations: +, -, *, ...
%--- in most of the popular uses of ADTs, the sets have no state

%--- To protect the values we can use a secure wrapper:
W={Wrap X}    % Given X, returns a protected version 'W'
X={Unwrap W}  % Given W, returns the original value X

%--- for each to-be-protected ADT a wrapper, which can be done with a procedure:
{NewWrapper Wrap Unwrap} % each call creates a pair with a new shared key

%--- A stack can be implemented as an ADT:
%---- Values: all possible stacks and elements
%---- Operations: NewStack, Push, Pop, IsEmpty
%---- The operations take as input and return as output 0+ stacks and elements
S={NewStack}
S2={Push S X}
S2={Pop S X}
{IsEmpty S}

local Wrap Unwrap in
   {NewWrapper Wrap Unwrap}

   fun {NewStack} {Wrap nil} end
   fun {Push W X} {Wrap X|{Unwrap W}} end
   fun {Pop W X} S={Unwrap W} in X=S.1 {Wrap S.2} end
   fun {IsEmpty} {Unwrap W}==nil end
end

%-- Objects -> a single object represents both a value and a set of operations.
%--- Example interface of a stack object:
S={NewStack}
{S push(X)}
{S pop(X)}
{S isEmpty(B)}

fun {NewStack}
   C={NewCell nil}
   proc {Push X} C:=X|@C end
   proc {Pop X} S=@C in C:=S.2 X=S.1 end
   proc {IsEmpty B} B=(@C==nil) end
in
   proc {$ M}  % procedure dispatching
	  case M of push(X) then {Push X}
	  [] pop(X) then {Pop X}
	  [] isEmpty(B) then {IsEmpty B} end
   end
end

%-- A stateful ADT:
local Wrap Unwrap
   {NewWrapper Wrap Unwrap}
   fun {NewStack} {Wrap {NewCell nil}} end
   proc {Push S E} C={Unwrap S} in C:=E|@C end
   fun {Pop S} C={Unwrap S} in
	  case @C of X|S1 then C:=S1 X end
   end
   fun {IsEmpty S} @{Unwrap S}==nil end
in
   Stack=stack(new:NewStack push:Push pop:Pop isEmpty:IsEmpty)
end
