% We can check if a string is a palindrome by checking two times this string
% (from the beginning to the end, and from the end to the beginning). However,
% we can also make this check using a data structure that allows us to remove
% the first and the last elements to compare them. Such a data structure is
% represented by Sequence class.

declare

class Sequence
   attr seq

   meth init
	  seq:=nil
   end

   meth isEmpty($)
	  @seq==nil
   end

   meth first($)
	  @seq.1
   end

   meth last($)
	  local L={Length @seq} in
		 {Nth @seq L}
	  end
   end

   meth insertFirst(X)
	  seq:=X|@seq
   end

   meth insertLast(X)
	  local Seq L={Length @seq} in
		 Seq=@seq
		 seq:=X|nil
		 for I in L..1;~1 do
			seq:={Nth Seq I}|@seq
		 end
	  end
   end

   meth removeFirst
	  seq:=@seq.2
   end

   meth removeLast
	  local Seq=@seq L={Length @seq} in
		 seq:=nil
		 for I in L-1..1;~1 do
			seq:={Nth Seq I}|@seq
		 end
	  end
   end
end

fun {Palindrome Xs}
   S={New Sequence init}
   fun {Check}
      if {S isEmpty($)} then true
      else
         if {S first($)}=={S last($)} then
            {S removeFirst}
            {S removeLast}
            {Check}
         else false end
      end
   end
in
   for I in Xs do
      {S insertFirst(I)}
   end
   {Check}
end
