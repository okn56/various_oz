% A function that receives a port as input and returns a port as output

declare
fun {Eval Port}
   case Stream of Function#Input|T then
	  {Send Port {Function In}}
	  {Process T}
   end
end
in
local P S in
   P={NewPort S}
   thread {Process S} end
   P
end
