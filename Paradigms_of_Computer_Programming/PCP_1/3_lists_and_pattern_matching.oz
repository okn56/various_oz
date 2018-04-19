% Calculating with lists

declare X1 X2 in
X1=6|X2

{Browse X1}

declare X3 in
X2=7|X3

X3=nil

{Browse X1}

{Browse [6 7]==6|7|nil}

%- Built-in functions for lists
{Browse X1}
{Browse X1.1} % Head
{Browse X1.2} % Tail
{Browse X1.2.1}

%- Recursive function on a list
%- Sum of elements
declare
fun {Sum L}
	if L==nil then 0
	else L.1+{Sum L.2} end
end

{Browse {Sum X1}}

%- Tail-recursive Sum
declare
fun {Sum2 L A}
	if L==nil then A
	else {Sum2 L.2 L.1+A} end
end

{Browse {Sum2 X1 0}}

%- Nth element of a list
declare
fun {Nth L N}
	if N==1 then L.1
	else {Nth L.2 N-1} end
end

{Browse {Nth X1 2}}


%- Pattern matching
declare
fun {Sum3 L}
	case L
	of H|T then H+{Sum T}
	[] nil then 0
	end
end

{Browse {Sum3 [5 6 7]}}

declare
fun {Sum4 L A}
	case L
	of H|T then {Sum4 T H+A}
	[] nil then A
	end
end

{Browse {Sum4 [5 6 7] 0}}

%- Pattern engineering
declare
fun {Sum5 L A}
	case L
	of H1|H2|T then {Sum5 T H1+H2+A}
	[] H|T then {Sum5 T H+A}
	[] nil then A
	end
end

{Browse {Sum5 [5 6 7] 0}}


% Specification of Append
% Function append(l1, l2) returns l3
% If l1=[a1,a2,...,an] and l2=[b1,b2,...,bk]
% then l3=[a1,a2,...,an,b1,b2,...,bk]
declare
fun {Append L1 L2}
	case L1
	of nil then L2
	[] H|T then H|{Append T L2}
	end
end

{Browse {Append [1 2 5] [8 7 6]}}


declare
proc {KernelAppend L1 L2 L3}
	case L1 of nil then L3=L2
	else case L1 of H|T then
		local T3 in
			L3=H|T3
			{KernelAppend T L2 T3}
		end
	end
	end
end

{Browse {KernelAppend [1 2 5] [8 7 6]}}
