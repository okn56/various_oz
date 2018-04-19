% A calculator in the postfix notation.
%- Here is an example of such a notation: [2 3 + 4 * 2 /]

declare

fun {NewStack} {NewCell nil} end
fun {IsEmpty S} @S==nil end
proc {Push S X} S:=X|@S end
fun {Pop S}
   local P=@S.1 in S:=@S.2 P end
end

fun {Eval L}
   local S R in
      S={NewStack}
      R={NewStack}
      for I in {Length L}..1;~1 do
         {Push S {Nth L I}}
      end
      for while:{Not {IsEmpty S}} do
         local E in
            E={Pop S}
            case E of
               '+' then {Push R {Pop R}+{Pop R}}
			[] '-' then {Push R ~{Pop R}+{Pop R}}
			[] '*' then {Push R {Pop R}*{Pop R}}
			[] '/' then
			   local X={Pop R} Y={Pop R} in {Push R Y div X} end
            else {Push R E} end
         end
      end
      {Pop R}
   end
end


{Browse {Eval [2 3 '+' 4 '*' 10 '/']}}
