% Expressions may contain sub-expressions. When you perform a computation
% mentally, you often "cut" the expression to make it easier. For instance,
% if you have to compute the difficult calculus (5+4)*(5-4), you will compute
% (5+4)=9, then (5-4)=1 and finally 9*1=9. This is a program that represents
% this kind of expression hierarchy.

declare

class Constant
    attr const
    meth init(X) const:=X end
    meth evaluate(R) R=@const end
end

class Variable
    attr var
    meth init(X) var:=X end
    meth set(X) var:=X end
    meth evaluate(R) R=@var end
end

class Addition
    attr x y
    meth init(X Y) x:=X y:=Y end
    meth evaluate(R)
        local X Y in
            {@x evaluate(X)} {@y evaluate(Y)}
            R=X+Y
        end
    end
end

class Subtraction
    attr x y
    meth init(X Y) x:=X y:=Y end
    meth evaluate(R)
        local X Y in
            {@x evaluate(X)} {@y evaluate(Y)}
            R=X-Y
        end
    end
end

class Multiplication
    attr x y
    meth init(X Y) x:=X y:=Y end
    meth evaluate(R)
        local X Y in
            {@x evaluate(X)} {@y evaluate(Y)}
            R=X*Y
        end
    end
end

class Division
    attr x y
    meth init(X Y) x:=X y:=Y end
    meth evaluate(R)
        local X Y in
            {@x evaluate(X)} {@y evaluate(Y)}
            R=X div Y
        end
    end
end


% an example of use:

declare
VarX = {New Variable init(0)}
VarY = {New Variable init(0)}
local
   Result
   C = {New Constant init(6)}
   Expr1 = {New Addition init(VarX VarY)}
   Expr2 = {New Division init(Expr1 C)}
in
   {VarX set(3)}
   {VarY set(4)}
   {Expr2 evaluate(Result)}
   {Browse Result}
end
