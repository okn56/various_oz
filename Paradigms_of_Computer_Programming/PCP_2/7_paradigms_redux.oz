% Kernel representation of paradigms from this course

%- Kernel language of the functional paradigm

<s> ::= skip
        | <s>1 <s>2
        | local <x> in <s> end
        | <x>1=<x>2
        | <x>=<v>
        | if <x> then <s>1 else <s>2 end
        | {<x> <y>1 ... <y>n}
        | case <x> of <p> then <s>1 else <s>2 end
<v> ::= <number> | <procedure> | <record>
<number> ::= <int> | <float>
<procedure> ::= proc {$ <x>1 ... <x>n} <s> end
<record>, <p> ::= <lit>(<f>1:<x>1 ... <f>n:<x>n)


%- Kernel language of the object-oriented paradigm

<s> ::= skip
        | <s>1 <s>2
        | local <x> in <s> end
        | <x>1=<x>2
        | <x>=<v>
        | if <x> then <s>1 else <s>2 end
        | {<x> <y>1 ... <y>n}
        | case <x> of <p> then <s>1 else <s>2 end
        | {NewCell <x> <y>}                     % Cells
        | <y>:=<x>
        | <x>=@<y>
        | try <s>1 catch <x> then <s>2 end      % Exceptions
        | raise <x> end
<v> ::= <number> | <procedure> | <record>
<number> ::= <int> | <float>
<procedure> ::= proc {$ <x>1 ... <x>n} <s> end
<record>, <p> ::= <lit>(<f>1:<x>1 ... <f>n:<x>n)


%- Kernel language of the deterministic dataflow paradigm

<s> ::= skip
        | <s>1 <s>2
        | local <x> in <s> end
        | <x>1=<x>2
        | <x>=<v>
        | if <x> then <s>1 else <s>2 end
        | {<x> <y>1 ... <y>n}
        | case <x> of <p> then <s>1 else <s>2 end
        | thread <s> end                        % Threads
<v> ::= <number> | <procedure> | <record>
<number> ::= <int> | <float>
<procedure> ::= proc {$ <x>1 ... <x>n} <s> end
<record>, <p> ::= <lit>(<f>1:<x>1 ... <f>n:<x>n)


%- Kernel language of the multi-agent dataflow paradigm

<s> ::= skip
        | <s>1 <s>2
        | local <x> in <s> end
        | <x>1=<x>2
        | <x>=<v>
        | if <x> then <s>1 else <s>2 end
        | {<x> <y>1 ... <y>n}
        | case <x> of <p> then <s>1 else <s>2 end
        | thread <s> end                        % Threads
        | {NewPort <x> <y>}                     % Ports
        | {Send <x> <y>}
<v> ::= <number> | <procedure> | <record>
<number> ::= <int> | <float>
<procedure> ::= proc {$ <x>1 ... <x>n} <s> end
<record>, <p> ::= <lit>(<f>1:<x>1 ... <f>n:<x>n)


%- Kernel language of the active objects paradigm

<s> ::= skip
        | <s>1 <s>2
        | local <x> in <s> end
        | <x>1=<x>2
        | <x>=<v>
        | if <x> then <s>1 else <s>2 end
        | {<x> <y>1 ... <y>n}
        | case <x> of <p> then <s>1 else <s>2 end
        | thread <s> end                        % Threads
        | {NewPort <x> <y>}                     % Ports
        | {Send <x> <y>}
        | {NewCell <x> <y>}                     % Cells
        | <y>:=<x>
        | <x>=@<y>
        | try <s>1 catch <x> then <s>2 end      % Exceptions
        | raise <x> end
<v> ::= <number> | <procedure> | <record>
<number> ::= <int> | <float>
<procedure> ::= proc {$ <x>1 ... <x>n} <s> end
<record>, <p> ::= <lit>(<f>1:<x>1 ... <f>n:<x>n)


% The Paradigm Jungle
%- A paradigm = a set of concepts organized as a kernel language.
%- Kernel languages of different paradigms are related - often two kernel languages differ only in one concept.
%- The kernel languages can be organized as a family tree:
%-- Two paradigms are linked when they differ in exacly one concept,
%-- This gives us a taxonomy of programming paradigms.


% The creative extension principle
%- When, in a given paradigm, programs start getting complicated for technical reasons that are unrelated to the problem being solved, then there is a new programming concept waiting to be discovered.
%- The concept of concurrency - if given paradigm does not support it (like in C), then all routines are forced to implement it, making the programs complicated.
%- The concept of exceptions - if given paradigm does not support them (like in C), then all routines on the call path must test and return error codes. If the paradigm does support them, then only the ends of the call path need to be changed (raise and catch exceptions).

% Complete set of concepts
<s> ::=                                         % Descriptive declarative
        skip                                    %- Empty statement
        <x>1=<x>2                               %- Variable binding
        <x>=<record>|<number>|<procedure>       %- Value creation
        <s>1<s>2                                %- Sequential composition
        local <x> in <s> end                    %- Variable creation
                                                % Declarative
        if <x> then <s>1 else <s>2 end          %- Conditional
        case <x> of <p> then <s>1 else <s>2 end %- Pattern matching
        {<x> <x>1 ... <x>n}                     %- Prodecure invocation
        thread <s> end                          %- Thread creation
        {WaitNeeded <x>}                        %- By-need synchronization
                                                % Less declarative
        {NewName <x>}                           %- Name creation
        <x>1=!!<x>2                             %- Read-only view
        try <s>1 catch <x> then <s>2 end        %- Exception context
        raise <x> end                           %- Raise exception
        {NewPort <x>1 <x>2}                     %- Port creation
        {Send <x>1 <x>2}                        %- Port send
        {NewCell <x>1 <x>2}                     %- Cell creation
        {Exchange <x>1 <x>2 <x>3}               %- Cell exchange

        <space>                                 % Encapsulated search
