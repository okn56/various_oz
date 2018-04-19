declare
local NextID Body in
   NextID={NewCell 0}
   class Body
	  attr idNum
		 name:"<unnamed>"
		 orbits:null
	  meth initBody(BName OrbArd)
		 idNum:=@NextID
		 NextID:=@NextID+1
		 name:=BName
		 orbits:=OrbArd
	  end
   end
end


% Example of multiple inheritance

class Figure
   meth draw ... end
   ...
end

class Line from Figure
   meth draw ... end
   ...
end

class LinkedList
   meth forall(M)
	  ... % invoke M on all elements
   end
   ...
end

class CompoundFigure from Figure LinkedList
   meth draw
	  {self forall(draw)}
   end
   ...
end


% Exceptions
try <s>1 catch <y> then <s>2 end % Create an execution context
raise <x> end                    % Raise an exception

%- try puts a "marker" on the stack and starts executing <s>1
%- if there is no error, <s>1 executes normally and removes the marker when
%-| it terminates
%- raise is executed when there is an error, which empties the stack up to the
%-| marker (the rest of <s>1 is therefore canceled)
%-- Then <s>2 is executed
%-- <y> refers to the same variable as <x>
%-- the scope of <y> exactly covers <s>2

declare
fun {Eval E}
   if {IsNumber E} then E
   else
	  case E
	  of plus(X Y) then {Eval X}+{Eval Y}
	  [] times(X Y) then {Eval X}*{Eval Y}
	  else raise badExpression(E) end
	  end
   end
end

try
   {Browse {Eval plus(23 times(5 5))}}
   {Browse {Eval plus(23 minus(4 3))}}
catch X then {Browse X} end

%- The try has an additional finally clause, for an operation that must always
%-| be executed (in both the correct and error cases):

FH={OpenFile "foobar"}
try
   {ProcessFile FH}
catch X then
   {Show "***Exception during execution ***"}
finally {CloseFile FH} end    % always close the file
