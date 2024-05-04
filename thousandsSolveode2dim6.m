clear
load('data.mat')

poola = linspace(0,0.1,11);
poolb = linspace(0,0.2,21);
poolc = linspace(0,0.1,11);
L = {poola,poolb,poolc};
n = length(L);
[L{:}] = ndgrid(L{end:-1:1});
L = cat(n+1,L{:});
L = fliplr(reshape(L,[],n));
sizeL = size(L);
rowsL = sizeL(1);
result = zeros(rowsL,1);
global a;
global b;
global c;
global targetHeight;
for j = 1:rowsL
j
a = L(j,1);
b = L(j,2);
c = L(j,3);
total_obj = 0;
for i = 1:5
t_real = cell2mat(data(i,1));
x = cell2mat(data(i,2));
y = cell2mat(data(i,3));
z = cell2mat(data(i,4));
vx = cell2mat(data(i,5));
vy = cell2mat(data(i,6));
vz = cell2mat(data(i,7));
px0 = x(1);
py0 = y(1);
pz0 = z(1);
vx0 = vx(1);
vy0 = vy(1);
vz0 = vz(1);
range = find(z<0.5);
t_target = t_real(range(1));
x_target = x(range(1));
y_target = y(range(1));
targetHeight = z(range(1));
% options = odeset('Events',@events,'OutputFcn',@odeplot,'OutputSel',[3],...
%    'Refine',4);
options = odeset('Events',@events,'Refine',4);
y0 = [px0;py0;pz0;vx0;vy0;vz0];
% Solve until the first terminal event.
[t,y,te,ye,ie] = ode45(@f,[0 10],y0,options);
% hold on
% plot(t_real,z)

% Accumulate output
t_diff = abs(t_target - te);
xy_diff = sqrt((x_target - ye(1))^2 + (y_target - ye(2))^2);
obj = t_diff + xy_diff;
total_obj = total_obj + obj;
end
result(j) = total_obj;
end
L(:,4) = result;
S = sortrows(L,4);
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