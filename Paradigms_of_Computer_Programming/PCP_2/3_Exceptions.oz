% When building data structures, you have to make sure that an "alert" is raised
% when the user does something that he cannot do. The first step is to find
% where something that is not allowed can be done, and consider this case to
% raise an "alert", i.e. an exception.


declare
class Stack
   attr s

   meth init
	  s:=nil
   end

   meth size($)
	  {Length @s}
   end

   meth isEmpty($)
	  @s==nil
   end

   meth top($)
	  if @s==nil then
		 raise emptyStack end
	  else @s.1 end
   end

   meth push(X)
	  s:=X|@s
   end

   meth pop($)
	  if @s==nil then
		 raise emptyStack end
	  else local T in
			  T=@s.1
			  s:=@s.2
			  T
		   end
	  end
   end

end

class Queue
   attr q

   meth init
	  q:=nil
   end

   meth size($)
	  {Length @q}
   end

   meth isEmpty($)
	  @q==nil
   end

   meth front($)
	  if @q==nil then
		 raise emptyQueue end
	  else {Nth @q {Length @q}} end
   end

   meth enqueue(X)
	  q:=X|@q
   end

   meth dequeue($)
	  if @q==nil then
		 raise emptyQueue end
	  else local Len={Length @q} F Q in
			  F={Nth @q Len}
			  Q=@q
			  q:=nil
			  for I in Len-1..1;~1 do
				 q:={Nth Q I}|@q
			  end
			  F
		   end
	  end
   end

end
