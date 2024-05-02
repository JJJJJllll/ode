clear
tout = [];
yout = [];
global a;
global b;
global c;
global targetHeight;

x0 = 1;
y0 = 1;
z0 = 1.6729;
vx0 = 1;
vy0 = 1;
vz0 = 2.7;
targetHeight = 0.165;
a = 1.0;
b = 0.1;
c = 0.2;

options = odeset('Events',@events,'OutputFcn',@odeplot,'OutputSel',[3],...
   'Refine',4);
y0 = [x0;y0;z0;vx0;vy0;vz0];
% Solve until the first terminal event.
[t,y,te,ye,ie] = ode45(@f,[0 10],y0,options);
hold on

% Accumulate output
tout = [tout; t'];
yout = [yout; y'];

% --------------------------------------------------------------------------

function dydt = f(t,y)
% y: column vector
global a;
global b;
global c;
v = [y(4);y(5);y(6)];
acc =  - a * sign(v) - b * v - c * v * norm(v) + [0;0;-9.8];
dydt = [v;  acc];
end

% --------------------------------------------------------------------------

function [value,isterminal,direction] = events(t,y)
global targetHeight;
value = y(3) - targetHeight;     % when value passes through zero
direction = -1;   % in a decreasing direction
isterminal = 1;   % stop integration
end