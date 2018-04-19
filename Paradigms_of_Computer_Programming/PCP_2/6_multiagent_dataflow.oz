% Common Features

%- Agents:
%-- have identity
%-- recieve messages
%-- process messages
%-- reply to messages

%- Message Sending
%-- Message - data structure
%-- Adress  - port
%-- Mailbox - stream of messages
%-- Reply   - dataflow variable in message


% Named Stream - Ports

%- Port name:[S]
%-- stores stream S under unique adress (oz name)
%-- stored stream changes over time
%-- The S is tail of message stream
%--- sending a message M adds message to end

%- Port a:[S]
%- Send M to a
%-- read stored stream S from address a
%-- create new store variable S’
%-- bind S to M|S’
%-- update stored stream to S’

%- Port Procedures:
%-- Port creation
P={NewPort Xs}
%-- Message sending
{Send P X}

declare S P
P={NewPort S}
{Browse S} % _
{Send P a} % a|_

%-- non-determinism becomes an issue:
thread {Send P b} end   % either c|b|a|_
thread {Send P c} end   % or     b|c|a|_

%- Answering Messages I
%-- Include the port of the sender in the message
{Send P pair(Message P’)}
%-- Reciever sends answer message to P’
{Send P’ AnsMessage}

%- Answering Messages II
%-- Do not reply by adress, use something like pre-addressed reply envelope
%--- dataflow variable
{Send P pair(Message Answer)}
%-- Receiver can bind Answer
%-- Answer = AnsMessage

declare
S P = {NewPort S}
{Browse S}
for E in S do
   {Browse E}
   case E of pair(r X) then X = ok
   else skip end
end

{Send P a}
{Send P b}

declare R
{Browse R}
{Send P pair(r R)}

{Send P pair(r _)}
{Send P notpair(r _)}
{Browse S}


% Stateless Agents out of Ports

%- A Math Agent
proc {Math M}
   case M
   of add(N M A) then A=N+M
   [] mul(N M A) then A=N*M
   [] int(Formula A) then
	  A = ...
   end
end

%- Making the Agent Work
%.
MP = {NewPort S}
proc {MathProcess Ms}
   case Ms of M|Mr then
	  {Math M} {MathProcess Mr}
   end
end
thread {MathProcess S} end

proc {ForAll Xs P}
   case Xs
   of nil then skip
   [] X|Xr then {P X} {ForAll Xr P}
   end
end
%..
proc {MathProcess Ms}
   {ForAll Ms Math}
end
%..
MP = {NewPort S}
thread {ForAll S Math} end
%.
MP = {NewPort S}
thread for M in S do {Math M} end end

%..
fun {NewAgent0 Process}
   Port Stream
in
   Port={NewPort Stream}
   thread {ForAll Stream Process} end
   Port
end

%.
fun {NewAgent0 Process}
   Port Stream
in
   Port={NewPort Stream}
   thread
	  for M in Stream do {Process M} end
   end
   Port
end

%- Model to capture communicating entities
%- Each agent is simply defined in terms of how it replies to messages
%- Each agent has a thread of its own
%-- no screw-up with concurrency
%-- we can easily extend the model so that each agent has a state (encapsulated)


% Message Sending: Properties:
%- asynchronous,
%- ordered per thread,
%- no order from multiple threads,
%- first-class messages.

P={NewPort S}
thread ... {Send P M} ... end   % (1)
thread ... {Process S} ... end  % (2)
%- Asynchronous: (1) continues immediately after sending,
%- Sender does not know when message is processed (which happens eventually).

%-- Asynchronous Reply:
%--- Sender sends message containing dataflow variable for answer:
%---- does not wait for receipt,
%---- does not wait for answer when sending.
%--- Waiting for answer, only if answer needed.
%--- Helps to avoid latency:
%---- sender continues computation
%---- receiver might already deliver message

%-- Synchronous Sending:
%--- Sometimes more synchronization is needed:
%---- sender wants to synchronize with the receiver upon receipt of message,
%---- known as: handshake, rendezvous.
%--- Can also be used for delivering reply:
%---- sender does (or does not) wait for the reply.

