% Trees

%-                   | root node            |
%- <tree T> ::= leaf|t(T <tree T>...<tree T>)
%-                          ^ subtrees ^

declare
T=t(100 t(10 leaf leaf leaf) t(20 leaf leaf leaf) leaf)

%- Binary tree -> <btree T> ::= leaf | btree(T left:<btree T> right:<btree T>)

%- Ordered tree -> a binary tree that: left < head & right > head
%-- <obtree T> ::= leaf
%--                | tree(key:T value:T left:<obtree T> right: <obtree T>)

% Search Trees and Lookup

declare
T=tree(key:horse value:cheval
	   left:tree(key:dog value:chien
				 left:tree(key:cat value:chat left:leaf right:leaf)
				 right:tree(key:elephant value:elephant left:leaf right:leaf))
	   right:tree(key:mouse value:souris
				  left:tree(key:monkey value:singe left:leaf right:leaf)
				  right:tree(key:tiger value:tigre left:leaf right:leaf)))

{Browse T}

%- Search tree -> tree that is used to organize info, operated with:

%-- {Lookup K T}   -> returns the value V corresponding to key K
declare
fun {Lookup K T}
   case T of leaf then notfound
   [] tree(key:X value:V left:T1 right:T2) andthen X==K then found(V)
   [] tree(key:X value:V left:T1 right:T2) andthen X>K  then {Lookup K T1}
   [] tree(key:X value:V left:T1 right:T2) andthen X<K  then {Lookup K T2}
   end
end

{Browse {Lookup elephant T}} % found(elephant)
{Browse {Lookup lion T}}     % notfound

%-- {Insert K V T} -> returns a new tree containing (K,V)
declare
fun {Insert K W T}
   case T of leaf then tree(key:K value:W left:leaf right:leaf)
   [] tree(key:X value:V left:T1 right:T2) andthen X==K then
	  tree(key:X value:W left:T1 right:T2)
   [] tree(key:X value:V left:T1 right:T2) andthen X>K  then
	  tree(key:X value:V left:{Insert K W T1} right:T2)
   [] tree(key:X value:V left:T1 right:T2) andthen X<K  then
	  tree(key:X value:V left:T1 right:{Insert K W T2})
   end
end

{Browse {Insert elephant frog T}}
{Browse {Insert fly mouche T}}

declare
fun {RemoveSmallest T}
   case T of leaf then none
   [] tree(key:X value:V left:T1 right:T2) then
	  case {RemoveSmallest T1}
	  of none then triple(T2 X V)
	  [] triple(Tp Xp Vp) then
		 triple(tree(key:X value:V left:Tp right:T2) Xp Vp)
	  end
   end
end

%-- {Delete K T}   -> returns a new tree that does not contain K
declare
fun {Delete K T}
   case T of leaf then leaf
   [] tree(key:X value:V left:T1 right:T2) andthen X==K then
	  case {RemoveSmallest T2}
	  of none then T1
	  [] triple(Tp Yp Vp) then
		 tree(key:Yp value:Vp left:T1 right:Tp)
	  end
   [] tree(key:X value:V left:T1 right:T2) andthen X>K  then
	  tree(key:X value:V left:{Delete K T1} right:T2)
   [] tree(key:X value:V left:T1 right:T2) andthen X<K  then
	  tree(key:X value:V left:T1 right:{Delete K T2})
   end
end

{Browse {Delete horse T}}


% Computational complexity

%- Temporal complexity of the function Pascal

declare
fun {ShiftLeft L}
   case L of H|T then
	  H|{ShiftLeft T}
   else [0]
   end
end

declare
fun {ShiftRight L} 0|L end

declare
fun {AddList L1 L2}
   case L1 of H1|T1 then
	  case L2 of H2|T2 then
		 H1+H2|{AddList T1 T2}
	  end
   else nil end
end

declare
fun {Pascal N} % O(2^n)
   if N==0 then [1]
   else
	  {AddList
	   {ShiftLeft {Pascal N-1}}
	   {ShiftRight {Pascal N-1}}}
   end
end

declare
fun {FastPascal N}
   if N==0 then [1]
   else L in
	  L={FastPascal N-1}
	  {AddList {ShiftLeft L} {ShiftRight L}}
   end
end

{Browse {FastPascal 1000}}
