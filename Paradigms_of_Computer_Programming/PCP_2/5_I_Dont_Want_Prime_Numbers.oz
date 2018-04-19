declare
fun {Prod X Y}
   if X>Y then nil
   else X|{Prod X+1 Y} end
end

fun{Filter L P}
   case L of H|T then
	  if H mod P == 0 then {Filter T P}
	  else H|{Filter T P} end
   else nil end
end

fun {Sieve S}
   case S of H|T then
	  H|{Sieve thread {Filter T H} end}
   else nil end
end


fun {NotPrime S1 S2}
   case S1 of H1|T2 then
	  case S2 of H2|T2 then
		 if H1==H2 then {NotPrime T1 T2}
		 else H|{NotPrime T1 S2} end
	  else S1 end
   else nil end
end
