%%
clear
close all
% data = cell(6,7);
bagname= string({'estimate04.bag','estimate081.bag','estimate082.bag','estimate083.bag','estimate084.bag'});
for i = 1:5
bag = rosbag(bagname(i));
info = select(bag,'Time', [bag.StartTime bag.EndTime],'Topic','/kf_x3v3');
x3v3 = readMessages(info,'DataFormat','struct');
t = cellfun(@(m) double(m.Header.Stamp.Sec),x3v3) + ...
            cellfun(@(m) double(m.Header.Stamp.Nsec),x3v3)*1e-09;
t = t - t(1);
x = cellfun(@(m) double(m.Pose.Position.X),x3v3);
y = cellfun(@(m) double(m.Pose.Position.Y),x3v3);
z = cellfun(@(m) double(m.Pose.Position.Z),x3v3);
vx = cellfun(@(m) double(m.Pose.Orientation.X),x3v3);
vy = cellfun(@(m) double(m.Pose.Orientation.Y),x3v3);
vz = cellfun(@(m) double(m.Pose.Orientation.Z),x3v3);

[~, mvzi] = max(vz * sign(vz(1)));
warmup = max([8, mvzi]);
data(i,:) = {t(warmup:end)-t(warmup),x(warmup:end),y(warmup:end),z(warmup:end),vx(warmup:end),vy(warmup:end),vz(warmup:end)};
% plot(t(warmup:end), z(warmup:end), t(warmup:end), vz(warmup:end))
end
data(6,:) = {'t','x','y','z','vx','vy','vz'};
% cell2mat(data(1,1))
