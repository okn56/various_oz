declare
class Tree
   attr
      v
      l
      r

   meth init(V)
      v:=V
      l:=leaf
      r:=leaf
   end

   meth setLeft(T)
      l:=T
   end

   meth setRight(T)
      r:=T
   end

   meth setValue(V)
      v:=V
   end

   meth getLeft($)
      @l
   end

   meth getRight($)
      @r
   end

   meth getValue($)
      @v
   end

   meth isBalanced($)
      fun {NumOfLeaves T}
         case T of leaf then 1
         else {NumOfLeaves {T getLeft($)}}+{NumOfLeaves {T getRight($)}} end
      end
   in
      {Number.abs {NumOfLeaves @l}-{NumOfLeaves @r}}<2
   end

end
