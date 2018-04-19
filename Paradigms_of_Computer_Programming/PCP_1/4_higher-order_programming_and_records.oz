% Contextual environment
local P Q in
   proc {P}{Browse 100} end
   proc {Q}{P} end
   local P in
	  proc {P}{Browse 200} end
	  {Q}   % calls the proc {Q}{P} with the outer P, so 100
   end
end


declare
A=1
proc {Inc X Y} Y=X+A end


local A B C=1 D=2 in
   A=1
   proc {Add E F G}
	  E=A+D+F
   end
end


% Procedure values
%- Program
local A Inc in
   A=1
   proc {Inc X Y}
	  Y=X+A
   end
end
%- Program (kernel language)
local A in local Inc in
			  A=1
			  Inc=proc {$ X Y}
					 Y=X+A
				  end
		   end end
%- Memory
%-- a=1
%-- inc=(proc{$ X Y} Y=X+A end, {A->a})
%---    |procedure code      |  |env | env = contextual env


% Examples of higher-order programming

%- Genericty - when a function is passed as an input
declare
fun {Map F L}
   case L of nil then nil
   [] H|T then {F H}|{Map F T}
   end
end

{Browse {Map fun {$ X} X*X end [7 8 9]}}

%- Instantiation - when a function is returned as an output
declare
fun {MakeAdd A}
   fun {$ X} X+A end
end
Add5={MakeAdd 5}

{Browse {Add5 100}}

%- Function composition - take two functions as input and
%-                        return their composition
declare
fun {Compose F G}
   fun {$ X} {F {G X}} end
end
Fnew={Compose
	  fun {$ X} X*X end
	  fun {$ X} X+1 end}

{Browse {Fnew 2}}
{Browse {{Compose Fnew Fnew} 2}}

%- Abstracting an accumulator
declare
fun {FoldL L F U}
   case L
   of nil then U
   [] H|T then {FoldL T F {F U H}}
   end
end
S={FoldL [5 6 7] fun {$ X Y} X+Y end 0}

%- Encapsulation
declare
fun {Zero} 0 end
fun {Inc H}
   N={H}+1 in
   fun {$} N end
end
Three = {Inc {Inc {Inc Zero}}}

{Browse {Three}}

%- Delayed execution
proc {IfTrue Cond Stmt}
   if {Cond} then {Stmt} end
end
Stmt=proc {$} {Browse 111*111} end
{IfTrue fun {$} 1<2 end Stmt}


% Excercises
{Browse Browse} % <P/1 Browse>

declare
fun {M Int}
   fun {$} Int#{M Int-1} end
end

{Browse M}      % <P/2 M>
{Browse {M 5}}  % <P/1>

Test = {M 5}
{Browse {Test}} % 5#<P/1>


% Records
declare
L=[john paul george ringo '1337 5|*34|<'] % all are atoms
{Browse L.1}    % john
{Browse L.2.1}  % paul
{Browse {Length L}}  % 5

%- record has a atom label, each field name is a unique atom or
%- int and the field itself can be any value
declare
R=rectangle(bottom:10 left:20 top:100 right:200 color:red)

{Browse (R.top-R.bottom)*(R.right-R.left)} % 16200
{Browse {Label R}}  % rectangle
{Browse {Width R}}  % 5
{Browse {Arity R}}  % [bottom color left right top]

case R of rectangle(bottom:A left:B top:C right:D color:E)
   % matches A=10 B=20 etc.
end

%- an atom is a record whose width is 0

%- tuple is a record whose field names are successive ints from 1
{Browse pair(one two)==pair(1:one 2:two)} % true

%- list is a recursive data type built with records nil and H|T
{Browse one|two=='|'(one two)}      % true
{Browse one|two=='|'(1:one 2:two)}  % true

%- some examples
A=a(a 2:b 3:c 4:d)  % tuple
B=a(2:b 3:c 4:d a)  % tuple
C='|'(1:a 2:'|'(1:b 2:nil)) % list
D='|'(1:a 2:'|'(1:b 3:nil)) % record
