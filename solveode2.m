clear
tout = [];
yout = [];
global a;
global b;
global c;

h0 = 1.6729;
v0 = 2.7;
a = 1.0;
b = 0.1;
c = 0.2;

options = odeset('Events',@events,'OutputFcn',@odeplot,'OutputSel',1,...
   'Refine',4);
y0 = [h0; v0];
% Solve until the first terminal event.
[t,y,te,ye,ie] = ode45(@f,[0 10],y0,options);
hold on

% Accumulate output.  This could be passed out as output arguments.
tout = [tout; t'];
yout = [yout; y'];

% TODO: 2 dim -> 6 dim, obj func: 某高度下 xy位置差
% --------------------------------------------------------------------------

function dydt = f(t,y)
% y: column vector
global a;
global b;
global c;
h = y(1);
v = y(2);
dydt = [v;  -9.8 - a * sign(v) - b * v - c * norm(v) * v];
end

% --------------------------------------------------------------------------

function [value,isterminal,direction] = events(t,y)
value = y(1) - 0.165;     % when value passes through zero
direction = -1;   % in a decreasing direction
isterminal = 1;   % stop integration
end