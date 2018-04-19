% The filter Counter takes a stream of characters as input and returns another
% stream in which every element is a list of couples structured as:
%- [Character#Number] of time this Character appears
% For instance, from the stream a|b|a|c|_ :
%- [a#1]|[a#1 b#1]|[a#2 b#1]|[a#2 b#1 c#1]|_

declare
fun {Counter S}
   fun {Count L C}
	  case L of
		 nil then [C#1]
	  [] Ch#Num|T then
		 if Ch==C then Ch#(Num+1)|T
		 else Ch#Num|{Count T C} end
	  end
   end

   fun {Iterate L1 L2}
	  case L1 of H|T then
		 local C in
			C={Count L2 H}
			C|{Iterate T C}
		 end
	  [] nil then nil
	  end
   end
in
   thread {Iterate S nil} end
end
