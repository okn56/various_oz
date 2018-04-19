% What is an object?

%- An object is a combination of local cells and global procedures:

declare
local
   A1={NewCell l1}         % attributes -> hidden from the outside
   ...
   An={NewCell ln}
in
   proc {M1 ...} ...end  % methods -> visible from the outside (interface)
   ...
   proc {Mm ...} ...end
end

%- A counter object

declare
local
   A={NewCell 0}  % initialized to 0
in
   proc {Inc} A1:=@A1+1 end
   proc {Get X} X=@A1 end
end

{Inc}
local X in {Get X} {Browse X} end

%-- since the cell can only be accessed by the methods, the behavior is guaranteed to be correct.


% From simple objects to OOP


%- Extending an object abstraction in four steps:
%-- a single object (data abstraction)
%-- |> a single entry point (dispatch)
%-- |> creating multiple objects (instantiation)
%-- |> specialized syntax (classes)

%- 1 (single object (same as above)):

declare
local
   A1={NewCell l1}
   ...
   An={NewCell ln}
in
   proc {M1 ...} ...end
   ...
   proc {Mm ...} ...end
end


declare
local
   A={NewCell 0}
in
   proc {Inc} A1:=@A1+1 end
   proc {Get X} X=@A1 end
end

%- 2 (single entry point):

declare
local
   A1={NewCell 0}
   proc {Inc} A1:=@A1+1 end
   proc {Get X} X=@A1 end
in                            % this is called procedure dispatch
   proc {Counter M}             % M is usually called a message
	  case M of inc then {Inc}
	  [] get(X) then {Get X}
	  end
   end
end


%- 3 (create multiple objects):

declare
fun {NewCounter}
   A1={NewCell 0}
   proc {Inc} A1:=@A1+1 end
   proc {Get X} X=@A1 end
in
   proc {$ M}
	  case M of inc then {Inc}
	  [] get(X) then {Get X}
	  end
   end
end

C1={NewCounter}
C2={NewCounter}

{C1 inc}
{C1 inc}

local X in {C1 get(X)} {Browse X} end % 2
local X in {C2 get(X)} {Browse X} end % 0


%- 4 (specialized syntax):

class Counter
   attr a1
   meth init a1:=0 end
   meth inc a1:=@a1+1 end
   meth get(X) X=@a1 end
end

C1={New Counter init}
{C1 inc}
local X in {C1 get(X)} {Browse X} end

%- The new syntax guarantees that the object is constructed without error,
%- it improves readability, and lets the system improve performance


% What is a class?

%- Class is a record that groups the attributes and method definitions:
%-- Counter=c(attr:[a1] methods:m(init:Init inc:Inc get:Get))

%- The function New takes the record, creates the attr (cells), and creates
%- the object (a procedure that calls the methods with the attributes):

fun {New Class Init}
   S=(...) %S is the state (record containing attributes)
   proc {Obj M} % Obj is one-argument procedure
	  {Class.methods.{Label M} M S}
   end
in
   {Obj Init} % Obj is initialized before it is returned
   Obj
end


% Polymorphism (aka the rosponsibility principle)

class Figure
   ...
end

class Circle
   attr x y r
   meth draw ... end
   ...
end

class Line
   attr x1 y1 x2 y2
   meth draw ... end
   ...
end


class CompoundFigure
   attr figlist
   meth draw               % this def works for all possible figures
	  for F in @figlist do
		 {F draw}
	  end
   end
   ...
end


% Inheritance

%- Data abstractions are often very similar, and it might be a good idea to
%- have a parent class from which they inherit.
%- There are two rules though:
%-- 1. Prefer composition over inheritance
%-- 2. When using inheritance, always follow the substitution principle

%- ad 1. Only use inheritance in well-defined ways; when defining a class, it
%-       should be declared "final". Composition is much easier and is often
%-       sufficient, as an object refers to another object in one of its attrs
%-       without adding another interface.

%- ad 2. The use of inheritance is much easier if the substitution principle
%-       (aka LSP) is followed.
%-- When A inherits from B with objects Oa and Ob
%--- Substitution principle: Every procedure that accepts Ob must accept Oa
%--- A is a conservative extension of B.

declare
class Account
   attr balance:0
   meth transfer(Amount)
	  balance:=@balance+Amount
   end
   meth getBal(B)
	  B=@balance
   end
end

A={New Account transfer(100)}

%- conservative extension using a dynamic link
class VerboseAccount
   from Account
   meth verboseTransfer(Amount)
	  {self transfer(Amount)}
	  {Browse @balance}
   end  % this class also has the transfer and getBal methods
end

%- nonconservative extension using a static link (breaks invariants)

class AccountWithFee
   from VerboseAccount
   attr fee:5
   meth transfer(Amount)
	  VerboseAccount,transfer(Amount-@fee)
   end % the transfer method has been overridden
end

B={New AccountWithFee transfer(100)} % 95 due to the fee
{B verboseTransfer(200)} % 195 thanks to the magic of dynamic links (not 200)

%- Dynamic link: {self M}
%-- The method is chosen in the class of the object
%-- The class is only known during execution, hence the name 'dynamic link'

%- Static link: SuperClass,M
%-- The method is chosen in SuperClass
%-- The class is known during compilation, hence the name 'static link'
%-- It is only needed for overriding an existing method.
