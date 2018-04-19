declare

fun {AndG X Y}
   case X#Y of
	  nil#nil then nil
   [] (H1|T1)#(H2|T2) then H1*H2|{AndG T1 T2}
   else X*Y
   end
end

fun {OrG X Y}
   case X#Y of
	  nil#nil then nil
   [] (H1|T1)#(H2|T2) then H1+H2-H1*H2|{AndG T1 T2}
   else X+Y-X*Y
   end
end

fun {XorG X Y}
   case X#Y of
	  nil#nil then nil
   []  (H1|T1)#(H2|T2) then H1+H2-2*H1*H2|{AndG T1 T2}
   else X+Y-2*X*Y
   end
end

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

fun {NFullAdder S1 S2}

   fun {Reverse L Acc}
	  case L of H|T then {Reverse T H|Acc}
	  else Acc
	  end
   end

   proc {Add L1 L2 R Acc H T}
	  case L1#L2 of
		 (H1|T1)#(H2|T2) then C S in
		 {FullAdder H1 H2 R C S}
		 case T1#T2 of nil#nil then
			H=S|Acc
			T=C
		 else {Add T1 T2 C S|Acc H T}
		 end
	  end
   end
in
   case S1#S2 of (H1|T1)#(H2|T2) then
	  A={Reverse H1 nil} B={Reverse H2 nil} L R
   in
	  {Add A B 0 nil L R}
	  L#R|{NFullAdder T1 T2}
   else nil
   end
end
