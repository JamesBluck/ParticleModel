function [] = simulate(N,g, t_ini, t_end,D_in)
%Simulate will set up and run the particle model for a given set of
%parameters and initial conditions:
% N - 4^p | number of particles (using a power of 4)
% g - 0 or 0.05 | gravity
% D_in | Use Grid Optimisation 0 - no, 1 - yes

if isinteger(sqrt(N))
    error('Number of particles N, must be a power of 4')
end


ball.spring = 250; % spring constant for particles ball.spring;
ball.radius = 0.2; % radius in which particle exerts force ball.radius;
dt = 0.01; % time step size in updating formula;
l = [0;0]; % lower-left corner of box containing particles, first column of input box in SimulationStep;
u = [10;10].*sqrt(N); %  initial upper-right corner of box



% Initial Positions and approximate speed of particles 
rng(2020);
x=[l(1)+rand(1,N)*(u(1)-l(1)); l(2)+rand(1,N)*(u(2)-l(2))];
vini = 7.5;
v=2*(rand(2,N)-0.5)*vini;

% Discretising time
t = t_ini:dt:t_end;


% Use Grid Discretisation to Reduce Complexity?
global D;
D = D_in;


figure;
box on;
hold on;
axis manual;

Plot = scatter(x(1,:),x(2,:),"filled");
xlim([l(1)-0.4 u(1)+0.4]);
ylim([l(2)-0.4 u(2)+0.4]);
Plot.SizeData = 20;

set(gca,"NextPlot","replacechildren")
vid = VideoWriter("Animation","MPEG-4");
open(vid);

i=0;
% Simulation
for tn = t
    [x, v] = SimulationStep(dt, x, v, ball, [l u], g);
    %if(mod(i,1)==1)
        Plot.XData = x(1,:);
        Plot.YData = x(2,:);
        xlim([l(1)-0.4 u(1)+0.4]);
        ylim([l(2)-0.4 u(2)+0.4]);
        drawnow;
        writeVideo(vid, getframe(gcf));
        fprintf('Time Elapsed: %2.3f\n', string(tn))
    %end
    i = i+1;
end
close(vid);
end

