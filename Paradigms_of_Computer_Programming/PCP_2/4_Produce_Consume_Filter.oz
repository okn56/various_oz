% {Producer N}: this agent produces a stream of consecutive integers beginning
% with 1 and ending with N (the stream is closed when N is inserted).

% {Consumer S}: this agent receives a stream of integers S and returns the sum
% of these elements.

% {Filter S}: this agent receives a stream of integers S and returns a stream
% based on S containing only odd numbers.


declare
fun {Producer N}
   fun {Prod M}
	  if M<N+1 then M|{Prod M+1}
	  else nil end
   end
in
   {Prod 1}
end

fun {Filter S}
   case S of H|T then
	  if {Int.isOdd H} then H|{Filter T}
	  else {Filter T} end
   else nil end
end

fun {Consumer S}
   case S of H|T then
	  H+{Consumer T}
   else 0 end
end

thread {Browse {Consumer {Filter {Producer 20}}}} end
