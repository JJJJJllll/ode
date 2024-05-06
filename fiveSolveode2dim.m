clear
close all
load('data.mat')

poola = linspace(0,3,31);
poolb = linspace(0,1.5,16);
poolc = linspace(0,1.5,16);
L = {poola,poolb,poolc};
n = length(L);
[L{:}] = ndgrid(L{end:-1:1});
L = cat(n+1,L{:});
L = fliplr(reshape(L,[],n));
result = [];
error(1,:) = {'time error (sec)','xy error (cm)'};
global a;
global b;
global c;
global targetHeight;
% for j = 1:length(L)
% j = 273;
% a = L(j,1);
% b = L(j,2);
% c = L(j,3);
a = 0.04;
b = 0.00;
c = 0.1;
total_obj = 0;
for i = 2:5
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
options = odeset('Events',@events,'OutputFcn',@odeplot,'OutputSel',[3],...
   'Refine',4);
% options = odeset('Events',@events,'Refine',4);
y0 = [px0;py0;pz0;vx0;vy0;vz0];
% Solve until the first terminal event.
subplot(1,4,i-1)
[t,y,te,ye,ie] = ode45(@f,[0 10],y0,options);
hold on
plot(t_real,z)

% Accumulate output
t_diff = abs(t_target - te);
xy_diff = sqrt((x_target - ye(1))^2 + (y_target - ye(2))^2);
obj = t_diff + xy_diff;
total_obj = total_obj + obj;
error(i,:) = {t_diff, xy_diff * 100};
subtitle({sprintf('time error: %.2f sec',t_diff),sprintf('xy error: %.2f cm',xy_diff * 100)})
end
result = [result; total_obj];
% end
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