proc {Wait X}
   if X==1 then skip else skip end
end

proc {SyncSend P M}
   Ack in {Send P M#Ack}
   {Wait Ack}
end

proc {Process MA}
   case MA of M#Ack then
	  Ack=okay ...
   end
end


proc {AsyncSyncSend P M}
   thread {SyncSend P M} end
end

%- Message Order:
%-- Order on same thread: A always before B:
thread
   ... {Send P A} ... {Send P B} ...
end

%-- No order among threads:
thread ... {Send P A} ... end
thread ... {Send P B} ... end

%- Messages:
%-- Important aspect of agents:
%--- messages are first-class values: they can be computed, tested, manipulated, stored;
%--- can contain any data structure including procedure values.
%-- First-class messages are expensive:
%--- messages recieved stored in a log,
%--- agent forwards by adding time-stamp to the message.

proc {ComputeAgent M}
   case M
   of run(P) then {P}
   [] run(F R) then R={F}
   end
end
%- A Compute Server runs as an agent in its own thread.
%- Executes procedures contained in the messages.

%- Distribution
%-- Spawn computations across several computers connected by network.
%-- Message sending is an important way to structure distributed programs.
%-- Compute servers make sense in this setting.
%-- Oz: transparent distribution.

fun {CellProcess S M}
   case M
   of assign(New) then
	  New
   [] access(Old) then
	  Old=S S
   end
end


fun {NewAgent Process InitState}
   Port Stream
in
   Port={NewPort Stream}
   thread Dummy in
	  Dummy={FoldL Stream Process InitState}
   end
   Port
end

fun {FoldL Xs F S}
   case Xs
   of nil then S
   [] X|Xr then {FoldL Xr F {F S X}}
   end
end

%- Uniform Interfaces
%-- creation and use of an agent:
declare Cell
Cell={NewAgent CellProcess 0}
{Send Cell assign(1)}
{Browse {Send Cell access($)}}
%-- goal (uniform interface):
{Cell assign(1)}
{Browse {Cell access($)}}

fun {NewAgent Process InitState}
   Port Stream
in
   Port={NewPort Stream}
   thread Dummy in
	  Dummy={FoldL Stream Process InitState}
   end
   proc {$ M} {Send Port M} end
end


% Protocols:
%- Rules for sending and receiving messages.
%- An example: broadcasting messages to a group of agents.
%- They are deadlock free.

%- General Broadcast
proc {Broadcast As M}
   for A in As do {A M} end
end

%-- an agent-oriented view: Broadcast Agent
fun {BA S M}
   case M
   of init(As) then state(agents:As)
   [] broadcast(M1) then
	  for A in S.agents do {A M1} end
	  S
   else S end
end

%-- Broadcaster Scenario
fun {BrowseF S M}
   {Browse (S.name)#M} S
end
Broadcaster = {NewAgent BA state}
As = for I in 1..10 collect:C do
		{C {NewAgent BrowseF state(name:I)}}
	 end
{Broadcaster init(As)}
{Broadcaster broadcast(a)}

%- Contract Nets:
%-- Given a user and a set of providers:
%--- the user sends a query to all providers,
%--- each provider responds with information (price, location, etc.).
%--- The user selects the provider that is the most suitable. It then informs all providers of its decision.

%-- Coordinator:
%--- Broadcasts a request enquiry to all slaves;
%--- Completes the whole protocol before responding to another client.

%-- Slave:
%--- Receives request message;
%--- Sends a status reply;
%--- Waits until a decision is made (reserve or reject)

choose(pos:FN id:Agent) then
Rs Reply in
Rs={Map S.agents
	fun {$ Slave} A in
	   {Slave request(floor:FN answer:A)}
	   A
	end}
Reply={Minimize Rs}
Agent=Reply.id
for R in Rs do
   R.answer = if Agent==R.id then reserve else reject end
end

%-- By using a coordinator:
%--- The protocol can be made transactional,
%--- it can be fully finished before starting the next one.
%--- Dataflow variables are used as private channels within one protocol session.
