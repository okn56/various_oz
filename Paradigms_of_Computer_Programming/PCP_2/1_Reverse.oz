% The function Reverse reverses a list such that [1 2 3 4] becomes [4 3 2 1].
%% You are asked to transform Reverse in order to use explicit states (cells). In other words, you will not have to use recursion anymore, but for loops instead.

declare
fun {Reverse L}
   L2={NewCell nil}
in
   for E in L do
	  L2:=E|@L2
   end

   @L2

end
