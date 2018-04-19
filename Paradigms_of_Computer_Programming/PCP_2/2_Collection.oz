% the user can put new books, get the last books from the library as well as remove books, check if the library is empty and merge two libraries.

declare

class Collection
   attr a

   meth init
	  a:=nil
   end

   meth put(X)
	  a:=X|@a
   end

   meth get($)
	  local H=@a.1 in
		 a:=@a.2
		 H
	  end
   end

   meth isEmpty($)
	  @a==nil
   end

   meth union(C)
	  for while:{Not {C isEmpty($)}} do
		 a:={C get($)}|@a
	  end
   end

end
