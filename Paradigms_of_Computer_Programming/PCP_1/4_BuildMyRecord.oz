declare
fun {Transform L}
   local R = {Record.make L.1 L.2.1} in
	  for
		 Name in L.2.1
		 Value in L.2.2
	  do
		 case Value
		 of nil then skip
		 [] H|T then {Transform H|T}
		 else {AdjoinAt R Name Value} end
	  end
   end
end
